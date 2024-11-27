//========================================================================
// SeqNumCompare.v
//========================================================================
// A module to compare sequence numbers, using their parity. If the
// numbers are equal, output a zero

`ifndef HW_DECODE_SEQNUMCOMPARE_V
`define HW_DECODE_SEQNUMCOMPARE_V

module SeqNumCompare #(
  // Both of these must be >1, as we only ever use half of the available
  // values in order to compare age
  parameter p_inter_seq_bits = 2,
  parameter p_intra_seq_bits = 6,

  parameter p_seq_num_bits = p_inter_seq_bits + p_intra_seq_bits
) (
  input  logic [p_seq_num_bits-1:0] num1,
  input  logic [p_seq_num_bits-1:0] num2,
  input  logic                      inter_age_parity,
  input  logic                      intra_age_parity,

  output logic                      num1_is_older
);

  //----------------------------------------------------------------------
  // Break into components
  //----------------------------------------------------------------------

  logic [p_inter_seq_bits-1:0] num1_inter_seq_bits;
  logic [p_inter_seq_bits-1:0] num2_inter_seq_bits;

  logic [p_intra_seq_bits-1:0] num1_intra_seq_bits;
  logic [p_intra_seq_bits-1:0] num2_intra_seq_bits;

  assign num1_inter_seq_bits = num1[p_seq_num_bits-1:p_intra_seq_bits];
  assign num2_inter_seq_bits = num2[p_seq_num_bits-1:p_intra_seq_bits];

  assign num1_intra_seq_bits = num1[p_intra_seq_bits-1:0];
  assign num2_intra_seq_bits = num2[p_intra_seq_bits-1:0];

  //----------------------------------------------------------------------
  // Compare numbers
  //----------------------------------------------------------------------

  logic num1_inter_seq_uless;
  logic num1_inter_seq_sless;
  logic num1_intra_seq_uless;
  logic num1_intra_seq_sless;

  assign num1_inter_seq_uless = 
    ( num1_inter_seq_bits < num2_inter_seq_bits );

  assign num1_inter_seq_sless = 
    ( $signed(num1_inter_seq_bits) < $signed(num2_inter_seq_bits) );

  assign num1_intra_seq_uless = 
    ( num1_intra_seq_bits < num2_intra_seq_bits );
  
  assign num1_intra_seq_sless = 
    ( $signed(num1_intra_seq_bits) < $signed(num2_intra_seq_bits) );

  logic inter_seq_unequal;
  logic intra_seq_unequal;

  assign inter_seq_unequal = 
    ( num1_inter_seq_bits != num2_inter_seq_bits );

  assign intra_seq_unequal = 
    ( num1_intra_seq_bits != num2_intra_seq_bits );

  always_comb begin
    num1_is_older = 0;

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Compare inter-seq first
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if( inter_seq_unequal ) begin
      if( inter_age_parity )
        num1_is_older = num1_inter_seq_sless;
      else
        num1_is_older = num1_inter_seq_uless;
    end

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Compare intra-seq first
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    else if( intra_seq_unequal ) begin
      if( intra_age_parity )
        num1_is_older = num1_intra_seq_sless;
      else
        num1_is_older = num1_intra_seq_uless;
    end
  end

endmodule

`endif // HW_DECODE_SEQNUMCOMPARE_V
