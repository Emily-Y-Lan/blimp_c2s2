//========================================================================
// SeqNumGen_test.v
//========================================================================
// A testbench for our sequence number generator

`include "hw/decode_issue/SeqNumGen.v"
`include "test/TestUtils.v"

import TestEnv::*;

//========================================================================
// SeqNumGenTestSuite
//========================================================================
// A test suite for the sequence number generator

module SeqNumGenTestSuite #(
  parameter p_suite_num  = 0,
  parameter p_inter_seq_bits = 2,
  parameter p_intra_seq_bits = 6
);
  string suite_name = $sformatf("%0d: SeqNumGenTestSuite_%0d_%0d", 
                                p_suite_num, p_inter_seq_bits,
                                p_intra_seq_bits);

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  // verilator lint_off UNUSED
  logic clk, rst;
  // verilator lint_on UNUSED

  TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  localparam p_seq_num_bits = p_inter_seq_bits + p_intra_seq_bits;

  logic                      dut_seq_num_alloc;
  logic [p_seq_num_bits-1:0] dut_next_seq_num;
  logic                      dut_next_seq_num_val;

  logic                      dut_commit;
  logic [p_seq_num_bits-1:0] dut_commit_seq_num;

  logic                      dut_squash;
  logic [p_seq_num_bits-1:0] dut_squash_seq_num;

  logic                      dut_inter_age_parity;
  logic                      dut_intra_age_parity;

  SeqNumGen #(
    .p_inter_seq_bits (p_inter_seq_bits),
    .p_intra_seq_bits (p_intra_seq_bits)
  ) DUT (
    .clk              (clk),
    .rst              (rst),

    .seq_num_alloc    (dut_seq_num_alloc),
    .next_seq_num     (dut_next_seq_num),
    .next_seq_num_val (dut_next_seq_num_val),

    .commit           (dut_commit),
    .commit_seq_num   (dut_commit_seq_num),

    .squash           (dut_squash),
    .squash_seq_num   (dut_squash_seq_num),

    .inter_age_parity (dut_inter_age_parity),
    .intra_age_parity (dut_intra_age_parity)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check (
    input logic                      seq_num_alloc,
    input logic                      commit,
    input logic [p_seq_num_bits-1:0] commit_seq_num,
    input logic                      squash,
    input logic [p_seq_num_bits-1:0] squash_seq_num,
    input logic                      inter_age_parity,
    input logic                      intra_age_parity,
    input logic [p_seq_num_bits-1:0] next_seq_num,
    input logic                      next_seq_num_val
  );
    if ( !t.failed ) begin
      dut_seq_num_alloc    = seq_num_alloc;
      dut_commit           = commit;
      dut_commit_seq_num   = commit_seq_num;
      dut_squash           = squash;
      dut_squash_seq_num   = squash_seq_num;
      dut_inter_age_parity = inter_age_parity;
      dut_intra_age_parity = intra_age_parity;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b %h (%b) %h (%b) %b %b > %h (%b)", t.cycles,
                  dut_seq_num_alloc,
                  dut_commit, dut_commit_seq_num,
                  dut_squash, dut_squash_seq_num,
                  dut_inter_age_parity, dut_intra_age_parity,
                  dut_next_seq_num, dut_next_seq_num_val );
      end

      `CHECK_EQ( dut_next_seq_num,     next_seq_num     );
      `CHECK_EQ( dut_next_seq_num_val, next_seq_num_val );
      `CHECK_EQ( dut_inter_age_parity, inter_age_parity );
      `CHECK_EQ( dut_intra_age_parity, intra_age_parity );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // seq_num
  //----------------------------------------------------------------------
  // A helper function to create sequence numbers from inter and intra
  // seq bits

  logic [31:0] unused_inter_bits;
  logic [31:0] unused_intra_bits;

  function logic [p_seq_num_bits-1:0] seq_num (
    input logic [31:0] inter_bits,
    input logic [31:0] intra_bits
  );
    unused_inter_bits = inter_bits;
    unused_intra_bits = intra_bits;

    return {p_inter_seq_bits'(inter_bits), 
            p_intra_seq_bits'(intra_bits)};
  endfunction

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //                                               inter intra next           next
    //     alloc commit            squash            par   par   num            val
    check( 1,    0, seq_num(0, 0), 0, seq_num(0, 0), 0,    0,    seq_num(0, 0), 1);
    check( 1,    0, seq_num(0, 0), 0, seq_num(0, 0), 0,    0,    seq_num(0, 1), 1);
  endtask

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  task run_test_suite();
    t.test_suite_begin( suite_name );

    if ( (t.n <= 0) || (t.n == 1)) test_case_1_basic();

  endtask

endmodule

//========================================================================
// SeqNumGen_test
//========================================================================

module SeqNumGen_test;
  SeqNumGenTestSuite #(1)       suite_1();
  SeqNumGenTestSuite #(2, 8, 3) suite_2();
  SeqNumGenTestSuite #(3, 4, 4) suite_3();

  int s;

  initial begin
    test_bench_begin( `__FILE__ );
    s = get_test_suite();

    if ((s <= 0) || (s == 1)) suite_1.run_test_suite();
    if ((s <= 0) || (s == 1)) suite_2.run_test_suite();
    if ((s <= 0) || (s == 1)) suite_3.run_test_suite();

    test_bench_end();
  end
endmodule
