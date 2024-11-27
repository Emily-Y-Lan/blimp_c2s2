//========================================================================
// SeqNumGen.v
//========================================================================
// A module to generate and manage sequence numbers

`ifndef HW_DECODE_SEQNUMGEN_V
`define HW_DECODE_SEQNUMGEN_V

module SeqNumGen #(
  // Both of these must be >1, as we only ever use half of the available
  // values in order to compare age
  parameter p_inter_spec_bits = 2,
  parameter p_intra_spec_bits = 6,

  parameter p_seq_num_bits = p_inter_spec_bits + p_intra_spec_bits
) (
  input  logic clk,
  input  logic rst,
  
  //----------------------------------------------------------------------
  // Allocation Signals
  //----------------------------------------------------------------------

  input  logic                      seq_num_alloc,
  output logic [p_seq_num_bits-1:0] next_seq_num,
  output logic                      next_seq_num_val,

  //----------------------------------------------------------------------
  // Commit Signals
  //----------------------------------------------------------------------

  input  logic                      commit,
  input  logic [p_seq_num_bits-1:0] commit_seq_num

  //----------------------------------------------------------------------
  // Squash Signals
  //----------------------------------------------------------------------

  input  logic                      squash,
  input  logic [p_seq_num_bits-1:0] squash_seq_num,

  //----------------------------------------------------------------------
  // Age Parity
  //----------------------------------------------------------------------
  // Used to compare sequence numbers to determine which is older. A `1`
  // indicates that sequence numbers with a `1` MSB are older than those
  // with a `0` MSB

  output logic                      inter_age_parity,
  output logic                      intra_age_parity,
);

endmodule

`endif // HW_DECODE_SEQNUMGEN_V
