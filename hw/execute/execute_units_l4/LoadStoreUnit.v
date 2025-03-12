//========================================================================
// LoadStoreUnit.v
//========================================================================
// An execute unit for performing memory operations

`ifndef HW_EXECUTE_EXECUTE_VARIANTS_L4_LOADSTOREUNIT_V
`define HW_EXECUTE_EXECUTE_VARIANTS_L4_LOADSTOREUNIT_V

`include "defs/UArch.v"
`include "intf/D__XIntf.v"
`include "intf/X__WIntf.v"
`include "intf/MemIntf.v"

import UArch::*;

module LoadStoreUnit #(
  parameter p_seq_num_bits = 5 // Bug with interface arrays - must pass directly
)(
  input  logic clk,
  input  logic rst,

  //----------------------------------------------------------------------
  // D <-> X Interface
  //----------------------------------------------------------------------

  D__XIntf.X_intf D,

  //----------------------------------------------------------------------
  // X <-> W Interface
  //----------------------------------------------------------------------

  X__WIntf.X_intf W,

  //----------------------------------------------------------------------
  // Memory Interface
  //----------------------------------------------------------------------

  MemIntf.client  mem
);
  
  //----------------------------------------------------------------------
  // Types
  //----------------------------------------------------------------------

  typedef struct packed {
    logic                      val;
    logic               [31:0] pc;
    logic [p_seq_num_bits-1:0] seq_num;
    logic               [31:0] op1;
    logic               [31:0] op2;
    logic                [4:0] waddr;
    rv_uop                     uop;
  } D_input;

  typedef struct packed {
    logic                      val;
    logic               [31:0] pc;
    logic [p_seq_num_bits-1:0] seq_num;
    logic                [4:0] waddr;
    logic                      wen;
  } stage2_input;
  
  //----------------------------------------------------------------------
  // Stage 1: Request
  //----------------------------------------------------------------------

  D_input D_reg;
  D_input D_reg_next;
  logic   D_xfer;

  logic        stage2_val;
  logic        stage2_rdy;
  logic        stage2_xfer;
  stage2_input stage2_msg;

  // verilator lint_off ENUMVALUE

  always_ff @( posedge clk ) begin
    if ( rst )
      D_reg <= '{ 
        val:     1'b0, 
        pc:      'x,
        seq_num: 'x,
        op1:     'x, 
        op2:     'x,
        waddr:   'x,
        uop:     'x
      };
    else
      D_reg <= D_reg_next;
  end

  always_comb begin
    D_xfer      = D.val      & D.rdy;
    stage2_xfer = stage2_val & stage2_rdy;

    if ( D_xfer )
      D_reg_next = '{ 
        val:     1'b1, 
        pc:      D.pc,
        seq_num: D.seq_num,
        op1:     D.op1, 
        op2:     D.op2,
        waddr:   D.waddr,
        uop:     D.uop
      };
    else if ( stage2_xfer )
      D_reg_next = '{ 
        val:     1'b0, 
        pc:      'x,
        seq_num: 'x,
        op1:     'x, 
        op2:     'x,
        waddr:   'x,
        uop:     'x
      };
    else
      D_reg_next = D_reg;
  end

  // verilator lint_on ENUMVALUE

  //----------------------------------------------------------------------
  // Memory Operations
  //----------------------------------------------------------------------
  
  logic [31:0] op1, op2;
  assign op1 = D_reg.op1;
  assign op2 = D_reg.op2;

  logic [31:0] addr;
  assign addr = op1 + op2;

  rv_uop uop;
  assign uop = D_reg.uop;

  always_comb begin
    case( uop )
      OP_LW:   mem.req_msg.op = MEM_MSG_READ;
      OP_SW:   mem.req_msg.op = MEM_MSG_WRITE;
      default: mem.req_msg.op = MEM_MSG_READ;
    endcase
  end

  assign mem.req_msg.opaque = '0;
  assign mem.req_msg.len    = '0;
  assign mem.req_msg.data   = 

  //----------------------------------------------------------------------
  // Assign remaining signals
  //----------------------------------------------------------------------

  assign D.rdy = W.rdy | (!D_reg.val);
  assign W.val = D_reg.val;

  assign W.pc      = D_reg.pc;
  assign W.wen     = 1'b1;
  assign W.seq_num = D_reg.seq_num;
  assign W.waddr   = D_reg.waddr;

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

`ifndef SYNTHESIS
  function int ceil_div_4( int val );
    return (val / 4) + ((val % 4) > 0 ? 1 : 0);
  endfunction

  int str_len;
  assign str_len = 11                         + 1 + // uop
                   ceil_div_4(p_seq_num_bits) + 1 + // seq_num
                   ceil_div_4(5)              + 1 + // waddr
                   8                          + 1 + // op1
                   8                          + 1 + // op2
                   8;                               // wdata

  function string trace();
    if( W.val & W.rdy )
      trace = $sformatf("%11s:%h:%h:%h:%h:%h", D_reg.uop.name(), 
                        W.seq_num, W.waddr, op1, op2, W.wdata );
    else
      trace = {str_len{" "}};
  endfunction
`endif

endmodule

`endif // HW_EXECUTE_EXECUTE_VARIANTS_L4_LOADSTOREUNIT_V
