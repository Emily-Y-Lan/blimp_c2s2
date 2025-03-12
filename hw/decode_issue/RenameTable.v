//========================================================================
// RenameTable.v
//========================================================================
// A pointer-based rename table, along with the accompanying free list

`ifndef HW_DECODE_RENAMETABLE_V
`define HW_DECODE_RENAMETABLE_V

`include "hw/common/PriorityEncoder.v"

module RenameTable #(
  parameter p_num_phys_regs  = 36,
  parameter p_num_read_bits  = 2,

  parameter p_phys_addr_bits = $clog( p_num_phys_regs )
) (
  input  logic clk,
  input  logic rst,

  // ---------------------------------------------------------------------
  // Allocation
  // ---------------------------------------------------------------------

  input  logic                  [4:0] alloc_areg,
  output logic [p_phys_addr_bits-1:0] alloc_preg,
  output logic [p_phys_addr_bits-1:0] alloc_ppreg,
  input  logic                        alloc_en,
  output logic                        alloc_rdy,

  // ---------------------------------------------------------------------
  // Lookup
  // ---------------------------------------------------------------------

  input  logic                  [4:0] lookup_areg [2],
  output logic [p_phys_addr_bits-1:0] lookup_preg [2],
  input  logic                        lookup_en   [2],

  // ---------------------------------------------------------------------
  // Commit
  // ---------------------------------------------------------------------
  
  CommitNotif.sub commit;
);

  // ---------------------------------------------------------------------
  // Data Structures
  // ---------------------------------------------------------------------

  typedef struct packed {
    logic                        pending;
    logic [p_phys_addr_bits-1:0] preg;
  } rt_entry_t;

  rt_entry_t rename_table [31:1]; // No x0
  logic      free_list    [p_num_phys_regs-1:1];

  // ---------------------------------------------------------------------
  // Update Logic
  // ---------------------------------------------------------------------

  logic alloc_xfer;

  logic                        free_val;
  logic [p_phys_addr_bits-1:0] free_preg;
  logic [p_phys_addr_bits-1:0] free_ppreg;

  genvar i;
  generate
    for( int i = 1; i < 32; i = i + 1 ) begin
      always_ff @( posedge clk ) begin
        if( rst ) begin
          rename_table[i] <= '{pending: 1'b0, preg: p_phys_addr_bits'(i)};
        end else begin
          if( free_val & ( free_preg == rename_table[i].preg ) )
            rename_table[i].pending <= 1'b0;
          if( alloc_xfer & ( alloc_areg == i )) begin
            rename_table[i].pending <= 1'b1;
            rename_table[i].preg    <= alloc_preg;
          end
        end
      end
    end
  endgenerate

  always_ff @( posedge clk ) begin
    if( rst ) begin
      for( int i = 1; i < 32; i = i + 1 ) begin
        free_list[i] <= 1'b0;
      end
      for( int i = 32; i < p_num_phys_regs; i = i + 1 ) begin
        free_list[i] <= 1'b1;
      end
    end else begin
      if( free_val & ( free_ppreg != 0 ) ) begin
        free_list[free_ppreg] <= 1'b0;
      end
      if( alloc_xfer & ( alloc_preg != 0 ) ) begin
        free_list[alloc_preg] <= 1'b1;
      end
    end
  end

  // ---------------------------------------------------------------------
  // Allocation
  // ---------------------------------------------------------------------

  assign alloc_xfer = alloc_en & alloc_rdy;

  // Use priority encoder to get first free physical address
  logic [p_num_phys_regs-1:1] preg_alloc_sel_in, preg_alloc_sel_out;

  generate
    for( i = 1; i < p_num_phys_regs; i = i + 1 ) begin
      assign preg_alloc_sel_in[i] = free_list[i];
    end
  endgenerate

  PriorityEncoder #( p_num_phys_regs - 1 ) preg_sel (
    .in  (preg_alloc_sel_in),
    .out (preg_alloc_sel_out)
  );

  logic [p_phys_addr_bits-1:0] preg_alloc_mask [p_num_phys_regs-1:1];

  generate
    for( i = 1; i < p_num_phys_regs; i = i + 1 ) begin
      preg_alloc_mask[i] = ( preg_alloc_sel_out[i] ) ? p_phys_addr_bits'(i)
                                                     : '0;
    end
  endgenerate

  assign alloc_preg  = preg_alloc_mask.or();
  assign alloc_ppreg = ( alloc_areg != 0 ) ? rename_table[alloc_areg].preg
                                            : 0;
  
  // Only allocate when we have an entry to give
  assign alloc_rdy = |preg_alloc_sel_in;

  // ---------------------------------------------------------------------
  // Lookup
  // ---------------------------------------------------------------------

  logic unused_lookup_en [2];
  assign unused_lookup_en[0] = lookup_en[0];
  assign unused_lookup_en[1] = lookup_en[1];

  always_comb begin
    if( lookup_areg[0] == '0 ){
      lookup_preg[0] = '0;
    } else {
      lookup_preg[0] = rename_table[lookup_areg[0]].preg;
    }

    if( lookup_areg[1] == '0 ){
      lookup_preg[1] = '0;
    } else {
      lookup_preg[1] = rename_table[lookup_areg[1]].preg;
    }
  end

  // ---------------------------------------------------------------------
  // Free on commit
  // ---------------------------------------------------------------------

  assign free_val   = commit.val;
  assign free_preg  = commit.preg;
  assign free_ppreg = commit.ppreg;

endmodule

`endif // HW_DECODE_RENAMETABLE_V