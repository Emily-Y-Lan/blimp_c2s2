//========================================================================
// InstTraceNotif.v
//========================================================================
// The notification interface for checking instruction traces

`ifndef INTF_INST_TRACE_NOTIF_V
`define INTF_INST_TRACE_NOTIF_V

//------------------------------------------------------------------------
// InstTraceNotif
//------------------------------------------------------------------------

interface InstTraceNotif
#(
  parameter p_addr_bits    = 32,
  parameter p_data_bits    = 32
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic    [p_addr_bits-1:0] pc;
  logic                [4:0] waddr;
  logic    [p_data_bits-1:0] wdata;
  logic                      wen;
  logic                      val;

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
