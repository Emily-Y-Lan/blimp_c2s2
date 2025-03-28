//========================================================================
// FLProcTestHarness.v
//========================================================================
// A testing harness to run directed tests on the functional-level
// processor

`ifndef HW_TOP_TEST_FLPROCTESTHARNESS_V
`define HW_TOP_TEST_FLPROCTESTHARNESS_V

`include "asm/assemble.v"
`include "fl/fl_vtrace.v"
`include "test/TestUtils.v"

import TestEnv::*;

module FLProcTestHarness;
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

  task data(
    input logic [31:0] addr,
    input logic [31:0] data
  );
    fl_init( addr, data );
  endtask

  logic      dut_success;
  inst_trace dut_trace;
  string     trace;

  task check_trace(
    input logic [31:0] pc,
    input logic  [4:0] waddr,
    input logic [31:0] wdata,
    input logic        wen
  );
    dut_success = fl_trace( dut_trace );

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Linetracing
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Add a check for verbosity; test utilities will only display if
    // verbose, but we want to avoid string processing if possible for
    // speed

    if( t.verbose ) begin
      trace = $sformatf("(%b) ", dut_success);
      trace = {trace, fl_trace_str( dut_trace )};
      t.trace( trace );
    end

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Check trace
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

  `include "hw/top/test/test_cases/directed/addi_test_cases.v"
  `include "hw/top/test/test_cases/directed/add_test_cases.v"
  `include "hw/top/test/test_cases/directed/mul_test_cases.v"
  `include "hw/top/test/test_cases/directed/lw_test_cases.v"
  `include "hw/top/test/test_cases/directed/sw_test_cases.v"
  `include "hw/top/test/test_cases/directed/jal_test_cases.v"
  `include "hw/top/test/test_cases/directed/jalr_test_cases.v"
  `include "hw/top/test/test_cases/directed/bne_test_cases.v"

  `include "hw/top/test/test_cases/directed/sub_test_cases.v"
  `include "hw/top/test/test_cases/directed/and_test_cases.v"
  `include "hw/top/test/test_cases/directed/or_test_cases.v"
  `include "hw/top/test/test_cases/directed/xor_test_cases.v"
  `include "hw/top/test/test_cases/directed/slt_test_cases.v"
  `include "hw/top/test/test_cases/directed/sltu_test_cases.v"
  `include "hw/top/test/test_cases/directed/sra_test_cases.v"
  `include "hw/top/test/test_cases/directed/srl_test_cases.v"
  `include "hw/top/test/test_cases/directed/sll_test_cases.v"

  `include "hw/top/test/test_cases/directed/andi_test_cases.v"
  `include "hw/top/test/test_cases/directed/ori_test_cases.v"
  `include "hw/top/test/test_cases/directed/xori_test_cases.v"
  `include "hw/top/test/test_cases/directed/slti_test_cases.v"
  `include "hw/top/test/test_cases/directed/sltiu_test_cases.v"
  `include "hw/top/test/test_cases/directed/srai_test_cases.v"
  `include "hw/top/test/test_cases/directed/srli_test_cases.v"
  `include "hw/top/test/test_cases/directed/slli_test_cases.v"
  `include "hw/top/test/test_cases/directed/lui_test_cases.v"
  `include "hw/top/test/test_cases/directed/auipc_test_cases.v"

  `include "hw/top/test/test_cases/directed/beq_test_cases.v"
  `include "hw/top/test/test_cases/directed/blt_test_cases.v"
  `include "hw/top/test/test_cases/directed/bge_test_cases.v"
  `include "hw/top/test/test_cases/directed/bltu_test_cases.v"
  `include "hw/top/test/test_cases/directed/bgeu_test_cases.v"

  //----------------------------------------------------------------------
  // Run tests
  //----------------------------------------------------------------------

  initial begin
    test_bench_begin( `__FILE__ );

    t.test_suite_begin( "FLProc_test" );
    run_instruction_tests();

    test_bench_end();
  end
endmodule

`endif // HW_TOP_TEST_FLPROCTESTHARNESS_V
