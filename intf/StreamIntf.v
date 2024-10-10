//========================================================================
// StreamIntf.v
//========================================================================
// A parametrized interface for latency-insensitive streaming

`ifndef INTF_STREAM_INTF_V
`define INTF_STREAM_INTF_V

//------------------------------------------------------------------------
// Stream Interface
//------------------------------------------------------------------------

interface StreamIntf
#(
  parameter type t_msg  = logic [31:0]
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic  val;
  logic  rdy;
  t_msg  msg;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Modports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  modport istream (
    output val,
    input  rdy,
    output msg
  );

  modport ostream (
    input  val,
    output rdy,
    input  msg
  );

endinterface

`endif // INTF_STREAM_INTF_V
