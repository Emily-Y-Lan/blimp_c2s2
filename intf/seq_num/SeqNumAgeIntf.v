//========================================================================
// SeqNumAgeIntf.v
//========================================================================
// An interface for comparing the age of two sequence numbers

`ifndef INTF_SEQNUM_SEQNUMAGEINTF_V
`define INTF_SEQNUM_SEQNUMAGEINTF_V

//------------------------------------------------------------------------
// SeqNumAgeIntf
//------------------------------------------------------------------------

interface SeqNumAgeIntf
#(
  parameter p_seq_num_bits = 5,
  parameter p_epoch_bits   = 2
);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic [p_epoch_bits-1:0] curr_tail_epoch;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  modport server (
    output curr_tail_epoch
  );

  modport client (
    input  curr_tail_epoch // Not explicitly used
  );

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // is_older
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Returns whether seq_num_0 is older than seq_num_1
  //
  // Inspiration: SonicBoom
  // https://github.com/riscv-boom/riscv-boom/blob/7184be9db9d48bd01689cf9dd429a4ac32b21105/src/main/scala/v3/util/util.scala#L363

  function automatic logic is_older(
    input [p_seq_num_bits-1:0] seq_num_0,
    input [p_seq_num_bits-1:0] seq_num_1
  );
    logic [p_epoch_bits-1:0] seq_num_0_epoch = seq_num_0[p_seq_num_bits-1:p_seq_num_bits-p_epoch_bits];
    logic [p_epoch_bits-1:0] seq_num_1_epoch = seq_num_1[p_seq_num_bits-1:p_seq_num_bits-p_epoch_bits];

    if( seq_num_0_epoch == seq_num_1_epoch ) // Same epoch - can directly compare
      return seq_num_0[p_seq_num_bits-p_epoch_bits-1:0] < 
             seq_num_1[p_seq_num_bits-p_epoch_bits-1:0];

    // Otherwise, compare epochs
    return ( seq_num_0_epoch < seq_num_1_epoch ) ^ 
           ( seq_num_0_epoch < curr_tail_epoch ) ^
           ( seq_num_1_epoch < curr_tail_epoch );
  endfunction

endinterface

`endif // INTF_SEQNUM_SEQNUMAGEINTF_V
