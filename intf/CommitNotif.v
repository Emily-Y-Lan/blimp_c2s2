//========================================================================
// CommitNotif.v
//========================================================================
// The notification interface for committing instructions

`ifndef INTF_COMMIT_NOTIF_V
`define INTF_COMMIT_NOTIF_V

//------------------------------------------------------------------------
// CommitNotif
//------------------------------------------------------------------------

interface CommitNotif
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
    output seq_num,
    output waddr,
    output wdata,
    output wen,
    output val
  );

  // Subscribe
  modport sub (
    input pc,
    input seq_num,
    input waddr,
    input wdata,
    input wen,
    input val
  );

endinterface

`endif // INTF_COMMIT_NOTIF_V
