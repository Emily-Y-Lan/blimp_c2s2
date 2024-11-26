//========================================================================
// Multiplier.v
//========================================================================
// An execute unit for performing multiplication operations

`ifndef HW_EXECUTE_EXECUTE_VARIANTS_MULTIPLIER_V
`define HW_EXECUTE_EXECUTE_VARIANTS_MULTIPLIER_V

`include "defs/UArch.v"
`include "intf/D__XIntf.v"
`include "intf/X__WIntf.v"

import UArch::*;

module Multiplier (
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

  localparam p_addr_bits  = D.p_addr_bits;
  localparam p_data_bits  = D.p_data_bits;
  
  //----------------------------------------------------------------------
  // Register inputs
  //----------------------------------------------------------------------

  typedef struct packed {
    logic                   val;
    logic [p_data_bits-1:0] op1;
    logic [p_data_bits-1:0] op2;
    logic             [4:0] waddr;
    rv_uop                  uop;
  } D_input;

  D_input D_reg;
  D_input D_reg_next;
  logic   D_xfer;
  logic   W_xfer;

  // verilator lint_off ENUMVALUE

  always_ff @( posedge clk ) begin
    if ( rst )
      D_reg <= '{ 
        val:   1'b0, 
        op1:   'x, 
        op2:   'x,
        waddr: 'x,
        uop:   'x
      };
    else
      D_reg <= D_reg_next;
  end

  always_comb begin
    D_xfer = D.val & D.rdy;
    W_xfer = W.val & W.rdy;

    if ( D_xfer )
      D_reg_next = '{ 
        val:   1'b1, 
        op1:   D.op1, 
        op2:   D.op2,
        waddr: D.waddr,
        uop:   D.uop
      };
    else if ( W_xfer )
      D_reg_next = '{ 
        val:   1'b0, 
        op1:   'x, 
        op2:   'x,
        waddr: 'x,
        uop:   'x
      };
    else
      D_reg_next = D_reg;
  end

  // verilator lint_on ENUMVALUE

  //----------------------------------------------------------------------
  // Arithmetic Operations
  //----------------------------------------------------------------------
  
  logic [p_data_bits-1:0] op1, op2;
  assign op1 = D_reg.op1;
  assign op2 = D_reg.op2;

  rv_uop uop;
  assign uop = D_reg.uop;

  always_comb begin
    case( uop )
      OP_MUL:  W.wdata = op1 * op2;
      default: W.wdata = 'x;
    endcase
  end

  //----------------------------------------------------------------------
  // Assign remaining signals
  //----------------------------------------------------------------------

  assign D.rdy = W.rdy | (!D_reg.val);
  assign W.val = D_reg.val;

  logic [p_addr_bits-1:0] unused_pc;
  assign unused_pc = D.pc;

  assign W.wen   = 1'b1;
  assign W.waddr = D_reg.waddr;

  assign D.squash        = 1'b0;
  assign D.branch_target = 'x;

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

`ifndef SYNTHESIS
  // verilator lint_off UNUSEDSIGNAL
  string trace;
  // verilator lint_on UNUSEDSIGNAL

  function int ceil_div_4( int val );
    return (val / 4) + (val % 4);
  endfunction

  always_comb begin
    int str_len;

    str_len = 11                      + 1 + // uop
              ceil_div_4(5)           + 1 + // waddr
              ceil_div_4(p_data_bits) + 1 + // op1
              ceil_div_4(p_data_bits) + 1 + // op2
              ceil_div_4(p_data_bits);      // wdata

    if( W.val & W.rdy )
      trace = $sformatf("%11s:%h:%h:%h:%h", D_reg.uop.name(), 
                        W.waddr, op1, op2, W.wdata );
    else
      trace = {str_len{" "}};
  end
`endif

endmodule

`endif // HW_EXECUTE_EXECUTE_VARIANTS_MULTIPLIER_V
