//========================================================================
// CompleteNotif.v
//========================================================================
// The notification interface for writing back values

`ifndef INTF_COMPLETE_NOTIF_V
`define INTF_COMPLETE_NOTIF_V

//------------------------------------------------------------------------
// CompleteNotif
//------------------------------------------------------------------------

interface CompleteNotif
#(
  parameter p_seq_num_bits = 5,
  parameter p_data_bits    = 32
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic [p_seq_num_bits-1:0] seq_num;
  logic                [4:0] waddr;
  logic    [p_data_bits-1:0] wdata;
  logic                      wen;
  logic                      val;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Publish
  modport pub (
    output seq_num,
    output waddr,
    output wdata,
    output wen,
    output val
  );

  // Subscribe
  modport sub (
    input seq_num,
    input waddr,
    input wdata,
    input wen,
    input val
  );

endinterface

`endif // INTF_COMPLETE_NOTIF_V
