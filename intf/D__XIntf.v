//========================================================================
// D__XIntf.v
//========================================================================
// The interface definition going between D and X

`ifndef INTF_D__X_INTF_V
`define INTF_D__X_INTF_V

//------------------------------------------------------------------------
// Type definitions
//------------------------------------------------------------------------

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Arith
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

typedef enum logic [3:0] {
  ARITH_ADD,
  ARITH_SUB,
  ARITH_AND,
  ARITH_OR,
  ARITH_XOR,
  ARITH_SLT,
  ARITH_SLTU,
  ARITH_SRA,
  ARITH_SRL,
  ARITH_SLL,
} arith_type;

typedef arith_type arith_metadata;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Memory
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

typedef enum logic {
  MEM_LOAD,
  MEM_STORE
} mem_type;

typedef mem_type mem_metadata;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Branch
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

typedef enum logic [2:0] {
  BR_BEQ,
  BR_BNE,
  BR_BLT,
  BR_BGE,
  BR_BLTU,
  BR_BGEU,
  BR_JAL,
  BR_JALR
} branch_type;

typedef branch_type branch_metadata;

typedef union packed {
  arith_metadata  arith;
  mem_metadata    mem;
  branch_metadata branch;
} metadata;

//------------------------------------------------------------------------
// D__XIntf
//------------------------------------------------------------------------

interface D__XIntf
#(
  parameter p_num_pipes = 1,
  parameter p_addr_bits = 32,
  parameter p_data_bits = 32
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic [p_addr_bits-1:0] pc            [p_num_pipes-1:0];
  logic [p_data_bits-1:0] op1           [p_num_pipes-1:0];
  logic [p_data_bits-1:0] op2           [p_num_pipes-1:0];
  metadata                metadata      [p_num_pipes-1:0];
  logic                   val           [p_num_pipes-1:0];
  logic                   rdy           [p_num_pipes-1:0];

  logic                   squash        [p_num_pipes-1:0];
  logic [p_addr_bits-1:0] branch_target [p_num_pipes-1:0];

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  modport D_intf (
    output pc,
    output op1,
    output op2,
    output metadata,
    output val,
    input  rdy,

    input  squash,
    input  branch_target
  );

  modport X_intf (
    input  pc,
    input  op1,
    input  op2,
    input  metadata,
    input  val,
    output rdy,

    input  squash,
    input  branch_target
  );

endinterface

`endif // INTF_F__D_INTF_V
