//========================================================================
// F__DIntf.v
//========================================================================
// The interface definition going between F and D

`ifndef INTF_F__D_INTF_V
`define INTF_F__D_INTF_V

interface F__DIntf
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

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  modport F_intf (
    output inst,
    output pc,
    output val,
    input  rdy
  );

  modport D_intf (
    input  inst,
    input  pc,
    input  val,
    output rdy
  );

endinterface

`endif // INTF_F__D_INTF_V
