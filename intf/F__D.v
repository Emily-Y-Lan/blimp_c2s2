//========================================================================
// F__D.v
//========================================================================
// The interface definition going between F and D

`ifndef INTF_F__D_INTF_V
`define INTF_F__D_INTF_V

interface F__D
#(
  parameter p_addr_bits = 32,
  parameter p_inst_bits = 32
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic [p_inst_bits-1:0] inst;
  logic [p_addr_bits-1:0] pc;
  logic                   val;
  logic                   rdy;

  // Control Flow Signals
  logic                   squash;

  // Redirection Signals
  logic [p_addr_bits-1:0] branch_target;
  logic                   branch_val;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  modport F_intf (
    output inst,
    output pc,
    output val,
    input  rdy,

    input  squash,

    input  branch_target,
    input  branch_val
  );

  modport D_intf (
    input  inst,
    input  pc,
    input  val,
    output rdy,

    output squash,

    output branch_target,
    output branch_val
  );

endinterface

`endif // INTF_F__D_INTF_V
