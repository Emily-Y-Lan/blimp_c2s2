//========================================================================
// ControlFlowUnit.v
//========================================================================
// An execute unit for handling control flow operations
//
// Since we only handle jumps, all this does is compute the return address

`ifndef HW_EXECUTE_EXECUTE_VARIANTS_L4_CONTROLFLOWUNIT_V
`define HW_EXECUTE_EXECUTE_VARIANTS_L4_CONTROLFLOWUNIT_V

`include "defs/UArch.v"
`include "intf/D__XIntf.v"
`include "intf/X__WIntf.v"

import UArch::*;

module ControlFlowUnit (
  input  logic clk,
  input  logic rst,

  //----------------------------------------------------------------------
  // D <-> X Interface
  //----------------------------------------------------------------------

  D__XIntf.X_intf D,

  //----------------------------------------------------------------------
  // X <-> W Interface
  //----------------------------------------------------------------------

  X__WIntf.X_intf W
);

  localparam p_seq_num_bits   = D.p_seq_num_bits;
  localparam p_phys_addr_bits = D.p_phys_addr_bits;
  
  //----------------------------------------------------------------------
  // Register inputs
  //----------------------------------------------------------------------

  typedef struct packed {
    logic                        val;
    logic                 [31:0] pc;
    logic   [p_seq_num_bits-1:0] seq_num;
    logic                  [4:0] waddr;
    logic [p_phys_addr_bits-1:0] preg;
    logic [p_phys_addr_bits-1:0] ppreg;
  } D_input;

  D_input D_reg;
  D_input D_reg_next;
  logic   D_xfer;
  logic   W_xfer;

  // verilator lint_off ENUMVALUE

  always_ff @( posedge clk ) begin
    if ( rst )
      D_reg <= '0;
    else
      D_reg <= D_reg_next;
  end

  always_comb begin
    D_xfer = D.val & D.rdy;
    W_xfer = W.val & W.rdy;

    if ( D_xfer )
      D_reg_next = '{ 
        val:     1'b1, 
        pc:      D.pc,
        seq_num: D.seq_num,
        waddr:   D.waddr,
        preg:    D.preg,
        ppreg:   D.ppreg
      };
    else if ( W_xfer )
      D_reg_next = '0;
    else
      D_reg_next = D_reg;
  end

  // verilator lint_on ENUMVALUE

  logic [31:0] unused_op1;
  logic [31:0] unused_op2;

  assign unused_op1 = D.op1;
  assign unused_op2 = D.op2;

  //----------------------------------------------------------------------
  // Compute return address
  //----------------------------------------------------------------------
  
  assign W.pc      = D_reg.pc;
  assign W.waddr   = D_reg.waddr;
  assign W.wdata   = D_reg.pc + 32'd4;
  assign W.wen     = 1'b1;
  assign W.seq_num = D_reg.seq_num;
  assign W.preg    = D_reg.preg;
  assign W.ppreg   = D_reg.ppreg;

  //----------------------------------------------------------------------
  // Assign remaining signals
  //----------------------------------------------------------------------

  assign D.rdy = W.rdy | (!D_reg.val);
  assign W.val = D_reg.val;

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

`ifndef SYNTHESIS
  function int ceil_div_4( int val );
    return (val / 4) + ((val % 4) > 0 ? 1 : 0);
  endfunction

  int str_len;
  assign str_len = ceil_div_4(p_seq_num_bits) + 1 + // seq_num
                   ceil_div_4(5)              + 1 + // waddr
                   8;                               // wdata

  function string trace();
    if( W.val & W.rdy )
      trace = $sformatf("%h:%h:%h",
                        W.seq_num, W.waddr, W.wdata );
    else
      trace = {str_len{" "}};
  endfunction
`endif

endmodule

`endif // HW_EXECUTE_EXECUTE_VARIANTS_L1_ALU_V
