//========================================================================
// SeqNumFreeIntf.v
//========================================================================
// An interface for freeing allocated sequence numbers

`ifndef INTF_SEQNUM_SEQNUMFREEINTF_V
`define INTF_SEQNUM_SEQNUMFREEINTF_V

//------------------------------------------------------------------------
// SeqNumFreeIntf
//------------------------------------------------------------------------

interface SeqNumFreeIntf
#(
  parameter p_seq_num_bits = 5
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic [p_seq_num_bits-1:0] seq_num;
  logic                      val

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  modport client (
    output seq_num,
    output val
  );

  modport server (
    input  seq_num,
    input  val
  );

endinterface

`endif // INTF_SEQNUM_SEQNUMFREEINTF_V
