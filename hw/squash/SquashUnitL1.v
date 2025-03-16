//========================================================================
// SquashUnitL1.v
//========================================================================
// A unit for arbitrating between different squash notifications basec
// on age

`ifndef HW_SQUASH_SQUASHUNITL1_V
`define HW_SQUASH_SQUASHUNITL1_V

`include "hw/util/SeqAge.v"
`include "intf/CommitNotif.v"
`include "intf/SquashNotif.v"

module SquashUnitL1 #(
  parameter p_num_arb = 2
) (
  input  logic clk,
  input  logic rst,

  //----------------------------------------------------------------------
  // Notifications to arbitrate between
  //----------------------------------------------------------------------

  SquashNotif.sub arb [p_num_arb],

  //----------------------------------------------------------------------
  // Arbitrated notification
  //----------------------------------------------------------------------

  SquashNotif.pub gnt,

  //----------------------------------------------------------------------
  // Commit to track age comparison
  //----------------------------------------------------------------------

  CommitNotif.sub commit
);

  localparam p_seq_num_bits = gnt.p_seq_num_bits;

  generate
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Base case
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if( p_num_arb == 1 ) begin: base_case
      assign gnt.seq_num = arb[0].seq_num;
      assign gnt.target  = arb[0].target;
      assign gnt.val     = arb[0].val;
    end

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Recursive case
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    else begin: recur_case
      localparam p_num_arb_split = p_num_arb / 2;

      // Temporary interfaces to arbitrate
      SquashNotif #(
        .p_seq_num_bits (p_seq_num_bits)
      ) gnt_intermediate [2]();

      // Form binary decision tree
      localparam p_left_num_arb  = p_num_arb_split;
      localparam p_right_num_arb = p_num_arb - p_num_arb_split;

      SquashUnitL1 #(
        .p_num_arb (p_left_num_arb)
      ) left (
        .arb (arb[0:p_num_arb_split-1]),
        .gnt (gnt_intermediate[0]),
        .*
      );

      SquashUnitL1 #(
        .p_num_arb (p_right_num_arb)
      ) right (
        .arb (arb[p_num_arb_split:p_num_arb-1]),
        .gnt (gnt_intermediate[1]),
        .*
      );

      // Arbitrate between the remaining two notifications
      SeqAge seq_age (
        .*
      );

      logic gnt0_is_older;
      assign gnt0_is_older = recur_case.seq_age.is_older(
        gnt_intermediate[0].seq_num,
        gnt_intermediate[1].seq_num
      );

      always_comb begin
        // Choose the valid notification, if only one
        if( !gnt_intermediate[0].val ) begin
          gnt.seq_num = gnt_intermediate[1].seq_num;
          gnt.target  = gnt_intermediate[1].target;
          gnt.val     = gnt_intermediate[1].val;
        end else if( !gnt_intermediate[1].val ) begin
          gnt.seq_num = gnt_intermediate[0].seq_num;
          gnt.target  = gnt_intermediate[0].target;
          gnt.val     = gnt_intermediate[0].val;
        end

        // Pass along the older squash
        else if( gnt0_is_older ) begin
          // 0 is older
          gnt.seq_num = gnt_intermediate[0].seq_num;
          gnt.target  = gnt_intermediate[0].target;
          gnt.val     = gnt_intermediate[0].val;
        end else begin
          // 1 is older
          gnt.seq_num = gnt_intermediate[1].seq_num;
          gnt.target  = gnt_intermediate[1].target;
          gnt.val     = gnt_intermediate[1].val;
        end
      end
    end
  endgenerate

  //----------------------------------------------------------------------
  // Unused signals
  //----------------------------------------------------------------------
  // Include those that are used by SeqAge, as they're not used in all
  // cases

  logic        unused_clk;
  logic        unused_rst;
  logic [31:0] unused_commit_pc;
  logic  [4:0] unused_commit_waddr;
  logic [31:0] unused_commit_wdata;
  logic        unused_commit_wen;
  logic        unused_commit_val;

  assign unused_clk          = clk;
  assign unused_rst          = rst;
  assign unused_commit_pc    = commit.pc;
  assign unused_commit_waddr = commit.waddr;
  assign unused_commit_wdata = commit.wdata;
  assign unused_commit_wen   = commit.wen;
  assign unused_commit_val   = commit.val;

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

`ifndef SYNTHESIS
  function int ceil_div_4( int val );
    return (val / 4) + ((val % 4) > 0 ? 1 : 0);
  endfunction

  int str_len;
  assign str_len = ceil_div_4(p_seq_num_bits) + 1 + // seq_num
                   ceil_div_4(32);                  // waddr

  function string trace();
    if( gnt.val )
      trace = $sformatf("%h:%h", gnt.seq_num, gnt.target);
    else
      trace = {str_len{" "}};
  endfunction
`endif

endmodule

`endif // HW_SQUASH_SQUASHUNITL1_V
