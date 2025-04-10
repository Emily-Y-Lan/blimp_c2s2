//========================================================================
// PipelinedMultiplierL2_test.v
//========================================================================
// A testbench for our pipelined multiplier

`include "defs/UArch.v"
`include "hw/execute/execute_units_l2/PipelinedMultiplierL2.v"
`include "test/fl/TestIstream.v"
`include "test/fl/TestOstream.v"

import UArch::*;
import TestEnv::*;

//========================================================================
// PipelinedMultiplierL2TestSuite
//========================================================================
// A test suite for the multiplier

module PipelinedMultiplierL2TestSuite #(
  parameter p_suite_num       = 0,
  parameter p_seq_num_bits    = 5,
  parameter p_pipeline_stages = 1,

  parameter p_D_send_intv_delay = 0,
  parameter p_W_recv_intv_delay = 0
);

  //verilator lint_off UNUSEDSIGNAL
  string suite_name = $sformatf("%0d: PipelinedMultiplierL2TestSuite_%0d_%0d_%0d_%0d", 
                                p_suite_num, p_seq_num_bits, p_pipeline_stages,
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
    .p_seq_num_bits (p_seq_num_bits)
  ) D__X_intf();

  X__WIntf #(
    .p_seq_num_bits (p_seq_num_bits)
  ) X__W_intf();

  PipelinedMultiplierL2 #(
    .p_pipeline_stages (p_pipeline_stages)
  ) dut (
    .D (D__X_intf),
    .W (X__W_intf),
    .*
  );

  //----------------------------------------------------------------------
  // FL D Interface
  //----------------------------------------------------------------------

  typedef struct packed {
    logic               [31:0] pc;
    logic [p_seq_num_bits-1:0] seq_num;
    logic               [31:0] op1;
    logic               [31:0] op2;
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

  assign D__X_intf.preg    = 'x;
  assign D__X_intf.ppreg   = 'x;

  TestIstream #( t_d__x_msg, p_D_send_intv_delay ) D_Istream (
    .msg (d__x_msg),
    .val (D__X_intf.val),
    .rdy (D__X_intf.rdy),
    .*
  );

  t_d__x_msg msg_to_send;

  task send(
    input logic               [31:0] pc,
    input logic [p_seq_num_bits-1:0] seq_num,
    input logic               [31:0] op1,
    input logic               [31:0] op2,
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
    logic               [31:0] pc;
    logic [p_seq_num_bits-1:0] seq_num;
    logic                [4:0] waddr;
    logic               [31:0] wdata;
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
    input logic               [31:0] pc,
    input logic [p_seq_num_bits-1:0] seq_num,
    input logic                [4:0] waddr,
    input logic               [31:0] wdata,
    input logic                      wen
  );
    msg_to_recv.pc      = pc;
    msg_to_recv.seq_num = seq_num;
    msg_to_recv.waddr   = waddr;
    msg_to_recv.wdata   = wdata;
    msg_to_recv.wen     = wen;

    W_Ostream.recv(msg_to_recv);
  endtask

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

  string trace;

  // verilator lint_off BLKSEQ
  always @( posedge clk ) begin
    #2;
    trace = "";

    trace = {trace, D_Istream.trace()};
    trace = {trace, " | "};
    trace = {trace, dut.trace()};
    trace = {trace, " | "};
    trace = {trace, W_Ostream.trace()};

    t.trace( trace );
  end
  // verilator lint_on BLKSEQ

  //----------------------------------------------------------------------
  // Include test cases
  //----------------------------------------------------------------------

  `include "hw/execute/test/test_cases/mul_test_cases.v"

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  task run_test_suite();
    t.test_suite_begin( suite_name );

    run_mul_test_cases();
  endtask

endmodule

//========================================================================
// PipelinedMultiplierL2_test
//========================================================================

module PipelinedMultiplierL2_test;
  PipelinedMultiplierL2TestSuite #(1)             suite_1();
  PipelinedMultiplierL2TestSuite #(2, 6, 1, 0, 0) suite_2();
  PipelinedMultiplierL2TestSuite #(3, 3, 2, 0, 0) suite_3();
  PipelinedMultiplierL2TestSuite #(4, 4, 4, 3, 0) suite_4();
  PipelinedMultiplierL2TestSuite #(5, 9, 8, 0, 3) suite_5();
  PipelinedMultiplierL2TestSuite #(6, 5, 8, 3, 3) suite_6();

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
