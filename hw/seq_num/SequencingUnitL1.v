//========================================================================
// SequencingUnitL1.v
//========================================================================
// A unit for generating and managing sequence numbers

`ifndef HW_SEQNUM_SEQUENCINGUNITL1_V
`define HW_SEQNUM_SEQUENCINGUNITL1_V

`include "hw/common/PriorityEncoder.v"
`include "intf/seq_num/SeqNumAgeIntf.v"
`include "intf/seq_num/SeqNumAllocIntf.v"
`include "intf/seq_num/SeqNumFreeIntf.v"

module SequencingUnitL1 #(
  parameter p_free_width = 2 // Number of entries that can be freed at once
)(
  input  logic clk,
  input  logic rst,

  //----------------------------------------------------------------------
  // Allocation Interface
  //----------------------------------------------------------------------

  SeqNumAllocIntf.server alloc,

  //----------------------------------------------------------------------
  // Free Interface
  //----------------------------------------------------------------------

  SeqNumFreeIntf.server free,

  //----------------------------------------------------------------------
  // Age Interface
  //----------------------------------------------------------------------

  SeqNumAgeIntf.server age
);

  localparam p_seq_num_bits = age.p_seq_num_bits;
  localparam p_num_epochs   = age.p_num_epochs;

  // Derived parameters
  localparam p_epoch_bits  = $clog2( p_num_epochs );
  localparam p_num_entries = 2 ** p_seq_num_bits;

  //----------------------------------------------------------------------
  // get_epoch
  //----------------------------------------------------------------------
  // Get the epoch from a sequence number (just bit slicing)

  function logic [p_epoch_bits-1:0] get_epoch (
    // verilator lint_off UNUSEDSIGNAL
    input logic [p_seq_num_bits-1:0] seq_num
    // verilator lint_on UNUSEDSIGNAL
  );
    return seq_num[p_seq_num_bits-1:p_seq_num_bits-p_epoch_bits];
  endfunction

  //----------------------------------------------------------------------
  // Epochs
  //----------------------------------------------------------------------
  // Pack epochs to make indexing easier with sequence numbers

  localparam ALLOC = 1'b1;
  localparam FREE  = 1'b0;

  logic epochs [p_num_entries];
  logic [p_seq_num_bits-1:0] curr_head_ptr, curr_tail_ptr;
  logic is_alloc, is_free;

  always_ff @( posedge clk ) begin
    if( rst ) epochs <= '{default: 1'b0};
    else begin

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // Allocation
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      if( is_alloc )
        epochs[curr_head_ptr] <= ALLOC;

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // Freeing
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      if( is_free )
        epochs[free.seq_num] <= FREE;
    end
  end

  //----------------------------------------------------------------------
  // Allocation
  //----------------------------------------------------------------------

  // Can only allocate if we're not about to wrap around epochs
  assign alloc.val = !(
    &(curr_head_ptr[p_seq_num_bits-p_epoch_bits-1:0]) &
    get_epoch( curr_head_ptr ) + 1 == get_epoch( curr_tail_ptr )
  );

  assign is_alloc = alloc.val & alloc.rdy;
  assign alloc.seq_num = curr_head_ptr;

  always_ff @( posedge clk ) begin
    if( rst ) begin
      curr_head_ptr <= '0;
    end else begin
      if( is_alloc ) curr_head_ptr <= curr_head_ptr + 1;
    end
  end

  //----------------------------------------------------------------------
  // Freeing
  //----------------------------------------------------------------------

  assign is_free = free.val;

  //----------------------------------------------------------------------
  // Reclaiming
  //----------------------------------------------------------------------
  // Use a priority encoder to figure out how much we can reclaim

  logic [p_free_width-1:0] reclaim_window;
  logic [p_free_width-1:0] reclaim_select;

  genvar i;
  generate
    for( i = 0; i < p_free_width; i = i + 1 ) begin
      assign reclaim_window[i] = ( epochs[curr_tail_ptr + i] == FREE );
    end
  endgenerate

  PriorityEncoder #( .p_width( p_free_width ) ) reclaim_selector (
    .in  (reclaim_window),
    .out (reclaim_select)
  );

  logic [p_seq_num_bits-1:0] entries_allocated;
  assign entries_allocated = curr_head_ptr - curr_tail_ptr;

  logic [p_seq_num_bits-1:0] curr_tail_incr;
  always_comb begin
    curr_tail_incr = '0;
    for( int j = 0; j < p_free_width; j = j + 1 ) begin
      if( 
        reclaim_select[j] &
        (p_seq_num_bits'(j) < entries_allocated)
      )
        curr_tail_incr = curr_tail_incr | p_seq_num_bits'(j + 1);
    end
  end

  always_ff @( posedge clk ) begin
    if( rst ) begin
      curr_tail_ptr <= '0;
    end else begin
      curr_tail_ptr <= curr_tail_ptr + curr_tail_incr;
    end
  end

  //----------------------------------------------------------------------
  // Age Interface
  //----------------------------------------------------------------------

  assign age.curr_tail_epoch = get_epoch( curr_tail_ptr );

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

`ifndef SYNTHESIS
  function int ceil_div_4( int val );
    return (val / 4) + ((val % 4) > 0 ? 1 : 0);
  endfunction

  function automatic string trace();
    string alloc_trace, free_trace;

    if( is_alloc )
      alloc_trace = $sformatf("%h", alloc.seq_num);
    else
      alloc_trace = {ceil_div_4(p_seq_num_bits){" "}};

    if( is_free )
      free_trace = $sformatf("%h", free.seq_num);
    else
      free_trace = {ceil_div_4(p_seq_num_bits){" "}};

    trace = $sformatf("%h:%h::%h:%h (%s) (%s)",
      get_epoch( curr_head_ptr ),
      curr_head_ptr[p_seq_num_bits-p_epoch_bits-1:0],
      get_epoch( curr_tail_ptr ),
      curr_tail_ptr[p_seq_num_bits-p_epoch_bits-1:0],
      alloc_trace,
      free_trace
    );
  endfunction
`endif

endmodule

`endif // HW_SEQNUM_SEQNUMUNITL1_V
