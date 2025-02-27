//========================================================================
// F__DIntf.v
//========================================================================
// The interface definition going between F and D

`ifndef INTF_F__D_INTF_V
`define INTF_F__D_INTF_V

interface F__DIntf;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic [31:0] inst;
  logic [31:0] pc;
  logic        val;
  logic        rdy;

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
