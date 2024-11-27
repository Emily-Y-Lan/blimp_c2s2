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
  parameter p_inter_spec_bits = 2,
  parameter p_intra_spec_bits = 6,

  parameter p_seq_num_bits = p_inter_spec_bits + p_intra_spec_bits
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

  logic [p_inter_spec_bits-1:0] num1_inter_spec_bits;
  logic [p_inter_spec_bits-1:0] num2_inter_spec_bits;

  logic [p_intra_spec_bits-1:0] num1_intra_spec_bits;
  logic [p_intra_spec_bits-1:0] num2_intra_spec_bits;

  assign num1_inter_spec_bits = num1[p_seq_num_bits-1:p_intra_spec_bits];
  assign num2_inter_spec_bits = num2[p_seq_num_bits-1:p_intra_spec_bits];

  assign num1_intra_spec_bits = num1[p_intra_spec_bits-1:0];
  assign num2_intra_spec_bits = num2[p_intra_spec_bits-1:0];

  //----------------------------------------------------------------------
  // Compare numbers
  //----------------------------------------------------------------------

  logic num1_inter_spec_uless;
  logic num1_inter_spec_sless;
  logic num1_intra_spec_uless;
  logic num1_intra_spec_sless;

  assign num1_inter_spec_uless = 
    ( num1_inter_spec_bits < num2_inter_spec_bits );

  assign num1_inter_spec_sless = 
    ( $signed(num1_inter_spec_bits) < $signed(num2_inter_spec_bits) );

  assign num1_intra_spec_uless = 
    ( num1_intra_spec_bits < num2_intra_spec_bits );
  
  assign num1_intra_spec_sless = 
    ( $signed(num1_intra_spec_bits) < $signed(num2_intra_spec_bits) );

  logic inter_spec_unequal;
  logic intra_spec_unequal;

  assign inter_spec_unequal = 
    ( num1_inter_spec_bits != num2_inter_spec_bits );

  assign intra_spec_unequal = 
    ( num1_intra_spec_bits != num2_intra_spec_bits );

  always_comb begin
    num1_is_older = 0;

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Compare inter-spec first
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if( inter_spec_unequal ) begin
      if( inter_age_parity )
        num1_is_older = num1_inter_spec_sless;
      else
        num1_is_older = num1_inter_spec_uless;
    end

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Compare intra-spec first
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    else if( intra_spec_unequal ) begin
      if( intra_age_parity )
        num1_is_older = num1_intra_spec_sless;
      else
        num1_is_older = num1_intra_spec_uless;
    end
  end

endmodule

`endif // HW_DECODE_SEQNUMCOMPARE_V
