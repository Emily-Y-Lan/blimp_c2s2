//========================================================================
// LoadStoreUnit_test.v
//========================================================================
// A testbench for our basic load-store unit

`include "defs/UArch.v"
`include "hw/execute/execute_units_l3/LoadStoreUnit.v"
`include "test/fl/MemIntfTestServer.v"
`include "test/fl/TestIstream.v"
`include "test/fl/TestOstream.v"

import UArch::*;
import TestEnv::*;

//========================================================================
// LoadStoreUnitTestSuite
//========================================================================
// A test suite for the multiplier

module LoadStoreUnitTestSuite #(
  parameter p_suite_num       = 0,
  parameter p_seq_num_bits    = 5,
  parameter p_opaq_bits       = 8,

  parameter p_D_send_intv_delay = 0,
  parameter p_W_recv_intv_delay = 0,
  parameter p_mem_send_intv_delay = 1,
  parameter p_mem_recv_intv_delay = 1
);

  //verilator lint_off UNUSEDSIGNAL
  string suite_name = $sformatf("%0d: LoadStoreUnitTestSuite_%0d_%0d_%0d_%0d", 
                                p_suite_num, p_seq_num_bits, p_opaq_bits,
                                p_D_send_intv_delay, p_W_recv_intv_delay);
  //verilator lint_on UNUSEDSIGNAL

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk, rst;
  TestUtils t( .* );

  `MEM_REQ_DEFINE ( p_opaq_bits );
  `MEM_RESP_DEFINE( p_opaq_bits );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  D__XIntf #(
    .p_seq_num_bits (p_seq_num_bits)
  ) D__X_intf();

  X__WIntf #(
    .p_seq_num_bits (p_seq_num_bits)
  ) X__W_intf();

  MemIntf #(
    .t_req_msg  (`MEM_REQ ( p_opaq_bits )),
    .t_resp_msg (`MEM_RESP( p_opaq_bits ))
  ) mem_intf();

  LoadStoreUnit #(
    .p_opaq_bits (p_opaq_bits)
  ) dut (
    .D   (D__X_intf),
    .W   (X__W_intf),
    .mem (mem_intf),
    .*
  );

  //----------------------------------------------------------------------
  // FL Memory
  //----------------------------------------------------------------------

  MemIntfTestServer #(
    .t_req_msg         (`MEM_REQ ( p_opaq_bits )),
    .t_resp_msg        (`MEM_RESP( p_opaq_bits )),
    .p_send_intv_delay (p_mem_send_intv_delay),
    .p_recv_intv_delay (p_mem_recv_intv_delay),
    .p_opaq_bits       (p_opaq_bits)
  ) fl_mem (
    .dut (mem_intf),
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
    logic               [31:0] mem_data;
  } t_d__x_msg;

  t_d__x_msg d__x_msg;

  assign D__X_intf.pc       = d__x_msg.pc;
  assign D__X_intf.seq_num  = d__x_msg.seq_num;
  assign D__X_intf.op1      = d__x_msg.op1;
  assign D__X_intf.op2      = d__x_msg.op2;
  assign D__X_intf.waddr    = d__x_msg.waddr;
  assign D__X_intf.uop      = d__x_msg.uop;
  assign D__X_intf.mem_data = d__x_msg.mem_data;

  assign D__X_intf.preg    = 'x;
  assign D__X_intf.ppreg   = 'x;

  TestIstream #( t_d__x_msg, p_D_send_intv_delay ) D_Istream (
    .msg (d__x_msg),
    .val (D__X_intf.val),
    .rdy (D__X_intf.rdy),
    .*
  );

  t_d__x_msg msg_to_send;

  task send_mem(
    input logic               [31:0] pc,
    input logic [p_seq_num_bits-1:0] seq_num,
    input logic               [31:0] op1,
    input logic               [31:0] op2,
    input logic                [4:0] waddr,
    input rv_uop                     uop,
    input logic               [31:0] mem_data
  );
    msg_to_send.pc       = pc;
    msg_to_send.seq_num  = seq_num;
    msg_to_send.op1      = op1;
    msg_to_send.op2      = op2;
    msg_to_send.waddr    = waddr;
    msg_to_send.uop      = uop;
    msg_to_send.mem_data = mem_data;

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
  assign x__w_msg.waddr   = ( X__W_intf.wen ) ? X__W_intf.waddr : '0;
  assign x__w_msg.wdata   = ( X__W_intf.wen ) ? X__W_intf.wdata : '0;
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
  always_ff @( posedge clk ) begin
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

  `include "hw/execute/test/test_cases/lw_test_cases.v"
  `include "hw/execute/test/test_cases/sw_test_cases.v"

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  task run_test_suite();
    t.test_suite_begin( suite_name );

    run_lw_test_cases();
    run_sw_test_cases();
  endtask

endmodule

//========================================================================
// LoadStoreUnit_test
//========================================================================

module LoadStoreUnit_test;
  LoadStoreUnitTestSuite #(1)                    suite_1();
  LoadStoreUnitTestSuite #(2, 6,  8, 0, 0, 1, 1) suite_2();
  LoadStoreUnitTestSuite #(3, 3, 16, 0, 0, 1, 1) suite_3();
  LoadStoreUnitTestSuite #(4, 4,  4, 3, 0, 1, 1) suite_4();
  LoadStoreUnitTestSuite #(5, 9,  2, 0, 3, 1, 1) suite_5();
  LoadStoreUnitTestSuite #(6, 5,  1, 3, 3, 3, 3) suite_6();

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
