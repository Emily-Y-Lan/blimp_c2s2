//========================================================================
// InstTraceNotif.v
//========================================================================
// The notification interface for checking instruction traces

`ifndef INTF_INST_TRACE_NOTIF_V
`define INTF_INST_TRACE_NOTIF_V

//------------------------------------------------------------------------
// InstTraceNotif
//------------------------------------------------------------------------

interface InstTraceNotif;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic [31:0] pc;
  logic  [4:0] waddr;
  logic [31:0] wdata;
  logic        wen;
  logic        val;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Publish
  modport pub (
    output pc,
    output waddr,
    output wdata,
    output wen,
    output val
  );

endinterface

`endif // INTF_INST_TRACE_NOTIF_V
