//========================================================================
// BlimpV5_test.v
//========================================================================
// The top-level testing module for Blimp V5

`include "asm/assemble.v"
`include "hw/top/BlimpV5.v"
`include "intf/MemIntf.v"
`include "intf/InstTraceNotif.v"
`include "test/fl/MemIntfTestServer_2Port.v"
`include "test/fl/InstTraceSub.v"
`include "fl/fl_vtrace.v"

import TestEnv::*;

//========================================================================
// BlimpV5TestSuite
//========================================================================
// A test suite for a particular parametrization of the Blimp V5 module

module BlimpV5TestSuite #(
  parameter p_suite_num     = 0,
  parameter p_opaq_bits     = 8,
  parameter p_seq_num_bits  = 5,
  parameter p_num_phys_regs = 36,

  parameter p_mem_send_intv_delay = 1,
  parameter p_mem_recv_intv_delay = 1
);

  string suite_name = $sformatf("%0d: BlimpV5TestSuite_%0d_%0d_%0d_%0d", 
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
  ) mem_intf[2]();

  InstTraceNotif inst_trace_notif();

  BlimpV5 #(
    .p_opaq_bits     (p_opaq_bits),
    .p_seq_num_bits  (p_seq_num_bits),
    .p_num_phys_regs (p_num_phys_regs)
  ) dut (
    .inst_mem   (mem_intf[0]),
    .data_mem   (mem_intf[1]),
    .inst_trace (inst_trace_notif),
    .*
  );

  //----------------------------------------------------------------------
  // FL Memory
  //----------------------------------------------------------------------

  MemIntfTestServer_2Port #(
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

  task data(
    input logic [31:0] addr,
    input logic [31:0] data
  );
    fl_mem.init_mem( addr, data );
    fl_init        ( addr, data );
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

  `include "hw/top/test/test_cases/directed/addi_test_cases.v"
  `include "hw/top/test/test_cases/directed/add_test_cases.v"
  `include "hw/top/test/test_cases/directed/mul_test_cases.v"
  `include "hw/top/test/test_cases/directed/lw_test_cases.v"
  `include "hw/top/test/test_cases/directed/sw_test_cases.v"
  `include "hw/top/test/test_cases/directed/jal_test_cases.v"
  `include "hw/top/test/test_cases/directed/jalr_test_cases.v"

  `include "hw/top/test/test_cases/golden/addi_test_cases.v"
  `include "hw/top/test/test_cases/golden/add_test_cases.v"
  `include "hw/top/test/test_cases/golden/mul_test_cases.v"
  `include "hw/top/test/test_cases/golden/lw_test_cases.v"
  `include "hw/top/test/test_cases/golden/sw_test_cases.v"

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  task run_test_suite();
    t.test_suite_begin( suite_name );

    run_directed_addi_tests();
    run_directed_add_tests();
    run_directed_mul_tests();
    run_directed_lw_tests();
    run_directed_sw_tests();
    run_directed_jal_tests();
    run_directed_jalr_tests();

    run_golden_addi_tests();
    run_golden_add_tests();
    run_golden_mul_tests();
    run_golden_lw_tests();
    run_golden_sw_tests();

  endtask
endmodule

//========================================================================
// BlimpV5_test
//========================================================================

module BlimpV5_test;
  BlimpV5TestSuite #(1)                  suite_1();
  BlimpV5TestSuite #(2,  8, 5, 36, 1, 1) suite_2();
  BlimpV5TestSuite #(3,  8, 5, 50, 1, 1) suite_3();
  BlimpV5TestSuite #(4,  4, 5, 48, 1, 1) suite_4();
  BlimpV5TestSuite #(4,  4, 3, 33, 1, 1) suite_5();
  BlimpV5TestSuite #(5, 32, 4, 48, 3, 1) suite_6();
  BlimpV5TestSuite #(6,  2, 2, 64, 1, 3) suite_7();
  BlimpV5TestSuite #(7,  4, 6, 52, 3, 3) suite_8();

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
