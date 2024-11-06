//========================================================================
// Regfile.v
//========================================================================
// A parametrized register file, with x0 hard-coded to 0

`ifndef HW_DECODE_REGFILE_V
`define HW_DECODE_REGFILE_V

module Regfile #(
  parameter type t_entry = logic [31:0],
  parameter p_num_regs   = 32,

  parameter p_addr_bits  = $clog2(p_num_regs)
) (
  input  logic clk,
  input  logic rst,

  //----------------------------------------------------------------------
  // Read Interface
  //----------------------------------------------------------------------

  input  logic [p_addr_bits-1:0] raddr [1:0],
  output t_entry                 rdata [1:0],

  //----------------------------------------------------------------------
  // Write Interface
  //----------------------------------------------------------------------

  input  logic [p_addr_bits-1:0] waddr,
  input  t_entry                 wdata,
  input  logic                   wen
);

  //----------------------------------------------------------------------
  // Storage Elements
  //----------------------------------------------------------------------

  t_entry regs [p_num_regs-1:0];

  //----------------------------------------------------------------------
  // Read Interface
  //----------------------------------------------------------------------

  always_comb begin
    rdata[0] = regs[raddr[0]];
    rdata[1] = regs[raddr[1]];
  end

  //----------------------------------------------------------------------
  // Write interface
  //----------------------------------------------------------------------

  always_ff @( posedge clk ) begin
    if ( rst )
      regs <= '{default: '0};
    else if ( wen & ( waddr != '0 ))
      regs[waddr] <= wdata;
  end

endmodule

`endif // HW_DECODE_REGFILE_V
