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

  input  logic [p_addr_bits-1:0] raddr   [1:0],
  output t_entry                 rdata   [1:0],

  //----------------------------------------------------------------------
  // Write Interface
  //----------------------------------------------------------------------

  input  logic [p_addr_bits-1:0] waddr,
  input  t_entry                 wdata,
  input  logic                   wen,

  //----------------------------------------------------------------------
  // Pending Interface
  //----------------------------------------------------------------------

  input  logic [p_addr_bits-1:0] pending_set_addr,
  input  logic                   pending_set_val,
  output logic                   pending [1:0]
);

  //----------------------------------------------------------------------
  // Storage Elements
  //----------------------------------------------------------------------

  t_entry regs [p_num_regs-1:1];

  //----------------------------------------------------------------------
  // Read Interface
  //----------------------------------------------------------------------

  logic forward_write [1:0];
  always_comb begin
    forward_write[0] = wen & ( raddr[0] == waddr );
    forward_write[1] = wen & ( raddr[1] == waddr );
  end

  always_comb begin
    if( raddr[0] == '0 )
      rdata[0] = '0;
    else if( forward_write[0] )
      rdata[0] = wdata;
    else
      rdata[0] = regs[raddr[0]];
    
    if( raddr[1] == '0 )
      rdata[1] = '0;
    else if( forward_write[1] )
      rdata[1] = wdata;
    else
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

  //----------------------------------------------------------------------
  // Pending Bits
  //----------------------------------------------------------------------

  logic pending_regs [p_num_regs-1:1];

  genvar i;
  generate
    for( i = 1; i < p_num_regs; i = i + 1 ) begin
      always_ff @( posedge clk ) begin
        if ( rst )
          pending_regs[i] <= 1'b0;
        else if ( pending_set_val & ( pending_set_addr == i ))
          pending_regs[i] <= 1'b1;
        else if ( wen & ( waddr == i ))
          pending_regs[i] <= 1'b0;
      end
    end
  endgenerate

  always_comb begin
    if ( raddr[0] == '0 )
      pending[0] = 1'b0;
    else
      pending[0] = !forward_write[0] & pending_regs[raddr[0]];

    if ( raddr[1] == '0 )
      pending[1] = 1'b0;
    else
      pending[1] = !forward_write[1] & pending_regs[raddr[1]];
  end

endmodule

`endif // HW_DECODE_REGFILE_V
