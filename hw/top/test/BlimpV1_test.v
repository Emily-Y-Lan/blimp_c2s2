//========================================================================
// BlimpV1_test.v
//========================================================================
// The top-level testing module for a basic implementation of Blimp

`include "asm/assemble.v"
`include "hw/top/BlimpV1.v"
`include "intf/MemIntf.v"
`include "intf/InstTraceNotif.v"
`include "test/fl/MemIntfTestServer.v"
`include "test/fl/InstTraceSub.v"
`include "fl/fl_vtrace.v"

import TestEnv::*;

//========================================================================
// BlimpV1TestSuite
//========================================================================
// A test suite for a particular parametrization of the basic Blimp unit

module BlimpV1TestSuite #(
  parameter p_suite_num    = 0,
  parameter p_opaq_bits    = 8,
  parameter p_seq_num_bits = 5,

  parameter p_mem_send_intv_delay = 1,
  parameter p_mem_recv_intv_delay = 1
);

  string suite_name = $sformatf("%0d: BlimpV1TestSuite_%0d_%0d_%0d_%0d", 
                                p_suite_num,
                                p_opaq_bits, p_seq_num_bits,
                                p_mem_send_intv_delay, p_mem_recv_intv_delay);

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

  MemIntf #(
    .t_req_msg  (`MEM_REQ ( p_opaq_bits )),
    .t_resp_msg (`MEM_RESP( p_opaq_bits ))
  ) mem_intf();

  InstTraceNotif inst_trace_notif();

  BlimpV1 #(
    .p_opaq_bits    (p_opaq_bits),
    .p_seq_num_bits (p_seq_num_bits)
  ) dut (
    .inst_mem   (mem_intf),
    .inst_trace (inst_trace_notif),
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

  logic [31:0] asm_binary;
  
  task asm(
    input logic [31:0] addr,
    input string       inst
  );
    asm_binary = assemble( inst, addr );
    fl_mem.init_mem( addr, asm_binary );
    fl_init        ( addr, asm_binary );
  endtask

  //----------------------------------------------------------------------
  // Instruction Tracing
  //----------------------------------------------------------------------

  InstTraceSub inst_trace_sub (
    .pc    (inst_trace_notif.pc),
    .waddr (inst_trace_notif.waddr),
    .wdata (inst_trace_notif.wdata),
    .wen   (inst_trace_notif.wen),
    .val   (inst_trace_notif.val),
    .*
  );

  task check_trace(
    input logic [31:0] pc,
    input logic  [4:0] waddr,
    input logic [31:0] wdata,
    input logic        wen
  );

    inst_trace_sub.check_trace(
      pc,
      waddr,
      wdata,
      wen
    );
  endtask

  logic      check_traces_success;
  inst_trace check_traces_fl_trace;

  task check_traces();
    while( 1 ) begin
      check_traces_success = fl_trace( check_traces_fl_trace );
      if( !check_traces_success ) return;
      
      inst_trace_sub.check_trace(
        check_traces_fl_trace.pc,
        check_traces_fl_trace.waddr,
        check_traces_fl_trace.wdata,
        check_traces_fl_trace.wen
      );
    end
  endtask

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

  string trace;

  // verilator lint_off BLKSEQ
  always_ff @( posedge clk ) begin
    #2;
    trace = "";

    trace = {trace, fl_mem.trace()};
    trace = {trace, " || "};
    trace = {trace, dut.trace()};
    trace = {trace, " || "};
    trace = {trace, inst_trace_sub.trace()};

    t.trace( trace );
  end
  // verilator lint_on BLKSEQ

  //----------------------------------------------------------------------
  // Include Tests
  //----------------------------------------------------------------------

  `include "hw/top/test/test_cases/directed/add_test_cases.v"
  `include "hw/top/test/test_cases/directed/mul_test_cases.v"

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  task run_test_suite();
    t.test_suite_begin( suite_name );

    run_add_tests();
    run_mul_tests();

  endtask
endmodule

//========================================================================
// BlimpV1_test
//========================================================================

module BlimpV1_test;
  BlimpV1TestSuite #(1)             suite_1();
  BlimpV1TestSuite #(2, 8, 5, 1, 1) suite_2();
  BlimpV1TestSuite #(3, 8, 5, 1, 1) suite_3();
  BlimpV1TestSuite #(4, 4, 5, 1, 1) suite_4();
  BlimpV1TestSuite #(4, 4, 3, 1, 1) suite_5();
  BlimpV1TestSuite #(5,32, 4, 3, 1) suite_6();
  BlimpV1TestSuite #(6, 2, 2, 1, 3) suite_7();
  BlimpV1TestSuite #(7, 4, 6, 3, 3) suite_8();

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
    if ((s <= 0) || (s == 7)) suite_7.run_test_suite();
    if ((s <= 0) || (s == 8)) suite_8.run_test_suite();

    test_bench_end();
  end
endmodule
