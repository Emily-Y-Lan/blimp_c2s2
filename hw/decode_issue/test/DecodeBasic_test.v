//========================================================================
// DecodeBasic_test.v
//========================================================================
// A testbench for our basic decoder

`include "defs/ISA.v"
`include "hw/decode_issue/DecodeIssue.v"
`include "test/TraceUtils.v"
`include "test/fl/F__DTestF.v"
`include "test/fl/D__XTestX.v"

import ISA::*;
import TestEnv::*;

//========================================================================
// DecodeBasicTestSuite
//========================================================================
// A test suite for the basic decoder

module DecodeBasicTestSuite #(
  parameter p_suite_num  = 0,
  parameter p_addr_bits  = 32,
  parameter p_inst_bits  = 32,
  parameter p_rst_addr   = 32'h0,

  parameter p_F_send_intv_delay = 0,
  parameter p_X_recv_intv_delay = 0
);

  // verilator lint_off UNUSEDSIGNAL
  string suite_name = $sformatf("%0d: DecodeBasicTestSuite_%0d_%0d_%0d_%0d_%0d", 
                                p_suite_num, p_addr_bits, 
                                p_inst_bits, p_rst_addr,
                                p_F_send_intv_delay, p_X_recv_intv_delay);
  // verilator lint_on UNUSEDSIGNAL

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk, rst;
  TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------
  // Here, we use three pipes for testing

  F__DIntf #(
    .p_addr_bits (p_addr_bits),
    .p_inst_bits (p_inst_bits)
  ) F__D_intf;

  D__XIntf #(
    .p_addr_bits (p_addr_bits),
    .p_data_bits (p_inst_bits)
  ) Ex_intf [2:0]();

  DecodeIssue #(
    .p_decode_issue_type ("basic_tinyrv1"),
    .p_num_pipes         (3),
    .p_pipe_subsets      ({p_tinyrv1, OP_LW_VEC | OP_SW_VEC, p_tinyrv1})
  ) dut (
    .F  (F__D_intf),
    .Ex (Ex_intf),
    .*
  );

  F__DTestF #(
    .p_send_intv_delay (p_F_send_intv_delay),
    .p_rst_addr        (p_rst_addr)
  ) fl_F_test_intf (
    .dut (F__D_intf),
    .*
  );

  D__XTestX #(
    .p_dut_intv_delay (p_X_recv_intv_delay)
  ) fl_X_test_intf_1 (
    .dut (Ex_intf[0]),
    .*
  );

  D__XTestX #(
    .p_dut_intv_delay (p_X_recv_intv_delay)
  ) fl_X_test_intf_2 (
    .dut (Ex_intf[1]),
    .*
  );

  D__XTestX #(
    .p_dut_intv_delay (p_X_recv_intv_delay)
  ) fl_X_test_intf_3 (
    .dut (Ex_intf[2]),
    .*
  );

  Tracer tracer ( clk, {
    fl_F_test_intf.trace,
    " | ",
    dut.trace,
    " | ",
    fl_X_test_intf_1.trace,
    fl_X_test_intf_2.trace,
    fl_X_test_intf_3.trace
  });

  function logic done;
    return fl_X_test_intf_1.done() && fl_X_test_intf_2.done() && fl_X_test_intf_3.done();
  endfunction

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );
    if( t.n != 0 )
      tracer.enable_trace();

    //                       addr                      inst
    fl_F_test_intf.add_inst( p_addr_bits'(p_rst_addr + 0), "mul x1, x0, x0" );
    fl_F_test_intf.add_inst( p_addr_bits'(p_rst_addr + 4), "addi x1, x0, 10" );

    // Pipe 1                 pc                        op1    op2    uop     sq br_tar
    fl_X_test_intf_1.add_msg( p_addr_bits'(p_rst_addr + 0), 32'h0, 32'h0, OP_MUL, 0, 'x );
    fl_X_test_intf_1.add_msg( p_addr_bits'(p_rst_addr + 4), 32'h0, 32'hA, OP_ADD, 0, 'x );

    while( !done() ) begin
      #10;
    end
    tracer.disable_trace();
  endtask

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  task run_test_suite();
    t.test_suite_begin( suite_name );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();

  endtask
endmodule

//========================================================================
// DecodeBasic_test
//========================================================================

module DecodeBasic_test;
  DecodeBasicTestSuite #(1) suite_1;

  int s;

  initial begin
    test_bench_begin( `__FILE__ );
    s = get_test_suite();

    if ((s <= 0) || (s == 1)) suite_1.run_test_suite();

    test_bench_end();
  end
endmodule
