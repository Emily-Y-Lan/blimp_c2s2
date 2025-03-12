//========================================================================
// RenameTable.v
//========================================================================
// A pointer-based rename table, along with the accompanying free list

`ifndef HW_DECODE_RENAMETABLE_V
`define HW_DECODE_RENAMETABLE_V

`include "hw/common/PriorityEncoder.v"

module RenameTable #(
  parameter p_num_phys_regs = 36,

  parameter p_phys_addr_bits = $clog2( p_num_phys_regs )
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
  // Complete
  // ---------------------------------------------------------------------
  
  CompleteNotif.sub complete
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
    for( i = 1; i < 32; i = i + 1 ) begin
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
      for( int j = 1; j < 32; j = j + 1 ) begin
        free_list[j] <= 1'b0;
      end
      for( int j = 32; j < p_num_phys_regs; j = j + 1 ) begin
        free_list[j] <= 1'b1;
      end
    end else begin
      if( free_val & ( free_ppreg != 0 ) ) begin
        free_list[free_ppreg] <= 1'b1;
      end
      if( alloc_xfer & ( alloc_preg != 0 ) ) begin
        free_list[alloc_preg] <= 1'b0;
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
      assign preg_alloc_mask[i] = ( preg_alloc_sel_out[i] ) ? p_phys_addr_bits'(i)
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
    if( lookup_areg[0] == '0 ) begin
      lookup_preg[0] = '0;
    end else begin
      lookup_preg[0] = rename_table[lookup_areg[0]].preg;
    end

    if( lookup_areg[1] == '0 ) begin
      lookup_preg[1] = '0;
    end else begin
      lookup_preg[1] = rename_table[lookup_areg[1]].preg;
    end
  end

  // ---------------------------------------------------------------------
  // Free on commit
  // ---------------------------------------------------------------------

  assign free_val   = complete.val;
  assign free_preg  = complete.preg;
  assign free_ppreg = complete.ppreg;

  // ---------------------------------------------------------------------
  // Linetracing
  // ---------------------------------------------------------------------

`ifndef SYNTHESIS

  string test_trace;
  int    alloc_len;
  int    lookup_len;
  int    free_len;

  initial begin
    test_trace = $sformatf("%x > %x (%x)", alloc_areg, alloc_preg, alloc_ppreg);
    alloc_len  = test_trace.len();

    test_trace = $sformatf("%x > %x", lookup_areg, lookup_preg);
    lookup_len = test_trace.len();

    test_trace = $sformatf("%x (%x)", free_preg, free_ppreg);
    free_len   = test_trace.len();
  end

  function string trace();
    trace = "[";
    if( alloc_en & alloc_rdy )
      trace = {trace, $sformatf("%x > %x (%x)", alloc_areg, alloc_preg, alloc_ppreg)};
    else
      trace = {trace, {(alloc_len){" "}}};

    trace = {trace, "] ["};

    if( lookup_en[0] )
      trace = {trace, $sformatf("%x > %x", lookup_areg[0], lookup_preg[0])};
    else
      trace = {trace, {(lookup_len){" "}}};
    trace = {trace, ", "};
    if( lookup_en[1] )
      trace = {trace, $sformatf("%x > %x", lookup_areg[1], lookup_preg[1])};
    else
      trace = {trace, {(lookup_len){" "}}};

    trace = {trace, "] ["};

    if( free_val )
      trace = {trace, $sformatf("%x (%x)", free_preg, free_ppreg)};
    else
      trace = {trace, {(free_len){" "}}};

    trace = {trace, "]"};
  endfunction
`endif

endmodule

`endif // HW_DECODE_RENAMETABLE_V
