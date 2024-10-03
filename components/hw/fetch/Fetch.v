//========================================================================
// Fetch.v
//========================================================================
// A modular fetch unit for fetching instructions

`ifndef HW_FETCH_FETCH_V
`define HW_FETCH_FETCH_V

`include "hw/common/Fifo.v"

`include "intf/F__D.v"
`include "intf/Mem.v"

module Fetch
#(
  parameter RST_ADDR = 32'b0,

  //----------------------------------------------------------------------
  // Interface Parameters
  //----------------------------------------------------------------------

  parameter ADDR_BITS = 32,
  parameter INST_BITS = 32,
  parameter OPAQ_BITS = 8
)
(
  input  logic    clk,
  input  logic    rst,

  //----------------------------------------------------------------------
  // Memory Interface
  //----------------------------------------------------------------------

  MemReq.cpu_intf memreq,

  //----------------------------------------------------------------------
  // F <-> D Interface
  //----------------------------------------------------------------------

  F__D.F_intf     D
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // FIFO keeps track of in-flight requests
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Fifo #()

endmodule

`endif // HW_FETCH_FETCH_V