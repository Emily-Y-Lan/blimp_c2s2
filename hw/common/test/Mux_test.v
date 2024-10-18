//========================================================================
// Mux_test.v
//========================================================================
// A testbench for our parametrized Mux

`include "test/TestUtils.v"
`include "hw/common/Mux.v"

import TestEnv::*;

//========================================================================
// MuxTestSuite
//========================================================================
// A test suite for a particular parametrization of the FIFO

module MuxTestSuite #(
  parameter p_suite_num = 0,
  parameter type t_data = logic [31:0],
  parameter p_num_ports = 4,

  // Internal parameter
  parameter p_sel_bits  = $clog2(p_num_ports)
);
  string suite_name = $sformatf("%0d: MuxTestSuite_%s_%0d", p_suite_num,
                                $typename(t_data), p_num_ports);

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  // verilator lint_off UNUSED
  logic clk, rst;
  // verilator lint_on UNUSED

  TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  typedef t_data mux_inputs [p_num_ports-1:0];

  mux_inputs             dut_in;
  logic [p_sel_bits-1:0] dut_sel;
  t_data                 dut_out;

  Mux #(
    .t_data      (t_data),
    .p_num_ports (p_num_ports)
  ) DUT (
    .in  (dut_in),
    .sel (dut_sel),
    .out (dut_out)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check (
    input mux_inputs               in,
    input logic  [p_sel_bits-1:0]  sel,
    input t_data                   out
  );
    if ( !t.failed ) begin
      for( int i = 0; i < p_num_ports; i = i + 1 )
        dut_in[i] = in[i];
      dut_sel = sel;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %p %b > %p", t.cycles,
                  dut_in, dut_sel, dut_out );
      end

      `CHECK_EQ( dut_out, out );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // get_inputs
  //----------------------------------------------------------------------

  function mux_inputs get_inputs( int start, int stride );
    int curr_val;
    curr_val = start;
    for( int i = 0; i < p_num_ports; i = i + 1 ) begin
      get_inputs[i] = t_data'(curr_val);
      curr_val = curr_val + stride;
    end
  endfunction

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in                  sel out
    check( get_inputs( 0, 1 ), 0,  t_data'(0) );
    check( get_inputs( 0, 1 ), 0,  t_data'(0) );
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
// Mux_test
//========================================================================

module Mux_test;
  MuxTestSuite #(1)                  suite_1;
  MuxTestSuite #(2, logic,       32) suite_2;
  MuxTestSuite #(3, logic [7:0], 2 ) suite_3;

  int s;

  initial begin
    test_bench_begin( `__FILE__ );
    s = get_test_suite();

    if ((s <= 0) || (s == 1)) suite_1.run_test_suite();
    if ((s <= 0) || (s == 2)) suite_2.run_test_suite();
    if ((s <= 0) || (s == 3)) suite_3.run_test_suite();

    test_bench_end();
  end
endmodule
