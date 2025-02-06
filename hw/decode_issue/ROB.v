//========================================================================
// ROB.v
//========================================================================
// A reorder buffer for ensuring instructions commit in-order

`ifndef HW_DECODE_ROB_V
`define HW_DECODE_ROB_V

`include "intf/CompleteNotif.v"
`include "intf/CommitNotif.v"

//------------------------------------------------------------------------
// ROB
//------------------------------------------------------------------------

module ROB #(
  parameter p_num_entries = 32
)(
  input logic clk,
  input logic rst,

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Allocation
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  input  logic                       [4:0] alloc_waddr,
  input  logic                             alloc_wen,
  input  logic                             alloc_val,
  output logic [$clog2(p_num_entries)-1:0] alloc_seq_num,
  output logic                             alloc_rdy,

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Completion
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  CompleteNotif.sub complete,

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Commit
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  CommitNotif.pub commit
);

  if (complete.p_seq_num_bits != $clog2(p_num_entries))
    $error("Mismatch between sequence number and completion width");
  if (commit.p_seq_num_bits != $clog2(p_num_entries))
    $error("Mismatch between sequence number and commit width");

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Entries
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  typedef struct packed {
    logic [4:0] waddr;
    logic       completed;
  } rob_entry_t;

  function logic conflict(
    rob_entry_t entry,
    logic [4:0] waddr
  );
    return !entry.completed & 
           (entry.waddr == waddr) & 
           (waddr != '0);
  endfunction

  rob_entry_t rob_entries [p_num_entries];

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // ROB Head and Tail
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Maintain one more bit than needed based on the number of entries, so
  // we can tell if wraparound has occurred

  logic [$clog2(p_num_entries):0] rob_head, rob_tail;
  logic [$clog2(p_num_entries):0] rob_head_next, rob_tail_next;

  always_ff @( posedge clk ) begin
    if( rst ) begin
      rob_head <= '0;
      rob_tail <= '0;
    end else begin
      rob_head <= rob_head_next;
      rob_tail <= rob_tail_next;
    end
  end

  logic [$clog2(p_num_entries)-1:0] rob_head_idx, rob_tail_idx;
  assign rob_head_idx = rob_head[$clog2(p_num_entries)-1:0];
  assign rob_tail_idx = rob_tail[$clog2(p_num_entries)-1:0];

  logic empty, full;
  assign empty = ( rob_head_idx == rob_tail_idx ) &
                 ( rob_head[$clog2(p_num_entries)] == 
                   rob_tail[$clog2(p_num_entries)] );
  assign full  = ( rob_head_idx == rob_tail_idx ) &
                 ( rob_head[$clog2(p_num_entries)] != 
                   rob_tail[$clog2(p_num_entries)] );

  logic is_alloc, is_commit;

  always_comb begin
    if( is_alloc )
      rob_head_next = rob_head + 1;
    else
      rob_head_next = rob_head;

    if( is_commit )
      rob_tail_next = rob_tail + 1;
    else
      rob_tail_next = rob_tail;
  end

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Allocation
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic waddr_conflict[p_num_entries];

  genvar i;
  generate
    for( i = 0; i < p_num_entries; i = i + 1 ) begin
      waddr_conflict[i] = conflict( rob_entries[i], alloc_waddr );
    end
  endgenerate

  assign alloc_seq_num = rob_head_idx;
  assign alloc_rdy     = !full & !(|waddr_conflict);
  assign is_alloc      = alloc_rdy & alloc_val;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Completion
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic is_complete;
  assign is_complete = complete.val;

  logic                    [4:0] unused_commit_waddr;
  logic [commit.p_data_bits-1:0] unused_commit_wdata;
  logic                          unused_commit_wen;

  assign unused_commit_waddr = commit.waddr;
  assign unused_commit_wdata = commit.wdata;
  assign unused_commit_wen   = commit.wen;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Entry Updates
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  rob_entry_t new_entry;
  assign new_entry.waddr     = alloc_waddr;
  assign new_entry.completed = 1'b0;

  always_ff @( posedge clk ) begin
    if( rst )
      rob_entries <= '{default: {
        5'b0,
        1'b0
      }}
    if( is_alloc )
      rob_entries[rob_head_idx] <= new_entry;
    if( is_complete )
      rob_entries[complete.seq_num].completed <= 1'b1;
    if( is_commit )
      rob_entries[rob_tail_idx] <= { 5'b0, 1'b0 };
  end

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Commit
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  assign is_commit = rob_entries[rob_tail_idx].completed;

  assign commit.val     = is_commit;
  assign commit.seq_num = rob_tail_idx;

endmodule

`endif // HW_DECODE_ROB_V