//========================================================================
// SquashNotif.v
//========================================================================
// The notification interface for squashing instructions

`ifndef INTF_SQUASH_NOTIF_V
`define INTF_SQUASH_NOTIF_V

//------------------------------------------------------------------------
// SquashNotif
//------------------------------------------------------------------------

interface SquashNotif
#(
  parameter p_seq_num_bits  = 5
);
  
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic [p_seq_num_bits-1:0] seq_num;
  logic                      val;


  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Publish
  modport pub (
    output seq_num,
    output val
  );

  // Subscribe
  modport sub (
    input seq_num,
    input val
  );

endinterface

`endif // INTF_SQUASH_NOTIF_V
