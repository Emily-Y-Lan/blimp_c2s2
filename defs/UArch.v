//========================================================================
// UArch.v
//========================================================================
// Common definitions to use as part of the Blimp microarchitecture
// framework

`ifndef DEFS_UARCH_V
`define DEFS_UARCH_V

package UArch;

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
    OP_BNE
  } rv_uop;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Supported operations
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Definitions of the subsets of an ISA that can be supported. We use a
  // one-hot encoding to specify combinations of operands that are
  // supported

  typedef logic [num_ops-1:0] rv_op_vec;

  parameter OP_ADD_VEC  = num_ops'(1 << 0);
  parameter OP_MUL_VEC  = num_ops'(1 << 1);
  parameter OP_LW_VEC   = num_ops'(1 << 2);
  parameter OP_SW_VEC   = num_ops'(1 << 3);
  parameter OP_JAL_VEC  = num_ops'(1 << 4);
  parameter OP_JALR_VEC = num_ops'(1 << 5);
  parameter OP_BNE_VEC  = num_ops'(1 << 6);

  // verilator lint_off UNUSEDPARAM
  parameter p_tinyrv1 = OP_ADD_VEC
                      | OP_MUL_VEC
                      | OP_LW_VEC
                      | OP_SW_VEC
                      | OP_JAL_VEC
                      | OP_JALR_VEC
                      | OP_BNE_VEC;
  // verilator lint_on UNUSEDPARAM

  function logic in_subset( 
    logic [num_ops-1:0] subset, 
    logic [num_ops-1:0] op_vec
  );
    return (subset & op_vec) > 0;
  endfunction

endpackage

`endif  // DEFS_UARCH_V
