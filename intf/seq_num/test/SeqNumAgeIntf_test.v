//========================================================================
// SeqNumAgeIntf_test.v
//========================================================================
// A testbench for our sequence number age logic

`include "test/TestUtils.v"
`include "intf/seq_num/SeqNumAgeIntf.v"

import TestEnv::*;

//========================================================================
// SeqNumAgeIntfTestSuite
//========================================================================
// A test suite for a particular parametrization of the age logic

module SeqNumAgeIntfTestSuite #(
  parameter p_suite_num    = 0,
  parameter p_seq_num_bits = 5,
  parameter p_num_epochs   = 4
);

  string suite_name = $sformatf("%0d: SeqNumAgeIntfTestSuite_%0d_%0d",
                                p_suite_num, p_seq_num_bits, p_num_epochs);

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

  localparam p_epoch_bits = $clog2( p_num_epochs );
  logic [p_epoch_bits-1:0] dut_curr_tail_epoch;

  SeqNumAgeIntf #(
    .p_seq_num_bits (p_seq_num_bits),
    .p_num_epochs   (p_num_epochs)
  ) dut();

  assign dut.curr_tail_epoch = dut_curr_tail_epoch;

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  logic dut_is_older;

  task check (
    input logic   [p_epoch_bits-1:0] curr_tail_epoch,
    input logic [p_seq_num_bits-1:0] seq_num_0,
    input logic [p_seq_num_bits-1:0] seq_num_1,
    input logic                      is_older
  );
    if ( !t.failed ) begin
      dut_curr_tail_epoch = curr_tail_epoch;

      #8;
      
      dut_is_older = dut.is_older( seq_num_0, seq_num_1 );

      if ( t.verbose ) begin
        $display( "%3d: %h %h %h > %b", t.cycles,
                  curr_tail_epoch, seq_num_0, seq_num_1, dut_is_older );
      end

      `CHECK_EQ( dut_is_older, is_older );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // mk_seq_num
  //----------------------------------------------------------------------
  // Helper function for making sequence numbers, isolating the epoch

  function logic [p_seq_num_bits-1:0] mk_seq_num (
    input logic [p_epoch_bits-1:0]                epoch,
    input logic [p_seq_num_bits-p_epoch_bits-1:0] remainder 
  );
    return { epoch, remainder };
  endfunction

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );
    if( !t.run_test ) return;

    //     curr_epoch seq_num_0         seq_num_1         is_older
    check( 0,         mk_seq_num(0, 1), mk_seq_num(0, 2), 1 );
    check( 0,         mk_seq_num(0, 2), mk_seq_num(0, 1), 0 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_lesser_epoch
  //----------------------------------------------------------------------

  task test_case_2_lesser_epoch();
    t.test_case_begin( "test_case_2_lesser_epoch" );
    if( !t.run_test ) return;

    //     curr_epoch seq_num_0         seq_num_1         is_older
    check( 0,         mk_seq_num(2, 1), mk_seq_num(3, 2), 1 );
    check( 0,         mk_seq_num(3, 1), mk_seq_num(2, 2), 0 );
    check( 1,         mk_seq_num(3, 2), mk_seq_num(2, 1), 0 );
    check( 1,         mk_seq_num(2, 2), mk_seq_num(3, 1), 1 );
    check( 2,         mk_seq_num(3, 2), mk_seq_num(3, 3), 1 );
    check( 2,         mk_seq_num(3, 3), mk_seq_num(3, 2), 0 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_3_greater_epoch
  //----------------------------------------------------------------------

  task test_case_3_greater_epoch();
    t.test_case_begin( "test_case_3_greater_epoch" );
    if( !t.run_test ) return;

    //     curr_epoch seq_num_0         seq_num_1         is_older
    check( 2,         mk_seq_num(0, 1), mk_seq_num(1, 2), 1 );
    check( 2,         mk_seq_num(1, 1), mk_seq_num(0, 2), 0 );
    check( 3,         mk_seq_num(1, 2), mk_seq_num(0, 1), 0 );
    check( 3,         mk_seq_num(0, 2), mk_seq_num(1, 1), 1 );
    check( 3,         mk_seq_num(2, 2), mk_seq_num(2, 3), 1 );
    check( 3,         mk_seq_num(2, 3), mk_seq_num(2, 2), 0 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_4_middle_epoch
  //----------------------------------------------------------------------

  task test_case_4_middle_epoch();
    t.test_case_begin( "test_case_4_middle_epoch" );
    if( !t.run_test ) return;

    //     curr_epoch seq_num_0         seq_num_1         is_older
    check( 2,         mk_seq_num(3, 1), mk_seq_num(1, 2), 1 );
    check( 2,         mk_seq_num(1, 1), mk_seq_num(3, 2), 0 );
    check( 2,         mk_seq_num(1, 2), mk_seq_num(3, 1), 0 );
    check( 2,         mk_seq_num(3, 2), mk_seq_num(1, 1), 1 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_5_same_epoch
  //----------------------------------------------------------------------

  task test_case_5_same_epoch();
    t.test_case_begin( "test_case_5_same_epoch" );
    if( !t.run_test ) return;

    //     curr_epoch seq_num_0         seq_num_1         is_older
    check( 2,         mk_seq_num(2, 1), mk_seq_num(1, 2), 1 );
    check( 2,         mk_seq_num(2, 1), mk_seq_num(3, 2), 1 );
    check( 2,         mk_seq_num(1, 2), mk_seq_num(2, 1), 0 );
    check( 2,         mk_seq_num(3, 2), mk_seq_num(2, 1), 0 );
    check( 2,         mk_seq_num(2, 2), mk_seq_num(2, 1), 0 );
    check( 2,         mk_seq_num(2, 1), mk_seq_num(2, 2), 1 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_6_random
  //----------------------------------------------------------------------

  logic [p_seq_num_bits-1:0] rand_seq_num_0;
  logic [p_seq_num_bits-1:0] rand_seq_num_1;
  logic   [p_epoch_bits-1:0] rand_curr_tail_epoch;
  logic                      exp_is_older;

  int seq_num_0_epoch, seq_num_1_epoch;

  task test_case_6_random();
    t.test_case_begin( "test_case_6_random" );
    if( !t.run_test ) return;

    for( int i = 0; i < 30; i++ ) begin
      do begin
        // Must do modulus by number of epochs
        rand_seq_num_0[p_seq_num_bits-1:p_seq_num_bits-p_epoch_bits]
         = p_epoch_bits'( $urandom() % p_num_epochs );
        rand_seq_num_1[p_seq_num_bits-1:p_seq_num_bits-p_epoch_bits]
         = p_epoch_bits'( $urandom() % p_num_epochs );
        rand_curr_tail_epoch =   p_epoch_bits'( $urandom() % p_num_epochs );

        rand_seq_num_0[p_seq_num_bits-p_epoch_bits-1:0]
          = ( p_seq_num_bits - p_epoch_bits )'( $urandom() );
        rand_seq_num_1[p_seq_num_bits-p_epoch_bits-1:0]
          = ( p_seq_num_bits - p_epoch_bits )'( $urandom() );
      end while( rand_seq_num_0 == rand_seq_num_1 );

      seq_num_0_epoch = int'( rand_seq_num_0[p_seq_num_bits-1:p_seq_num_bits-p_epoch_bits] );
      seq_num_1_epoch = int'( rand_seq_num_1[p_seq_num_bits-1:p_seq_num_bits-p_epoch_bits] );

      if( seq_num_0_epoch < int'( rand_curr_tail_epoch ) )
        seq_num_0_epoch = seq_num_0_epoch + p_num_epochs;
      if( seq_num_1_epoch < int'( rand_curr_tail_epoch ) )
        seq_num_1_epoch = seq_num_1_epoch + p_num_epochs;

      if( seq_num_0_epoch != seq_num_1_epoch )
        exp_is_older = ( seq_num_0_epoch < seq_num_1_epoch );
      else
        exp_is_older = (
          rand_seq_num_0[p_seq_num_bits-p_epoch_bits-1:0] < 
          rand_seq_num_1[p_seq_num_bits-p_epoch_bits-1:0]
        );

      check( rand_curr_tail_epoch, rand_seq_num_0, rand_seq_num_1, exp_is_older );
    end

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  task run_test_suite();
    t.test_suite_begin( suite_name );

    test_case_1_basic();
    test_case_2_lesser_epoch();
    test_case_3_greater_epoch();
    test_case_4_middle_epoch();
    test_case_5_same_epoch();
    test_case_6_random();
  endtask
endmodule

//========================================================================
// SeqNumAgeIntf_test
//========================================================================

module SeqNumAgeIntf_test;
  SeqNumAgeIntfTestSuite #(1)         suite_1();
  SeqNumAgeIntfTestSuite #(2,  6,  4) suite_2();
  SeqNumAgeIntfTestSuite #(3,  8,  6) suite_3();
  SeqNumAgeIntfTestSuite #(3, 32, 32) suite_4();

  int s;

  initial begin
    test_bench_begin( `__FILE__ );
    s = get_test_suite();

    if ((s <= 0) || (s == 1)) suite_1.run_test_suite();
    if ((s <= 0) || (s == 2)) suite_2.run_test_suite();
    if ((s <= 0) || (s == 3)) suite_3.run_test_suite();
    if ((s <= 0) || (s == 4)) suite_4.run_test_suite();

    test_bench_end();
  end
endmodule
