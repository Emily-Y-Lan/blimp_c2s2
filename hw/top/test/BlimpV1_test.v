//========================================================================
// BlimpV1_test.v
//========================================================================
// The top-level testing module for a basic implementation of Blimp

`include "hw/top/BlimpV1.v"
`include "intf/MemIntf.v"
`include "intf/InstTraceNotif.v"
`include "test/asm/rv32/assemble32.v"
`include "test/fl/MemIntfTestServer.v"
`include "test/fl/InstTraceSub.v"

import TestEnv::*;

//========================================================================
// BlimpV1TestSuite
//========================================================================
// A test suite for a particular parametrization of the basic Blimp unit

module BlimpV1TestSuite #(
  parameter p_suite_num   = 0,
  parameter p_rst_addr    = 32'b0,
  parameter p_addr_bits   = 32,
  parameter p_opaq_bits   = 8,
  parameter p_rob_entries = 32,

  parameter p_mem_send_intv_delay = 1,
  parameter p_mem_recv_intv_delay = 1
);

  string suite_name = $sformatf("%0d: BlimpV1TestSuite_%0p_%0d_%0d_%0d_%0d", 
                                p_suite_num, p_rst_addr, p_addr_bits,
                                p_opaq_bits,
                                p_mem_send_intv_delay, p_mem_recv_intv_delay);

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk, rst;
  TestUtils t( .* );

  `MEM_REQ_DEFINE ( 32, p_addr_bits, p_opaq_bits );
  `MEM_RESP_DEFINE( 32, p_addr_bits, p_opaq_bits );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  MemIntf #(
    .t_req_msg  (`MEM_REQ ( 32, p_addr_bits, p_opaq_bits )),
    .t_resp_msg (`MEM_RESP( 32, p_addr_bits, p_opaq_bits ))
  ) mem_intf();

  InstTraceNotif #(
    .p_addr_bits (p_addr_bits),
    .p_data_bits (32)
  ) inst_trace_notif();

  BlimpV1 #(
    .p_rst_addr    (p_rst_addr),
    .p_opaq_bits   (p_opaq_bits),
    .p_rob_entries (p_rob_entries)
  ) dut (
    .inst_mem   (mem_intf),
    .inst_trace (inst_trace_notif),
    .*
  );

  //----------------------------------------------------------------------
  // FL Memory
  //----------------------------------------------------------------------

  MemIntfTestServer #(
    .t_req_msg         (`MEM_REQ ( 32, p_addr_bits, p_opaq_bits )),
    .t_resp_msg        (`MEM_RESP( 32, p_addr_bits, p_opaq_bits )),
    .p_send_intv_delay (p_mem_send_intv_delay),
    .p_recv_intv_delay (p_mem_recv_intv_delay),
    .p_addr_bits       (p_addr_bits),
    .p_data_bits       (32),
    .p_opaq_bits       (p_opaq_bits)
  ) fl_mem (
    .dut (mem_intf),
    .*
  );

  task asm(
    input logic [p_addr_bits-1:0] addr,
    input string                  inst
  );
    fl_mem.init_mem( p_addr_bits'(p_rst_addr) + addr, assemble32( inst ) );
  endtask

  //----------------------------------------------------------------------
  // Instruction Tracing
  //----------------------------------------------------------------------

  InstTraceSub #(
    .p_addr_bits (p_addr_bits),
    .p_data_bits (32)
  ) inst_trace_sub (
    .pc    (inst_trace_notif.pc),
    .waddr (inst_trace_notif.waddr),
    .wdata (inst_trace_notif.wdata),
    .wen   (inst_trace_notif.wen),
    .val   (inst_trace_notif.val),
    .*
  );

  task check_trace(
    input logic    [p_addr_bits-1:0] pc,
    input logic                [4:0] waddr,
    input logic               [31:0] wdata,
    input logic                      wen
  );

    inst_trace_sub.check_trace(
      p_addr_bits'(p_rst_addr) + pc,
      waddr,
      wdata,
      wen
    );
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

  `include "hw/top/test/test_cases/add_test_cases.v"
  `include "hw/top/test/test_cases/mul_test_cases.v"

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
  BlimpV1TestSuite #(1)                                        suite_1();
  BlimpV1TestSuite #(2, 'h800, 32,  8, 32, 1, 1)               suite_2();
  BlimpV1TestSuite #(3, 'h000, 16,  8, 32, 1, 1)               suite_3();
  BlimpV1TestSuite #(4, 'h000, 32,  4, 32, 1, 1)               suite_4();
  BlimpV1TestSuite #(4, 'h000, 32,  4,  8, 1, 1)               suite_5();
  BlimpV1TestSuite #(5, 'h400,  8, 32, 16, 3, 1)               suite_6();
  BlimpV1TestSuite #(6, 'h200, 64,  2,  4, 1, 3)               suite_7();
  BlimpV1TestSuite #(7, 'h100, 16,  4, 64, 3, 3)               suite_8();

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
