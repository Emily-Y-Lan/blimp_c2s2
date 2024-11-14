//========================================================================
// ISA.v
//========================================================================
// Common definitions to use to describe the ISA

`ifndef DEFS_ISA_V
`define DEFS_ISA_V

package ISA;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Immediates
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Definitions of the types of immediates

  typedef enum logic [2:0] {
    IMM_I,
    IMM_S,
    IMM_B,
    IMM_U,
    IMM_J
  } rv_imm_type;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Micro-opcodes
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // A linearization of opcodes to indicate a specific instruction type

  parameter num_ops = 7;

  typedef enum logic [$clog2(num_ops)-1:0] {
    OP_ADD,
    OP_MUL,
    OP_LW,
    OP_SW,
    OP_JAL,
    OP_JALR,
    OP_BEQ
  } rv_uop;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Supported operations
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Definitions of the subsets of an ISA that can be supported. We use a
  // one-hot encoding to specify combinations of operands that are
  // supported

  parameter OP_ADD_VEC  = num_ops'(1 << 0);
  parameter OP_MUL_VEC  = num_ops'(1 << 1);
  parameter OP_LW_VEC   = num_ops'(1 << 2);
  parameter OP_SW_VEC   = num_ops'(1 << 3);
  parameter OP_JAL_VEC  = num_ops'(1 << 4);
  parameter OP_JALR_VEC = num_ops'(1 << 5);
  parameter OP_BEQ_VEC  = num_ops'(1 << 6);

  // verilator lint_off UNUSEDPARAM
  parameter p_tinyrv1 = OP_ADD_VEC
                      | OP_MUL_VEC
                      | OP_LW_VEC
                      | OP_SW_VEC
                      | OP_JAL_VEC
                      | OP_JALR_VEC
                      | OP_BEQ_VEC;
  // verilator lint_on UNUSEDPARAM

  function logic in_subset( 
    logic [num_ops-1:0] subset, 
    logic [num_ops-1:0] op_vec
  );
    return (subset & op_vec) > 0;
  endfunction

endpackage

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Instructions
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Definitions of the instructions that Blimp supports

`define RVI_INST_ADD   32'b0000000_?????_?????_000_?????_0110011
`define RVI_INST_MUL   32'b0000001_?????_?????_000_?????_0110011
`define RVI_INST_ADDI  32'b???????_?????_?????_000_?????_0010011
`define RVI_INST_LW    32'b???????_?????_?????_010_?????_0000011
`define RVI_INST_SW    32'b???????_?????_?????_010_?????_0100011
`define RVI_INST_JAL   32'b???????_?????_?????_???_?????_1101111
`define RVI_INST_JALR  32'b???????_?????_?????_000_?????_1100111
`define RVI_INST_BEQ   32'b???????_?????_?????_000_?????_1100011

`endif  // DEFS_ISA_V
