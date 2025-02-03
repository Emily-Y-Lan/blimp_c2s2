//========================================================================
// WritebackNotif.v
//========================================================================
// The notification interface for writing back values

`ifndef INTF_WRITEBACK_NOTIF_V
`define INTF_WRITEBACK_NOTIF_V

//------------------------------------------------------------------------
// WritebackNotif
//------------------------------------------------------------------------

interface WritebackNotif
#(
  parameter p_data_bits = 32
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic             [4:0] waddr;
  logic [p_data_bits-1:0] wdata;
  logic                   wen;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Publish
  modport pub (
    output waddr,
    output wdata,
    output wen
  );

  // Subscribe
  modport sub (
    input  waddr,
    input  wdata,
    input  wen
  );

endinterface

`endif // INTF_WRITEBACK_Notif_V
