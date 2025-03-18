//========================================================================
// InstDecode.v
//========================================================================
// A parametrized decoder to linearize opcodes

`ifndef HW_DECODE_ISSUE_INSTDECODER_V
`define HW_DECODE_ISSUE_INSTDECODER_V

`include "defs/ISA.v"
`include "defs/UArch.v"

import ISA::*;
import UArch::*;

module InstDecoder #(
  parameter p_isa_subset = p_tinyrv1
) (
  input  logic [31:0] inst,

  output logic        val,
  output rv_uop       uop,
  output logic [4:0]  raddr0,
  output logic [4:0]  raddr1,
  output logic [4:0]  waddr,
  output logic        wen,
  output rv_imm_type  imm_sel,
  output logic        op2_sel,
  output logic [1:0]  jal,
  output logic        op3_sel
);

  //----------------------------------------------------------------------
  // cs
  //----------------------------------------------------------------------
  // A task to set control signals appropriately

  task automatic cs(
    input logic       cs_val,
    input rv_uop      cs_uop,
    input logic [1:0] cs_jal,
    input logic [4:0] cs_raddr0,
    input logic [4:0] cs_raddr1,
    input logic [4:0] cs_waddr,
    input logic       cs_wen,
    input rv_imm_type cs_imm_sel,
    input logic       cs_op2_sel,
    input logic       cs_op3_sel
  );
    val     = cs_val;
    uop     = cs_uop;
    jal     = cs_jal;
    raddr0  = cs_raddr0;
    raddr1  = cs_raddr1;
    waddr   = cs_waddr;
    wen     = cs_wen;
    imm_sel = cs_imm_sel;
    op2_sel = cs_op2_sel;
    op3_sel = cs_op3_sel;
  endtask

  //----------------------------------------------------------------------
  // Common control signal table entries
  //----------------------------------------------------------------------

  // verilator lint_off UNUSEDPARAM
  localparam y = 1'b1;
  localparam n = 1'b0;

  // op2_sel
  localparam op2_imm = 1'b1;
  localparam op2_rf  = 1'b0;
  localparam op2_x   = 1'bx;

  // raddr
  logic [4:0] rs1, rs2, rd;
  assign rs1    = inst[19:15];
  assign rs2    = inst[24:20];
  assign rd     = inst[11:7];
  localparam rx = 5'b0; // Never stalls

  // jump
  localparam j_n    = 2'd0;
  localparam j_jal  = 2'd1;
  localparam j_jalr = 2'd2;

  // op3_sel
  localparam op3_mem = 1'b0;
  localparam op3_br  = 1'b1;
  localparam op3_x   = 1'bx;
  // verilator lint_on UNUSEDPARAM

  //----------------------------------------------------------------------
  // Control Signal Table
  //----------------------------------------------------------------------

  // verilator lint_off ENUMVALUE

  generate
    always_comb begin
      cs( n, 'x, j_n, 'x, 'x, 'x, n, 'x, 'x, 'x );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // Arithmetic
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      if ( ( p_isa_subset & OP_ADD_VEC ) > 0 ) begin
        casez ( inst ) //        uop     jal  raddr0 raddr1 waddr wen imm_sel op2_sel  op3_sel
          `RVI_INST_ADD:  cs( y, OP_ADD, j_n, rs1,   rs2,   rd,   y,  'x,     op2_rf,  op3_x );
          `RVI_INST_ADDI: cs( y, OP_ADD, j_n, rs1,   rx,    rd,   y,  IMM_I,  op2_imm, op3_x );
        endcase
      end

      if ( ( p_isa_subset & OP_MUL_VEC ) > 0 ) begin
        casez ( inst ) //        uop     jal  raddr0 raddr1 waddr wen imm_sel op2_sel op3_sel
          `RVI_INST_MUL:  cs( y, OP_MUL, j_n, rs1,   rs2,   rd,   y,  'x,     op2_rf, op3_x  );
        endcase
      end

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // Memory
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      if ( ( p_isa_subset & OP_LW_VEC ) > 0 ) begin
        casez ( inst ) //       uop    jal  raddr0 raddr1 waddr wen imm_sel op2_sel  op3_sel
          `RVI_INST_LW:  cs( y, OP_LW, j_n, rs1,   rx,    rd,   y,  IMM_I,  op2_imm, op3_mem );
        endcase
      end

      if ( ( p_isa_subset & OP_SW_VEC ) > 0 ) begin
        casez ( inst ) //       uop    jal  raddr0 raddr1 waddr wen imm_sel op2_sel  op3_sel
          `RVI_INST_SW:  cs( y, OP_SW, j_n, rs1,   rs2,   rx,   n,  IMM_S,  op2_imm, op3_mem );
        endcase
      end

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // Control Flow
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      if ( ( p_isa_subset & OP_JAL_VEC ) > 0 ) begin
        casez ( inst ) //        uop     jal    raddr0 raddr1 waddr wen imm_sel op2_sel op3_sel
          `RVI_INST_JAL:  cs( y, OP_JAL, j_jal, rx,    rx,    rd,   y,  IMM_J,  op2_x,  op3_x );
        endcase
      end

      if ( ( p_isa_subset & OP_JALR_VEC ) > 0 ) begin
        casez ( inst ) //         uop      jal     raddr0 raddr1 waddr wen imm_sel op2_sel op3_sel
          `RVI_INST_JALR:  cs( y, OP_JALR, j_jalr, rs1,   rx,    rd,   y,  IMM_I,  op2_x,  op3_x );
        endcase
      end

    end
  endgenerate

  // verilator lint_on ENUMVALUE

endmodule

`endif // HW_DECODE_ISSUE_INSTDECODER_V
