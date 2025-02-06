//========================================================================
// D__XIntf.v
//========================================================================
// The interface definition going between D and X

`ifndef INTF_D__X_INTF_V
`define INTF_D__X_INTF_V

`include "defs/UArch.v"

import UArch::*;

//------------------------------------------------------------------------
// D__XIntf
//------------------------------------------------------------------------

interface D__XIntf
#(
  parameter p_addr_bits    = 32,
  parameter p_data_bits    = 32,
  parameter p_seq_num_bits = 5
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic    [p_addr_bits-1:0] pc;
  logic [p_seq_num_bits-1:0] seq_num;
  logic    [p_data_bits-1:0] op1;
  logic    [p_data_bits-1:0] op2;
  logic                [4:0] waddr;
  rv_uop                     uop;
  logic                      val;
  logic                      rdy;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  modport D_intf (
    output pc,
    output seq_num,
    output op1,
    output op2,
    output uop,
    output waddr,
    output val,
    input  rdy
  );

  modport X_intf (
    input  pc,
    input  seq_num,
    input  op1,
    input  op2,
    input  uop,
    input  waddr,
    input  val,
    output rdy
  );

endinterface

`endif // INTF_D__X_INTF_V
