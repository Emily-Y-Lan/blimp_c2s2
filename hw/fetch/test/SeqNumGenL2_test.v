//========================================================================
// SeqNumGenL2_test.v
//========================================================================
// A testbench for testing our sequence number generator

`include "hw/fetch/SeqNumGenL2.v"
`include "intf/CommitNotif.v"
`include "test/TestUtils.v"
`include "test/fl/TestOstream.v"
`include "test/fl/TestPub.v"

import TestEnv::*;

//========================================================================
// SeqNumGenL2TestSuite
//========================================================================
// A test suite for a particular parametrization of the sequence number
// generator

module SeqNumGenL2TestSuite #(
  parameter p_suite_num     = 0,
  parameter p_seq_num_bits  = 5,
  parameter p_reclaim_width = 2,

  parameter p_alloc_intv_delay = 0
);

  string suite_name = $sformatf("%0d: SequencingUnitL1TestSuite_%0d_%0d_%0d",
                                p_suite_num, p_seq_num_bits,
                                p_reclaim_width, p_alloc_intv_delay);

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

  localparam p_num_seq_nums = 2 ** p_seq_num_bits;

  logic [p_seq_num_bits-1:0] alloc_seq_num;
  logic                      alloc_val;
  logic                      alloc_rdy;

  CommitNotif #(
    .p_seq_num_bits (p_seq_num_bits)
  ) commit_notif();

  SeqNumGenL2 #(
    .p_seq_num_bits  (p_seq_num_bits),
    .p_reclaim_width (p_reclaim_width)
  ) dut (
    .commit (commit_notif),
    .*
  );

  //----------------------------------------------------------------------
  // FL Allocator
  //----------------------------------------------------------------------

  TestOstream #(
    logic[p_seq_num_bits-1:0],
    p_alloc_intv_delay
  ) alloc_Ostream (
    .msg (alloc_seq_num),
    .val (alloc_val),
    .rdy (alloc_rdy),
    .*
  );

  task seq_alloc(
    input logic [p_seq_num_bits-1:0] seq_num
  );
    alloc_Ostream.recv( seq_num );
  endtask

  //----------------------------------------------------------------------
  // FL Freer
  //----------------------------------------------------------------------

  typedef struct packed {
    logic               [31:0] pc;
    logic [p_seq_num_bits-1:0] seq_num;
    logic                [4:0] waddr;
    logic               [31:0] wdata;
    logic                      wen;
  } t_commit_msg;

  t_commit_msg commit_msg;

  assign commit_notif.pc      = commit_msg.pc;
  assign commit_notif.seq_num = commit_msg.seq_num;
  assign commit_notif.waddr   = commit_msg.waddr;
  assign commit_notif.wdata   = commit_msg.wdata;
  assign commit_notif.wen     = commit_msg.wen;

  TestPub #( t_commit_msg ) free_pub (
    .msg (commit_msg),
    .val (commit_notif.val),
    .*
  );

  t_commit_msg msg_to_commit;

  task seq_free(
    input logic [p_seq_num_bits-1:0] seq_num
  );
    msg_to_commit.seq_num = seq_num;
    msg_to_commit.pc      = 32'( $urandom() );
    msg_to_commit.waddr   =  5'( $urandom() );
    msg_to_commit.wdata   = 32'( $urandom() );
    msg_to_commit.wen     =  1'( $urandom() );

    free_pub.pub( msg_to_commit );
  endtask

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
  // check_allocated
  //----------------------------------------------------------------------
  // White-box testing the number of allocated entries

  task check_allocated ( input int num_allocated );
    `CHECK_EQ( int'(dut.entries_allocated), num_allocated );
  endtask

  //----------------------------------------------------------------------
  // Include test cases
  //----------------------------------------------------------------------

  `include "hw/fetch/test/seq_num_test_cases/basic_test_cases.v"

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  task run_test_suite();
    t.test_suite_begin( suite_name );

    run_basic_test_cases();
  endtask
endmodule

//========================================================================
// SeqNumGenL2_test
//========================================================================

module SeqNumGenL2_test;
  SeqNumGenL2TestSuite #(1)          suite_1();
  SeqNumGenL2TestSuite #(2, 6, 2, 0) suite_2();
  SeqNumGenL2TestSuite #(3, 8, 2, 0) suite_3();
  SeqNumGenL2TestSuite #(4, 8, 4, 0) suite_4();
  SeqNumGenL2TestSuite #(5, 8, 8, 3) suite_5();

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
