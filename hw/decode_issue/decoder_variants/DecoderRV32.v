//========================================================================
// DecoderRV32.v
//========================================================================
// A parametrized decoder to linearize opcodes

`ifndef HW_DECODE_DECODER_VARIANTS_DECODERRV32_V
`define HW_DECODE_DECODER_VARIANTS_DECODERRV32_V

`include "defs/ISA.v"

import ISA::*;

module DecoderRV32 #(
  parameter p_isa_subset = RVS_ARITH
) (
  input  logic [31:0] inst,

  output logic        val,
  output rv_uop       uop,
  output logic [4:0]  raddr0,
  output logic [4:0]  raddr1,
  output rv_imm_type  imm_sel,
  output logic        op2_sel
);

  //----------------------------------------------------------------------
  // cs
  //----------------------------------------------------------------------
  // A task to set control signals appropriately

  task cs(
    input logic       cs_val,
    input rv_uop      cs_uop,
    input logic [4:0] cs_raddr0,
    input logic [4:0] cs_raddr1,
    input rv_imm_type cs_imm_sel,
    input logic       cs_op2_sel
  );
    val     = cs_val;
    uop     = cs_uop;
    raddr0  = cs_raddr0;
    raddr1  = cs_raddr1;
    imm_sel = cs_imm_sel;
    op2_sel = cs_op2_sel;
  endtask

  //----------------------------------------------------------------------
  // Common control signal table entries
  //----------------------------------------------------------------------

  localparam y = 1'b1;
  localparam n = 1'b0;

  // op2_sel
  localparam op2_imm = 1'b1;
  localparam op2_rf  = 1'b0;

  // raddr
  logic [4:0] rs1, rs2;
  assign rs1 = inst[19:15];
  assign rs2 = inst[24:20];

  //----------------------------------------------------------------------
  // Control Signal Table
  //----------------------------------------------------------------------

  // verilator lint_off ENUMVALUE

  generate
    always_comb begin
      cs( n, 'x, 'x, 'x, 'x, 'x );

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // Arithmetic
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      if ( p_isa_subset == RVS_ARITH ) begin
        casez ( inst ) //     v  uop     raddr0 raddr1 imm_sel op2_sel
          `RVI_INST_ADD:  cs( y, OP_ADD, rs1,   rs2,   'x,     op2_rf  );
          `RVI_INST_MUL:  cs( y, OP_MUL, rs1,   rs2,   'x,     op2_rf  );
          `RVI_INST_ADDI: cs( y, OP_ADD, rs1,   'x,    IMM_I,  op2_imm );
        endcase
      end

    end
  endgenerate

  // verilator lint_on ENUMVALUE

endmodule

`endif // HW_DECODE_DECODER_VARIANTS_DECODERRV32_V
