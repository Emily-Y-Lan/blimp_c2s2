//========================================================================
// SeqNumGen.v
//========================================================================
// A module to generate and manage sequence numbers

`ifndef HW_DECODE_SEQNUMGEN_V
`define HW_DECODE_SEQNUMGEN_V

module SeqNumGen #(
  // Both of these must be >1, as we only ever use half of the available
  // values in order to compare age
  parameter p_inter_seq_bits = 2,
  parameter p_intra_seq_bits = 6,

  parameter p_seq_num_bits = p_inter_seq_bits + p_intra_seq_bits
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
  input  logic [p_seq_num_bits-1:0] commit_seq_num,

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
  output logic                      intra_age_parity
);

  //----------------------------------------------------------------------
  // Break apart input sequence numbers
  //----------------------------------------------------------------------

  logic [p_inter_seq_bits-1:0] commit_inter_seq_num;
  logic [p_intra_seq_bits-1:0] commit_intra_seq_num;

  assign commit_inter_seq_num = commit_seq_num[p_seq_num_bits-1:p_intra_seq_bits];
  assign commit_intra_seq_num = commit_seq_num[p_intra_seq_bits-1:0];

  logic [p_inter_seq_bits-1:0] squash_inter_seq_num;
  logic [p_intra_seq_bits-1:0] unused_squash_intra_seq_num;

  assign squash_inter_seq_num = squash_seq_num[p_seq_num_bits-1:p_intra_seq_bits];
  assign unused_squash_intra_seq_num = squash_seq_num[p_intra_seq_bits-1:0];
  
  //----------------------------------------------------------------------
  // Intra-sequence numbers
  //----------------------------------------------------------------------
  // Keep track of the current one to allocate, as well as the last one
  // committed

  // TODO: Only update commit intra sequence number if in same inter spec regime
  // TODO: Fix inter update logic based on branches

  logic [p_intra_seq_bits-1:0] curr_intra_seq_num;
  logic [p_intra_seq_bits-1:0] curr_commit_intra_seq_num;
  logic [p_intra_seq_bits-1:0] next_intra_seq_num;
  logic [p_intra_seq_bits-1:0] next_commit_intra_seq_num;
  logic                        next_intra_overlap;
  logic                        next_intra_no_overlap;
  logic                        is_intra_overlap;
  logic                        can_issue_intra_seq;
  logic                        can_issue_inter_seq;

  always_ff @( posedge clk ) begin
    if( rst )
      curr_intra_seq_num <= '0;
    else if( squash )
      curr_intra_seq_num <= '0;
    else if( seq_num_alloc & can_issue_intra_seq )
      curr_intra_seq_num <= next_intra_seq_num;
  end

  always_ff @( posedge clk ) begin
    if( rst )
      curr_commit_intra_seq_num <= '0;
    else if( squash )
      curr_commit_intra_seq_num <= '0;
    else if( commit )
      curr_commit_intra_seq_num <= next_commit_intra_seq_num;
  end

  assign next_intra_overlap = ( 
    ( curr_intra_seq_num       [p_intra_seq_bits-1] != 
      curr_commit_intra_seq_num[p_intra_seq_bits-1]) &
    ( curr_intra_seq_num       [p_intra_seq_bits-1] != 
      next_intra_seq_num       [p_intra_seq_bits-1]));

  assign next_intra_no_overlap = (
    next_commit_inter_seq_num[p_intra_seq_bits-1] !=
    curr_intra_seq_num       [p_intra_seq_bits-1]);

  always_ff @( posedge clk ) begin
    if( rst )
      is_intra_overlap <= 1'b0;
    else if( squash )
      is_intra_overlap <= 1'b0;
    else if( seq_num_alloc & can_issue_intra_seq )
      is_intra_overlap <= next_intra_overlap;
    else if( is_intra_overlap & commit )
      is_intra_overlap <= next_intra_no_overlap;
  end

  always_comb begin
    can_issue_intra_seq = 1'b1;

    // Can't issue if the MSB would overlap with instructions yet to commit
    if( is_intra_overlap )
      can_issue_intra_seq = 1'b0;

    // Don't advance if we can't issue based on inter bits
    if( !can_issue_inter_seq )
      can_issue_intra_seq = 1'b0;
  end

  assign next_intra_seq_num        = curr_intra_seq_num + 1;
  assign next_commit_intra_seq_num = commit_intra_seq_num + 1;
  assign intra_age_parity          = curr_commit_intra_seq_num[p_intra_seq_bits-1];

  //----------------------------------------------------------------------
  // Inter-sequence numbers
  //----------------------------------------------------------------------

  logic [p_inter_seq_bits-1:0] curr_inter_seq_num;
  logic [p_inter_seq_bits-1:0] curr_commit_inter_seq_num;
  logic [p_inter_seq_bits-1:0] next_inter_seq_num;
  logic [p_inter_seq_bits-1:0] next_commit_inter_seq_num;
  logic                        older_eq_inter_squash;
  logic                        older_inter_commit;

  always_ff @( posedge clk ) begin
    if( rst )
      curr_inter_seq_num <= '0;
    else if( squash & older_eq_inter_squash )
      curr_inter_seq_num <= next_inter_seq_num;
  end

  always_ff @( posedge clk ) begin
    if( rst )
      curr_commit_inter_seq_num <= '0;
    else if( commit & older_inter_commit )
      curr_commit_inter_seq_num <= next_commit_inter_seq_num;
  end

  logic inter_squash_uless_eq;
  logic inter_squash_sless_eq;

  assign inter_squash_uless_eq = ( curr_inter_seq_num <= squash_inter_seq_num );
  assign inter_squash_sless_eq = ( $signed( curr_inter_seq_num ) <= 
                                   $signed( squash_inter_seq_num ) );

  logic inter_commit_uless;
  logic inter_commit_sless;

  assign inter_commit_uless = ( curr_commit_inter_seq_num < commit_inter_seq_num );
  assign inter_commit_sless = ( $signed( curr_commit_inter_seq_num ) < 
                                $signed( commit_inter_seq_num ) );

  always_comb begin
    if( inter_age_parity ) begin
      older_eq_inter_squash = inter_squash_sless_eq;
      older_inter_commit    = inter_commit_sless;
    end else begin
      older_eq_inter_squash = inter_squash_uless_eq;
      older_inter_commit    = inter_commit_uless;
    end
  end

  always_comb begin
    can_issue_inter_seq = 1'b1;

    // Can't issue if the inter-speculation bits would overlap
    if( !(|curr_inter_seq_num[p_inter_seq_bits-2:0]) & 
        (curr_inter_seq_num[p_inter_seq_bits-1] != 
         curr_commit_inter_seq_num[p_inter_seq_bits-1]))
      can_issue_inter_seq = 1'b0;
  end

  assign next_inter_seq_num        = squash_inter_seq_num + 1;
  assign next_commit_inter_seq_num = commit_inter_seq_num + 1;
  assign inter_age_parity          = curr_commit_inter_seq_num[p_inter_seq_bits-1];

  //----------------------------------------------------------------------
  // Assign outputs
  //----------------------------------------------------------------------

  assign next_seq_num = { curr_inter_seq_num, curr_intra_seq_num };
  assign next_seq_num_val = can_issue_intra_seq;

endmodule

`endif // HW_DECODE_SEQNUMGEN_V
