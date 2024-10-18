//========================================================================
// Fifo_test.v
//========================================================================
// A testbench for our general-purpose FIFO

`include "test/TestUtils.v"
`include "hw/common/Fifo.v"

import TestEnv::*;

//========================================================================
// FifoTestSuite
//========================================================================
// A test suite for a particular parametrization of the FIFO

module FifoTestSuite #(
  parameter p_suite_num  = 0,
  parameter type t_entry = logic [31:0],
  parameter p_depth      = 32
);
  string suite_name = $sformatf("%0d: FifoTestSuite_%s_%0d", p_suite_num,
                                $typename(t_entry), p_depth);

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk, rst;
  TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic   dut_rst;
  logic   dut_push;
  logic   dut_pop;
  logic   dut_empty;
  logic   dut_full;
  t_entry dut_wdata;
  t_entry dut_rdata;

  Fifo #(
    .t_entry (t_entry),
    .p_depth (p_depth)
  ) DUT (
    .clk     (clk),
    .rst     (rst | dut_rst),
    .push    (dut_push),
    .pop     (dut_pop),
    .empty   (dut_empty),
    .full    (dut_full),
    .wdata   (dut_wdata),
    .rdata   (dut_rdata)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check (
    input logic   _rst,
    input logic   push,
    input logic   pop,
    input logic   empty,
    input logic   full,
    input t_entry wdata,
    input t_entry rdata
  );
    if ( !t.failed ) begin
      dut_rst   = _rst;
      dut_push  = push;
      dut_pop   = pop;
      dut_wdata = wdata;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b %b %b %s > %b %b %s", t.cycles,
                  dut_rst, dut_push, dut_pop, dut_wdata, 
                  dut_empty, dut_full, dut_rdata );
      end

      `CHECK_EQ( dut_empty, empty );
      `CHECK_EQ( dut_full,  full  );
      `CHECK_EQ( dut_rdata, rdata );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     rst push pop empty full wdata                 rdata
    check( 0,  0,   0,  1,    0,   t_entry'('h00000000), t_entry'('h00000000) );
    check( 0,  1,   0,  1,    0,   t_entry'('hdeadbeef), t_entry'('h00000000) );
    check( 0,  0,   0,  0,    0,   t_entry'('h00000000), t_entry'('hdeadbeef) );
    check( 0,  0,   1,  0,    0,   t_entry'('h00000000), t_entry'('hdeadbeef) );
    check( 0,  0,   0,  1,    0,   t_entry'('h00000000), t_entry'('h00000000) );
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
// Fifo_test
//========================================================================

module Fifo_test;
  FifoTestSuite #(1) suite_1;

  int s;

  initial begin
    test_bench_begin( `__FILE__ );
    s = get_test_suite();

    if ((s <= 0) || (s == 1)) suite_1.run_test_suite();

    test_bench_end();
  end
endmodule
