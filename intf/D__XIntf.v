//========================================================================
// D__XIntf.v
//========================================================================
// The interface definition going between D and X

`ifndef INTF_D__X_INTF_V
`define INTF_D__X_INTF_V

`include "defs/ISA.v"

import ISA::*;

//------------------------------------------------------------------------
// D__XIntf
//------------------------------------------------------------------------

interface D__XIntf
#(
  parameter p_isa_subset = RVS_ARITH,
  parameter p_addr_bits  = 32,
  parameter p_data_bits  = 32
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic [p_addr_bits-1:0] pc;
  logic [p_data_bits-1:0] op1;
  logic [p_data_bits-1:0] op2;
  rv_uop                  uop;
  logic                   val;
  logic                   rdy;

  logic                   squash;
  logic [p_addr_bits-1:0] branch_target;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  modport D_intf (
    output pc,
    output op1,
    output op2,
    output uop,
    output val,
    input  rdy,

    input  squash,
    input  branch_target
  );

  modport X_intf (
    input  pc,
    input  op1,
    input  op2,
    input  uop,
    input  val,
    output rdy,

    input  squash,
    input  branch_target
  );

endinterface

`endif // INTF_F__D_INTF_V
