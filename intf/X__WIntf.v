//========================================================================
// X__WIntf.v
//========================================================================
// The interface definition going between X and W

`ifndef INTF_X__W_INTF_V
`define INTF_X__W_INTF_V

`include "defs/ISA.v"

import ISA::*;

//------------------------------------------------------------------------
// X__WIntf
//------------------------------------------------------------------------

interface X__WIntf
#(
  parameter p_data_bits = 32
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic             [4:0] waddr;
  logic [p_data_bits-1:0] wdata;
  logic                   wen;
  logic                   val;
  logic                   rdy;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  modport X_intf (
    output waddr,
    output wdata,
    output wen,
    output val,
    input  rdy
  );

  modport W_intf (
    input  waddr,
    input  wdata,
    input  wen,
    input  val,
    output rdy
  );

endinterface

`endif // INTF_X__W_INTF_V
