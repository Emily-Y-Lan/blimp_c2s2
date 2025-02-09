//========================================================================
// Multiplier_test.v
//========================================================================
// A testbench for our Multiplier

`include "defs/UArch.v"
`include "hw/execute/execute_variants/Multiplier.v"
`include "test/TraceUtils.v"
`include "test/fl/TestIstream.v"
`include "test/fl/TestOstream.v"

import UArch::*;
import TestEnv::*;

//========================================================================
// MultiplierTestSuite
//========================================================================
// A test suite for the multiplier

module MultiplierTestSuite #(
  parameter p_suite_num    = 0,
  parameter p_addr_bits    = 32,
  parameter p_data_bits    = 32,
  parameter p_seq_num_bits = 5,

  parameter p_D_send_intv_delay = 0,
  parameter p_W_recv_intv_delay = 0
);

  //verilator lint_off UNUSEDSIGNAL
  string suite_name = $sformatf("%0d: MultiplierTestSuite_%0d_%0d_%0d_%0d", 
                                p_suite_num, p_addr_bits, p_data_bits,
                                p_D_send_intv_delay, p_W_recv_intv_delay);
  //verilator lint_on UNUSEDSIGNAL

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk, rst;
  TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  D__XIntf #(
    .p_addr_bits    (p_addr_bits),
    .p_data_bits    (p_data_bits),
    .p_seq_num_bits (p_seq_num_bits)
  ) D__X_intf();

  X__WIntf #(
    .p_addr_bits    (p_addr_bits),
    .p_data_bits    (p_data_bits),
    .p_seq_num_bits (p_seq_num_bits)
  ) X__W_intf();

  Multiplier #(
    .p_addr_bits    (p_addr_bits),
    .p_data_bits    (p_data_bits),
    .p_seq_num_bits (p_seq_num_bits)
  ) dut (
    .D (D__X_intf),
    .W (X__W_intf),
    .*
  );

  //----------------------------------------------------------------------
  // FL D Interface
  //----------------------------------------------------------------------

  typedef struct packed {
    logic    [p_addr_bits-1:0] pc;
    logic [p_seq_num_bits-1:0] seq_num;
    logic    [p_data_bits-1:0] op1;
    logic    [p_data_bits-1:0] op2;
    logic                [4:0] waddr;
    rv_uop                     uop;
  } t_d__x_msg;

  t_d__x_msg d__x_msg;

  assign D__X_intf.pc      = d__x_msg.pc;
  assign D__X_intf.seq_num = d__x_msg.seq_num;
  assign D__X_intf.op1     = d__x_msg.op1;
  assign D__X_intf.op2     = d__x_msg.op2;
  assign D__X_intf.waddr   = d__x_msg.waddr;
  assign D__X_intf.uop     = d__x_msg.uop;

  TestIstream #( t_d__x_msg, p_D_send_intv_delay ) D_Istream (
    .msg (d__x_msg),
    .val (D__X_intf.val),
    .rdy (D__X_intf.rdy),
    .*
  );

  t_d__x_msg msg_to_send;

  task send(
    input logic    [p_addr_bits-1:0] pc,
    input logic [p_seq_num_bits-1:0] seq_num,
    input logic    [p_data_bits-1:0] op1,
    input logic    [p_data_bits-1:0] op2,
    input logic                [4:0] waddr,
    input rv_uop                     uop
  );
    msg_to_send.pc      = pc;
    msg_to_send.seq_num = seq_num;
    msg_to_send.op1     = op1;
    msg_to_send.op2     = op2;
    msg_to_send.waddr   = waddr;
    msg_to_send.uop     = uop;

    D_Istream.send(msg_to_send);
  endtask

  //----------------------------------------------------------------------
  // FL W Interface
  //----------------------------------------------------------------------

  typedef struct packed {
    logic    [p_addr_bits-1:0] pc;
    logic [p_seq_num_bits-1:0] seq_num;
    logic                [4:0] waddr;
    logic    [p_data_bits-1:0] wdata;
    logic                      wen;
  } t_x__w_msg;

  t_x__w_msg x__w_msg;

  assign x__w_msg.pc      = X__W_intf.pc;
  assign x__w_msg.seq_num = X__W_intf.seq_num;
  assign x__w_msg.waddr   = X__W_intf.waddr;
  assign x__w_msg.wdata   = X__W_intf.wdata;
  assign x__w_msg.wen     = X__W_intf.wen;

  TestOstream #( t_x__w_msg, p_W_recv_intv_delay ) W_Ostream (
    .msg (x__w_msg),
    .val (X__W_intf.val),
    .rdy (X__W_intf.rdy),
    .*
  );

  t_x__w_msg msg_to_recv;

  task recv(
    input logic    [p_addr_bits-1:0] pc,
    input logic [p_seq_num_bits-1:0] seq_num,
    input logic                [4:0] waddr,
    input logic    [p_data_bits-1:0] wdata,
    input logic                      wen
  );
    msg_to_recv.pc      = pc;
    msg_to_recv.seq_num = seq_num;
    msg_to_recv.waddr   = waddr;
    msg_to_recv.wdata   = wdata;
    msg_to_recv.wen     = wen;

    W_Ostream.recv(msg_to_recv);
  endtask

  Tracer tracer ( clk, {
    D_Istream.trace,
    " | ",
    dut.trace,
    " | ",
    W_Ostream.trace
  } );

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );
    if( t.n != 0 )
      tracer.enable_trace();

    fork
      //   pc  seq_num op1 op2 waddr uop
      send('0, 0,      1,  2,  5'h1, OP_MUL);

      //   pc  seq_num waddr wdata wen
      recv('0, 0,      5'h1, 2,    1);
    join

    tracer.disable_trace();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_pos_pos
  //----------------------------------------------------------------------

  task test_case_2_pos_pos();
    t.test_case_begin( "test_case_2_pos_pos" );
    if( t.n != 0 )
      tracer.enable_trace();

    fork
      begin
        //   pc  seq_num op1                       op2  waddr uop
        send('0, 1,                             4,  3,  5'h1, OP_MUL);
        send('1, 2,                            12, 12,  5'h4, OP_MUL);
        send('0, 3,      p_data_bits'('h80000000),  2,  5'h2, OP_MUL);
      end

      begin
        //   pc  seq_num waddr wdata wen
        recv('0, 1,      5'h1,  12,  1);
        recv('1, 2,      5'h4, 144,  1);
        recv('0, 3,      5'h2,   0,  1);
      end
    join

    tracer.disable_trace();
  endtask

  //----------------------------------------------------------------------
  // test_case_3_pos_neg
  //----------------------------------------------------------------------

  task test_case_3_pos_neg();
    t.test_case_begin( "test_case_3_pos_neg" );
    if( t.n != 0 )
      tracer.enable_trace();

    fork
      begin
        //   pc  seq_num op1                       op2  waddr uop   
        send('0, 1,                             4,  -3, 5'h1, OP_MUL);
        send('1, 0,                            12, -12, 5'h4, OP_MUL);
        send('0, 1,      p_data_bits'('h80000000),  -2, 5'h2, OP_MUL);
      end

      begin
        //   pc  seq_num waddr wdata wen
        recv('0, 1,      5'h1,  -12, 1);
        recv('1, 0,      5'h4, -144, 1);
        recv('0, 1,      5'h2,    0, 1);
      end
    join

    tracer.disable_trace();
  endtask

  //----------------------------------------------------------------------
  // test_case_4_neg_pos
  //----------------------------------------------------------------------

  task test_case_4_neg_pos();
    t.test_case_begin( "test_case_4_neg_pos" );
    if( t.n != 0 )
      tracer.enable_trace();

    fork
      begin
        //   pc  seq_num op1  op2 waddr uop   
        send('0, 2,       -4,  3, 5'h1, OP_MUL);
        send('1, 2,      -12, 12, 5'h4, OP_MUL);
      end

      begin
        //   pc  seq_num waddr wdata wen
        recv('0, 2,      5'h1,  -12, 1 );
        recv('1, 2,      5'h4, -144, 1 );
      end
    join

    tracer.disable_trace();
  endtask

  //----------------------------------------------------------------------
  // test_case_5_neg_neg
  //----------------------------------------------------------------------

  task test_case_5_neg_neg();
    t.test_case_begin( "test_case_5_neg_neg" );
    if( t.n != 0 )
      tracer.enable_trace();

    fork
      begin
        //   pc  seq_num op1  op2  waddr uop    
        send('1, 0,      -4,  -3, 5'h1, OP_MUL);
        send('0, 0,     -12, -12, 5'h4, OP_MUL);
      end

      begin
        //   pc  seq_num waddr wdata wen
        recv('1, 0,      5'h1,  12,  1 );
        recv('0, 0,      5'h4, 144,  1 );
      end
    join

    tracer.disable_trace();
  endtask

  //----------------------------------------------------------------------
  // test_case_6_zero
  //----------------------------------------------------------------------

  task test_case_6_zero();
    t.test_case_begin( "test_case_6_zero" );
    if( t.n != 0 )
      tracer.enable_trace();

    fork
      begin
        //   pc  seq_num op1 op2 waddr uop
        send('1, 3,      4,   0, 5'h1, OP_MUL);
        send('0, 2,      0,  12, 5'h4, OP_MUL);
        send('1, 1,      0,   0, 5'h2, OP_MUL);
      end

      begin
        //   pc  seq_num waddr wdata wen
        recv('1, 3,      5'h1, 0,    1 );
        recv('0, 2,      5'h4, 0,    1 );
        recv('1, 1,      5'h2, 0,    1 );
      end
    join

    tracer.disable_trace();
  endtask

  //----------------------------------------------------------------------
  // test_case_7_random
  //----------------------------------------------------------------------

  logic    [p_addr_bits-1:0] rand_pc;
  logic [p_seq_num_bits-1:0] rand_seq_num;
  logic    [p_data_bits-1:0] rand_op1, rand_op2, exp_out;
  logic                [4:0] rand_waddr;

  task test_case_7_random();
    t.test_case_begin( "test_case_7_random" );
    if( t.n != 0 )
      tracer.enable_trace();

    for( int i = 0; i < 20; i = i + 1 ) begin
      rand_pc      = p_addr_bits'($urandom());
      rand_seq_num = p_seq_num_bits'($urandom());
      rand_op1     = p_data_bits'($urandom());
      rand_op2     = p_data_bits'($urandom());
      rand_waddr   = 5'($urandom());
      exp_out      = rand_op1 * rand_op2;

      fork
        send(rand_pc, rand_seq_num, rand_op1, rand_op2, rand_waddr, OP_MUL);
        recv(rand_pc, rand_seq_num, rand_waddr, exp_out, 1);
      join
    end

    tracer.disable_trace();
  endtask

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  task run_test_suite();
    t.test_suite_begin( suite_name );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_pos_pos();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_pos_neg();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_neg_pos();
    if ((t.n <= 0) || (t.n == 5)) test_case_5_neg_neg();
    if ((t.n <= 0) || (t.n == 6)) test_case_6_zero();
    if ((t.n <= 0) || (t.n == 7)) test_case_7_random();

  endtask

endmodule

//========================================================================
// Multiplier_test
//========================================================================

module Multiplier_test;
  MultiplierTestSuite #(1)                  suite_1();
  MultiplierTestSuite #(2, 16, 32, 6, 0, 0) suite_2();
  MultiplierTestSuite #(3, 32,  8, 3, 0, 0) suite_3();
  MultiplierTestSuite #(4, 32, 16, 4, 3, 0) suite_4();
  MultiplierTestSuite #(5,  8, 32, 9, 0, 3) suite_5();
  MultiplierTestSuite #(6,  8, 16, 5, 3, 3) suite_6();

  int s;

  initial begin
    test_bench_begin( `__FILE__ );
    s = get_test_suite();

    if ((s <= 0) || (s == 1)) suite_1.run_test_suite();
    if ((s <= 0) || (s == 2)) suite_2.run_test_suite();
    if ((s <= 0) || (s == 3)) suite_3.run_test_suite();
    if ((s <= 0) || (s == 4)) suite_4.run_test_suite();
    if ((s <= 0) || (s == 5)) suite_5.run_test_suite();
    if ((s <= 0) || (s == 6)) suite_6.run_test_suite();

    test_bench_end();
  end
endmodule
