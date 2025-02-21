//========================================================================
// SeqNumAllocIntf.v
//========================================================================
// An interface for allocating sequence numbers

`ifndef INTF_SEQNUM_SEQNUMALLOCINTF_V
`define INTF_SEQNUM_SEQNUMALLOCINTF_V

//------------------------------------------------------------------------
// SeqNumAllocIntf
//------------------------------------------------------------------------

interface SeqNumAllocIntf
#(
  parameter p_seq_num_bits = 5
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic [p_seq_num_bits-1:0] seq_num;
  logic                      val;
  logic                      rdy;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  modport client (
    input  seq_num,
    input  val,
    output rdy
  );

  modport server (
    output seq_num,
    output val,
    input  rdy
  );

endinterface

`endif // INTF_SEQNUM_SEQNUMALLOCINTF_V
