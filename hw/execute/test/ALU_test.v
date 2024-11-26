//========================================================================
// ALU_test.v
//========================================================================
// A testbench for our ALU

`include "defs/UArch.v"
`include "hw/execute/Execute.v"
`include "test/TraceUtils.v"
`include "test/fl/D__XTestD.v"
`include "test/fl/X__WTestW.v"

import UArch::*;
import TestEnv::*;

//========================================================================
// ALUTestSuite
//========================================================================
// A test suite for the alu

module ALUTestSuite #(
  parameter p_suite_num  = 0,
  parameter p_addr_bits  = 32,
  parameter p_data_bits  = 32,

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
    .p_addr_bits (p_addr_bits),
    .p_data_bits (p_data_bits)
  ) D__X_intf();

  X__WIntf #(
    .p_data_bits (p_data_bits)
  ) X__W_intf();

  Execute #(
    .p_execute_type ("alu")
  ) dut (
    .D (D__X_intf),
    .W (X__W_intf),
    .*
  );

  D__XTestD #(
    .p_send_intv_delay (p_D_send_intv_delay)
  ) fl_D_test_intf (
    .dut (D__X_intf),
    .*
  );

  X__WTestW #(
    .p_dut_intv_delay (p_W_recv_intv_delay)
  ) fl_W_test_intf (
    .dut (X__W_intf),
    .*
  );

  Tracer tracer ( clk, {
    fl_D_test_intf.trace,
    " | ",
    dut.trace,
    " | ",
    fl_W_test_intf.trace
  } );

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );
    if( t.n != 0 )
      tracer.enable_trace();

    //                      pc  op1                op2                waddr uop
    fl_D_test_intf.add_msg( 'x, p_data_bits'('d1), p_data_bits'('d2), 5'h1, OP_ADD  );

    //                      waddr wdata              wen
    fl_W_test_intf.add_msg( 5'h1, p_data_bits'('d3), 1 );

    while( !fl_W_test_intf.done() ) begin
      #10;
    end
    tracer.disable_trace();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_add
  //----------------------------------------------------------------------

  task test_case_2_add();
    t.test_case_begin( "test_case_2_add" );
    if( t.n != 0 )
      tracer.enable_trace();

    //                      pc  op1              op2              waddr uop
    fl_D_test_intf.add_msg( 'x, p_data_bits'( 4), p_data_bits'( 3), 5'h1, OP_ADD  );
    fl_D_test_intf.add_msg( 'x, p_data_bits'(-1), p_data_bits'( 1), 5'h4, OP_ADD  );
    fl_D_test_intf.add_msg( 'x, p_data_bits'( 4), p_data_bits'(-6), 5'h2, OP_ADD  );
    fl_D_test_intf.add_msg( 'x, p_data_bits'( 2), p_data_bits'( 0), 5'h5, OP_ADD  );
    fl_D_test_intf.add_msg( 'x, p_data_bits'( 0), p_data_bits'(-7), 5'h3, OP_ADD  );

    //                      waddr wdata            wen
    fl_W_test_intf.add_msg( 5'h1, p_data_bits'( 7), 1 );
    fl_W_test_intf.add_msg( 5'h4, p_data_bits'( 0), 1 );
    fl_W_test_intf.add_msg( 5'h2, p_data_bits'(-2), 1 );
    fl_W_test_intf.add_msg( 5'h5, p_data_bits'( 2), 1 );
    fl_W_test_intf.add_msg( 5'h3, p_data_bits'(-7), 1 );

    while( !fl_W_test_intf.done() ) begin
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
    if ((t.n <= 0) || (t.n == 2)) test_case_2_add();

  endtask

endmodule

//========================================================================
// ALU_test
//========================================================================

module ALU_test;
  ALUTestSuite #(1)               suite_1();
  ALUTestSuite #(2, 16, 32, 0, 0) suite_2();
  ALUTestSuite #(3, 32,  8, 0, 0) suite_3();
  ALUTestSuite #(4, 32, 16, 3, 0) suite_4();
  ALUTestSuite #(5,  8, 32, 0, 3) suite_5();
  ALUTestSuite #(6,  8, 16, 3, 3) suite_6();

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
