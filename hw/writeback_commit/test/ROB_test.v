//========================================================================
// ROB_test.v
//========================================================================
// A testbench for our basic writeback-commit unit

`include "hw/writeback_commit/rob/ROB.v"
`include "test/fl/TestIstream.v"
`include "test/fl/TestOstream.v"
`include "test/TestUtils.v"

import TestEnv::*;

//========================================================================
// ROBTestSuite
//========================================================================
// A test suite for the ROB

module ROBTestSuite #(
  parameter p_suite_num      = 0,
  parameter type t_entry     = logic [31:0],
  parameter p_depth          = 4,
  parameter type t_depth_arr = logic [p_depth-1:0],
  parameter type t_addr      = logic [$clog2(p_depth)-1:0],
  parameter p_ins_send_intv_delay = 0
);

  //verilator lint_off UNUSEDSIGNAL
  string suite_name = $sformatf("%0d: ROBTestSuite_%0d_%0d", 
                                p_suite_num, 32, p_depth);
  //verilator lint_on UNUSEDSIGNAL

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk, rst;
  TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  OpDeqFrontIntf #(
    .t_entry     (t_entry)
  ) deq_front_intf();

  OpInsIntf #(
    .t_entry     (t_entry),
    .t_addr      (t_addr)
  ) ins_intf();

  rob_ROB #(
    .t_entry     (t_entry),
    .p_depth     (p_depth),
    .t_depth_arr (t_depth_arr),
    .t_addr      (t_addr)
  ) dut (
    .clk            (clk),
    .rst            (rst),
    .deq_front_intf (deq_front_intf),
    .ins_intf       (ins_intf),
    .*
  );

  //----------------------------------------------------------------------
  // FL Istreams
  //----------------------------------------------------------------------

  typedef struct packed {
    t_entry ins_data;
    t_addr  ins_tag;
  } t_ins_msg;

  t_ins_msg ins_msg;

  assign ins_intf.ins_data = ins_msg.ins_data;
  assign ins_intf.ins_tag  = ins_msg.ins_tag;

  TestIstream #(t_ins_msg, p_ins_send_intv_delay) ins_stream (
    .msg(ins_msg),
    .val(ins_intf.ins_en),
    .rdy(ins_intf.ins_cpl),
    .*
  );

  t_ins_msg msg_to_send;

  task send(
    t_entry ins_data,
    t_addr  ins_tag
  );
    msg_to_send.ins_data = ins_data;
    msg_to_send.ins_tag  = ins_tag;

    ins_stream.send(msg_to_send);
  endtask

  //----------------------------------------------------------------------
  // FL Ostreams
  //----------------------------------------------------------------------

  logic unused_deq_front_en;  

  TestOstream #(t_entry) deq_front_stream (
    .msg(deq_front_intf.deq_front_data),
    .val(deq_front_intf.deq_front_cpl),
    .rdy(unused_deq_front_en),
    .*
  );

  t_entry msg_to_recv;

  task recv(
    input t_entry deq_front_data
  );
    msg_to_recv = deq_front_data;

    deq_front_stream.recv(msg_to_recv);
  endtask

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

  string trace;

  // verilator lint_off BLKSEQ
  always_ff @( posedge clk ) begin
    #2;
    trace = "";

    trace = {trace, ins_stream.trace()};
    trace = {trace, " | "};
    trace = {trace, dut.trace()};
    trace = {trace, " | "};
    trace = {trace, deq_front_stream.trace()};

    t.trace( trace );
  end
  // verilator lint_on BLKSEQ

  //----------------------------------------------------------------------
  // Include test cases
  //----------------------------------------------------------------------

  `include "hw/writeback_commit/test/test_cases/rob_test_cases.v"

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  task run_test_suite();
    t.test_suite_begin( suite_name );

    run_rob_test_cases();
  endtask


endmodule

//========================================================================
// ROB_test
//========================================================================

module ROB_test;
  ROBTestSuite #(1) suite_1();

  int s;

  initial begin
    test_bench_begin( `__FILE__ );
    s = get_test_suite();

    if ((s <= 0) || (s == 1)) suite_1.run_test_suite();

    test_bench_end();
  end
endmodule
