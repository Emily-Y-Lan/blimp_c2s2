//========================================================================
// SequencingUnitL1_test.v
//========================================================================
// A testbench for testing our sequencing unit

`include "hw/seq_num/SequencingUnitL1.v"
`include "intf/seq_num/SeqNumAgeIntf.v"
`include "intf/seq_num/SeqNumAllocIntf.v"
`include "intf/seq_num/SeqNumFreeIntf.v"
`include "test/TestUtils.v"
`include "test/fl/TestOstream.v"
`include "test/fl/TestPub.v"

import TestEnv::*;

//========================================================================
// SequencingUnitL1TestSuite
//========================================================================
// A test suite for a particular parametrization of the sequencing unit

module SequencingUnitL1TestSuite #(
  parameter p_suite_num    = 0,
  parameter p_seq_num_bits = 5,
  parameter p_num_epochs   = 4,
  parameter p_free_width   = 2,

  parameter p_alloc_intv_delay = 0
);

  string suite_name = $sformatf("%0d: SequencingUnitL1TestSuite_%0d_%0d_%0d",
                                p_suite_num, p_seq_num_bits,
                                p_num_epochs, p_free_width);

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

  SeqNumAllocIntf #(
    .p_seq_num_bits (p_seq_num_bits)
  ) alloc();

  SeqNumFreeIntf #(
    .p_seq_num_bits (p_seq_num_bits)
  ) free();
  
  SeqNumAgeIntf #(
    .p_seq_num_bits (p_seq_num_bits),
    .p_num_epochs   (p_num_epochs)
  ) age();

  SequencingUnitL1 #(
    .p_free_width (p_free_width)
  ) dut (
    .*
  );

  //----------------------------------------------------------------------
  // FL Allocator
  //----------------------------------------------------------------------

  TestOstream #(
    logic[p_seq_num_bits-1:0],
    p_alloc_intv_delay
  ) alloc_Ostream (
    .msg (alloc.seq_num),
    .val (alloc.val),
    .rdy (alloc.rdy),
    .*
  );

  //----------------------------------------------------------------------
  // FL Freer
  //----------------------------------------------------------------------

  TestPub #( logic[p_seq_num_bits-1:0] ) free_pub (
    .msg (free.seq_num),
    .val (free.val),
    .*
  );

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

  string trace;

  // verilator lint_off BLKSEQ
  always_ff @( posedge clk ) begin
    #2;
    trace = "";

    trace = {trace, alloc_Ostream.trace()};
    trace = {trace, " | "};
    trace = {trace, dut.trace()};
    trace = {trace, " | "};
    trace = {trace, free_pub.trace()};

    t.trace( trace );
  end
  // verilator lint_on BLKSEQ

  //----------------------------------------------------------------------
  // check_age
  //----------------------------------------------------------------------
  // Compare age between sequence numbers (robust testing done on the
  // interface)

  logic dut_is_older;

  task check_age (
    input logic[p_seq_num_bits-1:0] seq_num_0,
    input logic[p_seq_num_bits-1:0] seq_num_1,
    input logic                     is_older // Whether 0 is older than 1
  );
    if ( !t.failed ) begin      
      dut_is_older = age.is_older( seq_num_0, seq_num_1 );
      `CHECK_EQ( dut_is_older, is_older );
    end
  endtask

  //----------------------------------------------------------------------
  // check_allocated
  //----------------------------------------------------------------------
  // White-box testing the number of allocated entries

  task check_allocated ( input int num_allocated );
    `CHECK_EQ( int'(dut.entries_allocated), num_allocated );
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

    alloc_Ostream.recv( mk_seq_num(0, 0) );
    alloc_Ostream.recv( mk_seq_num(0, 1) );

    check_age( mk_seq_num(0, 0), mk_seq_num(0, 1), 1 );
    check_allocated( 2 );

    free_pub.pub( mk_seq_num(0, 0) );
    free_pub.pub( mk_seq_num(0, 1) );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  task run_test_suite();
    t.test_suite_begin( suite_name );

    test_case_1_basic();
  endtask
endmodule

//========================================================================
// SequencingUnitL1_test
//========================================================================

module SequencingUnitL1_test;
  SequencingUnitL1TestSuite #(1)                suite_1();
  SequencingUnitL1TestSuite #(2,  6,  4,  2, 0) suite_2();
  SequencingUnitL1TestSuite #(3,  8,  6,  2, 0) suite_3();
  SequencingUnitL1TestSuite #(3, 16, 16,  4, 0) suite_4();
  SequencingUnitL1TestSuite #(3, 32, 32,  8, 3) suite_5();

  int s;

  initial begin
    test_bench_begin( `__FILE__ );
    s = get_test_suite();

    if ((s <= 0) || (s == 1)) suite_1.run_test_suite();
    if ((s <= 0) || (s == 2)) suite_2.run_test_suite();
    if ((s <= 0) || (s == 3)) suite_3.run_test_suite();
    if ((s <= 0) || (s == 4)) suite_4.run_test_suite();
    if ((s <= 0) || (s == 5)) suite_5.run_test_suite();

    test_bench_end();
  end
endmodule
