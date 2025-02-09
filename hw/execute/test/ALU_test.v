//========================================================================
// ALU_test.v
//========================================================================
// A testbench for our ALU

`include "defs/UArch.v"
`include "hw/execute/execute_variants/ALU.v"
`include "test/TraceUtils.v"
`include "test/fl/TestIstream.v"
`include "test/fl/TestOstream.v"

import UArch::*;
import TestEnv::*;

//========================================================================
// ALUTestSuite
//========================================================================
// A test suite for the ALU

module ALUTestSuite #(
  parameter p_suite_num    = 0,
  parameter p_addr_bits    = 32,
  parameter p_data_bits    = 32,
  parameter p_seq_num_bits = 5,

  parameter p_D_send_intv_delay = 0,
  parameter p_W_recv_intv_delay = 0
);

  //verilator lint_off UNUSEDSIGNAL
  string suite_name = $sformatf("%0d: ALUTestSuite_%0d_%0d_%0d_%0d", 
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

  ALU #(
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
      send('0, 0,      1,  2,  5'h1, OP_ADD);

      //   pc  seq_num waddr wdata wen
      recv('0, 0,      5'h1, 3,    1);
    join

    tracer.disable_trace();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_add
  //----------------------------------------------------------------------

  task test_case_2_add();
    t.test_case_begin( "test_case_2_add" );
    if( t.n != 0 )
      tracer.enable_trace();

    fork
      begin
        //   pc  seq_num op1 op2 waddr uop
        send('0, 1,      4,  3,  5'h1, OP_ADD);
        send('1, 2,     -1,  1,  5'h4, OP_ADD);
        send('0, 3,      4, -6,  5'h2, OP_ADD);
        send('1, 4,      2,  0,  5'h5, OP_ADD);
        send('0, 5,      0, -7,  5'h3, OP_ADD);
      end

      begin
        //   pc  seq_num waddr wdata wen
        recv('0, 1,      5'h1,  7,   1);
        recv('1, 2,      5'h4,  0,   1);
        recv('0, 3,      5'h2, -2,   1);
        recv('1, 4,      5'h5,  2,   1);
        recv('0, 5,      5'h3, -7,   1);
      end
    join

    tracer.disable_trace();
  endtask

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  task run_test_suite();
    t.test_suite_begin( suite_name );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_add();

  endtask

endmodule

//========================================================================
// ALU_test
//========================================================================

module ALU_test;
  ALUTestSuite #(1)                  suite_1();
  ALUTestSuite #(2, 16, 32, 6, 0, 0) suite_2();
  ALUTestSuite #(3, 32,  8, 3, 0, 0) suite_3();
  ALUTestSuite #(4, 32, 16, 4, 3, 0) suite_4();
  ALUTestSuite #(5,  8, 32, 9, 0, 3) suite_5();
  ALUTestSuite #(6,  8, 16, 5, 3, 3) suite_6();

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
