//========================================================================
// SeqArb_test.v
//========================================================================
// A testbench for our sequence number arbiter

`include "test/TestUtils.v"
`include "hw/util/SeqArb.v"
`include "intf/CommitNotif.v"
`include "test/fl/TestPub.v"

import TestEnv::*;

//========================================================================
// SeqArbTestSuite
//========================================================================
// A test suite for a particular parametrization of the age logic

module SeqArbTestSuite #(
  parameter p_suite_num    = 0,
  parameter p_seq_num_bits = 5
);

  string suite_name = $sformatf("%0d: SeqNumAgeIntfTestSuite_%0d",
                                p_suite_num, p_seq_num_bits);

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk, rst;

  TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic [p_seq_num_bits-1:0] dut_seq_num_0;
  logic [p_seq_num_bits-1:0] dut_seq_num_1;
  logic [p_seq_num_bits-1:0] dut_seq_num_2;
  logic                      dut_val_0;
  logic                      dut_val_1;
  logic                      dut_val_2;
  logic                      dut_gnt_unpacked [2:0];
  logic                [2:0] dut_gnt;

  assign dut_gnt[0] = dut_gnt_unpacked[0];
  assign dut_gnt[1] = dut_gnt_unpacked[1];
  assign dut_gnt[2] = dut_gnt_unpacked[2];

  CommitNotif #( 
    .p_seq_num_bits (p_seq_num_bits)
  ) commit_notif();

  SeqArb #(
    .p_seq_num_bits (p_seq_num_bits),
    .p_num_arb      (3)
  ) dut(
    .seq_num ({dut_seq_num_0, dut_seq_num_1, dut_seq_num_2}),
    .val     ({dut_val_0, dut_val_1, dut_val_2}),
    .gnt     (dut_gnt_unpacked),
    .commit  (commit_notif),
    .*
  );

  logic [31:0] unused_commit_pc;
  logic  [4:0] unused_commid_waddr;
  logic [31:0] unused_commit_wdata;
  logic        unused_commit_wen;

  assign unused_commit_pc    = commit_notif.pc;
  assign unused_commid_waddr = commit_notif.waddr;
  assign unused_commit_wdata = commit_notif.wdata;
  assign unused_commit_wen   = commit_notif.wen;

  //----------------------------------------------------------------------
  // commit
  //----------------------------------------------------------------------
  // Commit an instruction with a given sequence number

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

  TestPub #(
    t_commit_msg
  ) CommitPub (
    .msg (commit_msg),
    .val (commit_notif.val),
    .*
  );

  t_commit_msg msg_to_pub;

  task commit (
    input logic [p_seq_num_bits-1:0] seq_num
  );
    msg_to_pub.pc      = 32'( $urandom() );
    msg_to_pub.waddr   =  5'( $urandom() );
    msg_to_pub.wdata   = 32'( $urandom() );
    msg_to_pub.wen     =  1'( $urandom() );
    msg_to_pub.seq_num = seq_num;

    CommitPub.pub( msg_to_pub );
  endtask

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check (
    input  logic [p_seq_num_bits-1:0] seq_num_0,
    input  logic [p_seq_num_bits-1:0] seq_num_1,
    input  logic [p_seq_num_bits-1:0] seq_num_2,
    input  logic                      val_0,
    input  logic                      val_1,
    input  logic                      val_2,
    input  logic                [2:0] gnt
  );
    if ( !t.failed ) begin
      dut_seq_num_0 = seq_num_0;
      dut_seq_num_1 = seq_num_1;
      dut_seq_num_2 = seq_num_2;
      dut_val_0     = val_0;
      dut_val_1     = val_1;
      dut_val_2     = val_2;

      #8;

      if ( t.verbose ) begin
        $display( "%3d: %h (%b) %h (%b) %h (%b) > %b", t.cycles,
                  dut_seq_num_0, dut_seq_num_1, dut_seq_num_2,
                  dut_val_0, dut_val_1, dut_val_2, dut_gnt );
      end

      `CHECK_EQ( dut_gnt, gnt );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );
    if( !t.run_test ) return;

    //     seq_num_0 seq_num_1 seq_num_2 val_0 val_1 val_2 gnt
    check( 1,        2,        3,        1,    1,    1,    3'b100 );
    check( 3,        1,        2,        1,    1,    1,    3'b010 );
    check( 2,        3,        1,        1,    1,    1,    3'b001 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_commit
  //----------------------------------------------------------------------

  task test_case_2_commit();
    t.test_case_begin( "test_case_2_commit" );
    if( !t.run_test ) return;

    commit( 2 ); // Oldest is 3

    //     seq_num_0 seq_num_1 seq_num_2 val_0 val_1 val_2 gnt
    check( 1,        2,        3,        1,    1,    1,    3'b001 );
    check( 3,        1,        2,        1,    1,    1,    3'b100 );
    check( 2,        3,        1,        1,    1,    1,    3'b010 );

    // Check when 3 isn't present

    //     seq_num_0 seq_num_1 seq_num_2 val_0 val_1 val_2 gnt
    check( 1,        2,        0,        1,    1,    1,    3'b001 );
    check( 2,        1,        2,        1,    1,    1,    3'b010 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_3_valid
  //----------------------------------------------------------------------

  task test_case_3_valid();
    t.test_case_begin( "test_case_3_valid" );
    if( !t.run_test ) return;

    commit( 1 ); // Oldest is 2

    //     seq_num_0 seq_num_1 seq_num_2 val_0 val_1 val_2 gnt
    check( 3,        2,        1,        1,    1,    1,    3'b010 );
    check( 3,        2,        1,        1,    0,    1,    3'b100 );
    check( 3,        2,        1,        0,    0,    1,    3'b001 );
    check( 3,        2,        1,        0,    1,    1,    3'b010 );
    check( 3,        2,        1,        0,    0,    0,    3'b000 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_4_random
  //----------------------------------------------------------------------

  logic [p_seq_num_bits-1:0] rand_seq_num_0;
  logic [p_seq_num_bits-1:0] rand_seq_num_1;
  logic [p_seq_num_bits-1:0] rand_seq_num_2;
  logic [p_seq_num_bits-1:0] rand_oldest_seq_num;
  logic                      rand_val_0;
  logic                      rand_val_1;
  logic                      rand_val_2;
  logic                [2:0] exp_gnt;

  longint rand_seq_num_0_adj;
  longint rand_seq_num_1_adj;
  longint rand_seq_num_2_adj;
  longint oldest_seq_number;
  logic   oldest_val;

  task test_case_4_random();
    t.test_case_begin( "test_case_4_random" );
    if( !t.run_test ) return;

    for( int i = 0; i < 30; i++ ) begin
      rand_seq_num_0 = p_seq_num_bits'( $urandom() );
      do begin
        rand_seq_num_1 = p_seq_num_bits'( $urandom() );
      end while( rand_seq_num_0 == rand_seq_num_1 );
      do begin
        rand_seq_num_2 = p_seq_num_bits'( $urandom() );
      end while(
        (rand_seq_num_0 == rand_seq_num_2 ) | 
        (rand_seq_num_1 == rand_seq_num_2 )
      );
      rand_oldest_seq_num = p_seq_num_bits'( $urandom() );

      rand_val_0 = 1'( $urandom() );
      rand_val_1 = 1'( $urandom() );
      rand_val_2 = 1'( $urandom() );

      rand_seq_num_0_adj = longint'(rand_seq_num_0);
      rand_seq_num_1_adj = longint'(rand_seq_num_1);
      rand_seq_num_2_adj = longint'(rand_seq_num_2);

      if( rand_seq_num_0_adj < longint'(rand_oldest_seq_num) )
        rand_seq_num_0_adj = rand_seq_num_0_adj + ( 2 ** p_seq_num_bits );
      if( rand_seq_num_1_adj < longint'(rand_oldest_seq_num) )
        rand_seq_num_1_adj = rand_seq_num_1_adj + ( 2 ** p_seq_num_bits );
      if( rand_seq_num_2_adj < longint'(rand_oldest_seq_num) )
        rand_seq_num_2_adj = rand_seq_num_2_adj + ( 2 ** p_seq_num_bits );

      oldest_seq_number = rand_seq_num_0_adj;
      oldest_val        = rand_val_0;
      if(( rand_val_1 & ( rand_seq_num_1_adj < oldest_seq_number )) | !oldest_val ) begin
        oldest_seq_number = rand_seq_num_1_adj;
        oldest_val        = rand_val_1;
      end
      if(( rand_val_2 & ( rand_seq_num_2_adj < oldest_seq_number )) | !oldest_val ) begin
        oldest_seq_number = rand_seq_num_2_adj;
        oldest_val        = rand_val_2;
      end

      exp_gnt[2] = ( oldest_seq_number == rand_seq_num_0_adj ) & rand_val_0;
      exp_gnt[1] = ( oldest_seq_number == rand_seq_num_1_adj ) & rand_val_1;
      exp_gnt[0] = ( oldest_seq_number == rand_seq_num_2_adj ) & rand_val_2;

      commit( rand_oldest_seq_num - 1 ); // Tail is now rand_oldest_seq_num
      check( rand_seq_num_0, rand_seq_num_1, rand_seq_num_2,
             rand_val_0,     rand_val_1,     rand_val_2,
             exp_gnt );
    end

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  task run_test_suite();
    t.test_suite_begin( suite_name );

    test_case_1_basic();
    test_case_2_commit();
    test_case_3_valid();
    test_case_4_random();
  endtask
endmodule

//========================================================================
// SeqAge_test
//========================================================================

module SeqArb_test;
  SeqArbTestSuite #(1)     suite_1();
  SeqArbTestSuite #(2,  6) suite_2();
  SeqArbTestSuite #(3,  8) suite_3();
  SeqArbTestSuite #(4, 32) suite_4();

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
