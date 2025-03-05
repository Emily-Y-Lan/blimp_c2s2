//========================================================================
// FLProc_test.v
//========================================================================
// A testing module to run directed tests on the functional-level
// processor

`include "asm/assemble.v"
`include "fl/fl_vtrace.v"
`include "test/TestUtils.v"

import TestEnv::*;

module FLProc_test;
  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  // verilator lint_off UNUSEDSIGNAL
  logic clk, rst;
  // verilator lint_on UNUSEDSIGNAL
  TestUtils t( .* );

  //----------------------------------------------------------------------
  // Testing tasks
  //----------------------------------------------------------------------

  task asm(
    input logic [31:0] addr,
    input string       inst
  );
    fl_init( addr, assemble( inst, addr ) );
  endtask

  logic      dut_success;
  inst_trace dut_trace;

  task check_trace(
    input logic [31:0] pc,
    input logic  [4:0] waddr,
    input logic [31:0] wdata,
    input logic        wen
  );
    dut_success = fl_trace( dut_trace );
    if( !dut_success ) begin
      // Invalid trace - force a failure
      `CHECK_EQ( 1'b1, 1'b0 );
    end

    `CHECK_EQ( dut_trace.pc,  pc  );
    `CHECK_EQ( dut_trace.wen, wen );

    if( wen ) begin
      `CHECK_EQ( dut_trace.waddr, waddr );
      `CHECK_EQ( dut_trace.wdata, wdata );
    end
  endtask

  //----------------------------------------------------------------------
  // Include test cases
  //----------------------------------------------------------------------

  `include "hw/top/test/test_cases/directed/add_test_cases.v"
  `include "hw/top/test/test_cases/directed/mul_test_cases.v"

  //----------------------------------------------------------------------
  // run_tests
  //----------------------------------------------------------------------

  task run_tests();
    test_bench_begin( `__FILE__ );

    t.test_suite_begin( "FLProc_test" );
    run_add_tests();
    run_mul_tests();

    test_bench_end();
  endtask

  initial begin
    run_tests();
  end
endmodule
