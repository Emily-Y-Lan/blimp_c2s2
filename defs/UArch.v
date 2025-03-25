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

  parameter num_ops = 23;

  typedef enum logic [$clog2(num_ops)-1:0] {
    OP_ADD,
    OP_SUB,
    OP_AND,
    OP_OR,
    OP_XOR,
    OP_SLT,
    OP_SLTU,
    OP_SRA,
    OP_SRL,
    OP_SLL,
    OP_MUL,
    OP_LUI,
    OP_AUIPC,
    OP_LW,
    OP_SW,
    OP_JAL,
    OP_JALR,
    OP_BEQ,
    OP_BNE,
    OP_BLT,
    OP_BGE,
    OP_BLTU,
    OP_BGEU
  } rv_uop;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Supported operations
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Definitions of the subsets of an ISA that can be supported. We use a
  // one-hot encoding to specify combinations of operands that are
  // supported

  typedef logic [num_ops-1:0] rv_op_vec;

  // verilator lint_off UNUSEDPARAM
  parameter OP_ADD_VEC   = num_ops'(1 << OP_ADD  );
  parameter OP_SUB_VEC   = num_ops'(1 << OP_SUB  );
  parameter OP_AND_VEC   = num_ops'(1 << OP_AND  );
  parameter OP_OR_VEC    = num_ops'(1 << OP_OR   );
  parameter OP_XOR_VEC   = num_ops'(1 << OP_XOR  );
  parameter OP_SLT_VEC   = num_ops'(1 << OP_SLT  );
  parameter OP_SLTU_VEC  = num_ops'(1 << OP_SLTU );
  parameter OP_SRA_VEC   = num_ops'(1 << OP_SRA  );
  parameter OP_SRL_VEC   = num_ops'(1 << OP_SRL  );
  parameter OP_SLL_VEC   = num_ops'(1 << OP_SLL  );
  parameter OP_MUL_VEC   = num_ops'(1 << OP_MUL  );
  parameter OP_LUI_VEC   = num_ops'(1 << OP_LUI  );
  parameter OP_AUIPC_VEC = num_ops'(1 << OP_AUIPC);
  parameter OP_LW_VEC    = num_ops'(1 << OP_LW   );
  parameter OP_SW_VEC    = num_ops'(1 << OP_SW   );
  parameter OP_JAL_VEC   = num_ops'(1 << OP_JAL  );
  parameter OP_JALR_VEC  = num_ops'(1 << OP_JALR );
  parameter OP_BEQ_VEC   = num_ops'(1 << OP_BEQ  );
  parameter OP_BNE_VEC   = num_ops'(1 << OP_BNE  );
  parameter OP_BLT_VEC   = num_ops'(1 << OP_BLT  );
  parameter OP_BGE_VEC   = num_ops'(1 << OP_BGE  );
  parameter OP_BLTU_VEC  = num_ops'(1 << OP_BLTU );
  parameter OP_BGEU_VEC  = num_ops'(1 << OP_BGEU );

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
