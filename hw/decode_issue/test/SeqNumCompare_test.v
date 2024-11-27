//========================================================================
// SeqNumCompare_test.v
//========================================================================
// A testbench for our sequence number comparator

`include "hw/decode_issue/SeqNumCompare.v"
`include "test/TestUtils.v"

import TestEnv::*;

//========================================================================
// SeqNumCompareTestSuite
//========================================================================
// A test suite for the sequence number comparator

module SeqNumCompareTestSuite #(
  parameter p_suite_num  = 0,
  parameter p_inter_seq_bits = 2,
  parameter p_intra_seq_bits = 6
);
  string suite_name = $sformatf("%0d: SeqNumCompareTestSuite_%0d_%0d", 
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

  logic [p_seq_num_bits-1:0] dut_num1;
  logic [p_seq_num_bits-1:0] dut_num2;
  logic                      dut_inter_age_parity;
  logic                      dut_intra_age_parity;
  logic                      dut_num1_is_older;

  SeqNumCompare #(
    .p_inter_seq_bits (p_inter_seq_bits),
    .p_intra_seq_bits (p_intra_seq_bits)
  ) DUT (
    .num1             (dut_num1),
    .num2             (dut_num2),
    .inter_age_parity (dut_inter_age_parity),
    .intra_age_parity (dut_intra_age_parity),
    .num1_is_older    (dut_num1_is_older)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check (
    input logic [p_seq_num_bits-1:0] num1,
    input logic [p_seq_num_bits-1:0] num2,
    input logic                      inter_age_parity,
    input logic                      intra_age_parity,
    input logic                      num1_is_older
  );
    if ( !t.failed ) begin
      dut_num1             = num1;
      dut_num2             = num2;
      dut_inter_age_parity = inter_age_parity;
      dut_intra_age_parity = intra_age_parity;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %h %h (%b %b) > %b", t.cycles,
                  dut_num1, dut_num2,
                  dut_inter_age_parity, dut_intra_age_parity,
                  dut_num1_is_older );
      end

      `CHECK_EQ( dut_num1_is_older, num1_is_older );

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

    //                                   inter intra num1
    //     num1           num2           par   par   older
    check( seq_num(0, 1), seq_num(0, 0), 0,    0,    0);
    check( seq_num(0, 0), seq_num(0, 1), 0,    0,    1);
  endtask

  //----------------------------------------------------------------------
  // test_case_2_same_inter
  //----------------------------------------------------------------------

  task test_case_2_same_inter();
    t.test_case_begin( "test_case_2_same_inter" );

    //                                     inter intra num1
    //     num1            num2            par   par   older
    check( seq_num(0,  4), seq_num(0,  2), 0,    0,    0);
    check( seq_num(0,  3), seq_num(0,  5), 0,    0,    1);
    check( seq_num(0,  1), seq_num(0,  1), 0,    0,    0);
    check( seq_num(0, -1), seq_num(0,  1), 0,    0,    0);
    check( seq_num(0,  1), seq_num(0, -1), 0,    0,    1);
    check( seq_num(2,  7), seq_num(2,  6), 0,    0,    0);
    check( seq_num(7,  1), seq_num(7,  6), 0,    0,    1);
    check( seq_num(1,  3), seq_num(1,  3), 0,    0,    0);
    check( seq_num(4, -1), seq_num(4,  0), 0,    0,    0);
    check( seq_num(6,  0), seq_num(6, -1), 0,    0,    1);
  endtask

  //----------------------------------------------------------------------
  // test_case_3_later_branch
  //----------------------------------------------------------------------

  task test_case_3_later_branch();
    t.test_case_begin( "test_case_3_later_branch" );

    //                                     inter intra num1
    //     num1            num2            par   par   older
    check( seq_num(1,  4), seq_num(0,  2), 0,    0,    0);
    check( seq_num(3,  3), seq_num(2,  5), 0,    0,    0);
    check( seq_num(3,  1), seq_num(1,  1), 0,    0,    0);
    check( seq_num(2, -1), seq_num(0,  1), 0,    0,    0);
    check( seq_num(1,  0), seq_num(0, -1), 0,    0,    0);
  endtask

  //----------------------------------------------------------------------
  // test_case_4_earlier_branch
  //----------------------------------------------------------------------

  task test_case_4_earlier_branch();
    t.test_case_begin( "test_case_4_earlier_branch" );

    //                                     inter intra num1
    //     num1            num2            par   par   older
    check( seq_num(0,  4), seq_num(1,  2), 0,    0,    1);
    check( seq_num(2,  3), seq_num(3,  5), 0,    0,    1);
    check( seq_num(1,  1), seq_num(3,  1), 0,    0,    1);
    check( seq_num(0, -1), seq_num(2,  1), 0,    0,    1);
    check( seq_num(0,  0), seq_num(1, -1), 0,    0,    1);
  endtask

  //----------------------------------------------------------------------
  // test_case_5_intra_parity
  //----------------------------------------------------------------------

  task test_case_5_intra_parity();
    t.test_case_begin( "test_case_5_intra_parity" );

    //                                     inter intra num1
    //     num1            num2            par   par   older
    check( seq_num(0,  3), seq_num(0, -2), 0,    1,    0);
    check( seq_num(3, -1), seq_num(3,  2), 0,    1,    1);
    check( seq_num(1,  1), seq_num(1,  1), 0,    1,    0);
  endtask

  //----------------------------------------------------------------------
  // test_case_6_inter_parity
  //----------------------------------------------------------------------

  task test_case_6_inter_parity();
    t.test_case_begin( "test_case_6_inter_parity" );

    //                                       inter intra num1
    //     num1             num2             par   par   older
    check( seq_num( 1,  2), seq_num(-1,  4), 1,    0,    0);
    check( seq_num(-1,  3), seq_num( 1,  6), 1,    0,    1);
    check( seq_num( 1,  1), seq_num( 1,  1), 1,    0,    0);
  endtask

  //----------------------------------------------------------------------
  // test_case_7_inter_intra_parity
  //----------------------------------------------------------------------

  task test_case_7_inter_intra_parity();
    t.test_case_begin( "test_case_7_inter_intra_parity" );

    //                                       inter intra num1
    //     num1             num2             par   par   older
    check( seq_num( 0, -1), seq_num( 0,  1), 1,    1,    1);
    check( seq_num( 3,  1), seq_num( 3, -1), 1,    1,    0);
    check( seq_num( 1,  2), seq_num(-1,  4), 1,    1,    0);
    check( seq_num(-1,  3), seq_num( 1,  6), 1,    1,    1);
    check( seq_num( 2,  2), seq_num( 2,  2), 1,    1,    0);
  endtask

  //----------------------------------------------------------------------
  // test_case_8_random
  //----------------------------------------------------------------------

  logic [p_inter_seq_bits-1:0] rand_num1_inter_bits;
  logic [p_intra_seq_bits-1:0] rand_num1_intra_bits;
  logic [p_inter_seq_bits-1:0] rand_num2_inter_bits;
  logic [p_intra_seq_bits-1:0] rand_num2_intra_bits;
  logic                         rand_inter_par;
  logic                         rand_intra_par;
  logic                         exp_num1_older;

  task test_case_8_random();
    t.test_case_begin( "test_case_8_random" );

    for( int i = 0; i < 20; i = i + 1 ) begin
      rand_num1_inter_bits = p_inter_seq_bits'($urandom());
      rand_num2_inter_bits = p_inter_seq_bits'($urandom());
      rand_num1_intra_bits = p_intra_seq_bits'($urandom());
      rand_num2_intra_bits = p_intra_seq_bits'($urandom());
      rand_inter_par       =                 1'($urandom());
      rand_intra_par       =                 1'($urandom());

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // Check upper inter bits
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      if( rand_num1_inter_bits[p_inter_seq_bits-1] > 
          rand_num2_inter_bits[p_inter_seq_bits-1])
        exp_num1_older = rand_inter_par;
      else if( rand_num1_inter_bits[p_inter_seq_bits-1] < 
               rand_num2_inter_bits[p_inter_seq_bits-1])
        exp_num1_older = !rand_inter_par;

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // Check lower inter bits
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      else if( rand_num1_inter_bits[p_inter_seq_bits-2:0] > 
               rand_num2_inter_bits[p_inter_seq_bits-2:0])
        exp_num1_older = 0;
      else if( rand_num1_inter_bits[p_inter_seq_bits-2:0] < 
               rand_num2_inter_bits[p_inter_seq_bits-2:0])
        exp_num1_older = 1;

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // Check upper intra bits
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      else if( rand_num1_intra_bits[p_intra_seq_bits-1] > 
          rand_num2_intra_bits[p_intra_seq_bits-1])
        exp_num1_older = rand_intra_par;
      else if( rand_num1_intra_bits[p_intra_seq_bits-1] < 
               rand_num2_intra_bits[p_intra_seq_bits-1])
        exp_num1_older = !rand_intra_par;

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // Check lower intra bits
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      else if( rand_num1_intra_bits[p_intra_seq_bits-2:0] > 
               rand_num2_intra_bits[p_intra_seq_bits-2:0])
        exp_num1_older = 0;
      else if( rand_num1_intra_bits[p_intra_seq_bits-2:0] < 
               rand_num2_intra_bits[p_intra_seq_bits-2:0])
        exp_num1_older = 1;

      else
        exp_num1_older = 0;

      check( {rand_num1_inter_bits, rand_num1_intra_bits},
             {rand_num2_inter_bits, rand_num2_intra_bits},
             rand_inter_par, rand_intra_par, exp_num1_older );
    end
  endtask

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  task run_test_suite();
    t.test_suite_begin( suite_name );

    if ( (t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ( (t.n <= 0) || (t.n == 2)) test_case_2_same_inter();
    if ( (t.n <= 0) || (t.n == 3)) test_case_3_later_branch();
    if ( (t.n <= 0) || (t.n == 4)) test_case_4_earlier_branch();
    if ( (t.n <= 0) || (t.n == 5)) test_case_5_intra_parity();
    if ( (t.n <= 0) || (t.n == 6)) test_case_6_inter_parity();
    if ( (t.n <= 0) || (t.n == 7)) test_case_7_inter_intra_parity();
    if ( (t.n <= 0) || (t.n == 8)) test_case_8_random();

  endtask
endmodule

//========================================================================
// SeqNumCompare_test
//========================================================================

module SeqNumCompare_test;
  SeqNumCompareTestSuite #(1)       suite_1();
  SeqNumCompareTestSuite #(2, 8, 3) suite_2();
  SeqNumCompareTestSuite #(3, 4, 4) suite_3();

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
