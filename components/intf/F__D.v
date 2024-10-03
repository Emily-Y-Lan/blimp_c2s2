//========================================================================
// F__D.v
//========================================================================
// The interface definition going between F and D

interface F__D
#(
  parameter ADDR_BITS = 32,
  parameter INST_BITS = 32
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic [INST_BITS-1:0] inst;
  logic                 val;
  logic                 rdy;

  // Control Flow Signals
  logic                 squash;
  logic                 stall;

  // Redirection Signals
  logic [ADDR_BITS-1:0] branch_target;
  logic                 branch_val;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  modport F_intf (
    output inst,
    output val,
    input  rdy,

    input  squash,
    input  stall,

    input  branch_target,
    input  branch_val
  );

  modport D_intf (
    input  inst,
    input  val,
    output rdy,

    output squash,
    output stall,

    output branch_target,
    output branch_val
  );

endinterface
