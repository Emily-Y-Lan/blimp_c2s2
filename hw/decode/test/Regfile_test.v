//========================================================================
// Regfile_test.v
//========================================================================
// A testbench for our parametrized register

`include "test/TestUtils.v"
`include "hw/decode/Regfile.v"

import TestEnv::*;

//========================================================================
// RegfileTestSuite
//========================================================================
// A test suite for a particular parametrization of the regfile

module RegfileTestSuite #(
  parameter p_suite_num  = 0,
  parameter type t_entry = logic [31:0],
  parameter p_num_regs   = 32
);
  string suite_name = $sformatf("%0d: RegfileTestSuite_%0d_%s", 
                                p_suite_num, p_num_regs, 
                                $typename( t_entry ));

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

  localparam p_addr_bits = $clog2(p_num_regs);

  logic                   dut_rst;
  logic [p_addr_bits-1:0] dut_raddr [1:0];
  t_entry                 dut_rdata [1:0];
  logic [p_addr_bits-1:0] dut_waddr;
  t_entry                 dut_wdata;
  logic                   dut_wen;

  Regfile #(
    .t_entry    (t_entry),
    .p_num_regs (p_num_regs)
  ) DUT (
    .clk   (clk),
    .rst   (rst | dut_rst),
    .raddr (dut_raddr),
    .rdata (dut_rdata),
    .waddr (dut_waddr),
    .wdata (dut_wdata),
    .wen   (dut_wen)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check (
    input logic                   _rst,
    input logic [p_addr_bits-1:0] raddr0,
    input t_entry                 rdata0,
    input logic [p_addr_bits-1:0] raddr1,
    input t_entry                 rdata1,
    input logic [p_addr_bits-1:0] waddr,
    input t_entry                 wdata,
    input logic                   wen
  );
    if ( !t.failed ) begin
      dut_rst      = _rst;
      dut_raddr[0] = raddr0;
      dut_rdata[0] = rdata0;
      dut_raddr[1] = raddr1;
      dut_rdata[1] = rdata1;
      dut_waddr    = waddr;
      dut_wdata    = wdata;
      dut_wen      = wen;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b %h %h %b %h(%h) > %h %h", t.cycles,
                  dut_rst, dut_raddr[0], dut_raddr[1],
                  dut_wen, dut_waddr, dut_wdata,
                  dut_rdata[0], dut_rdata[1] );
      end

      `CHECK_EQ( dut_rdata[0], rdata0 );
      `CHECK_EQ( dut_rdata[1], rdata1 );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //    rst raddr0              rdata0            raddr1              rdata1            waddr               waddr            wen
    check( 0, p_addr_bits'('h00), t_entry'('h0000), p_addr_bits'('h00), t_entry'('h0000), p_addr_bits'('h00), t_entry'('h0000), 0 );
    check( 0, p_addr_bits'('h00), t_entry'('h0000), p_addr_bits'('h00), t_entry'('h0000), p_addr_bits'('h01), t_entry'('habcd), 1 );
    check( 0, p_addr_bits'('h01), t_entry'('habcd), p_addr_bits'('h01), t_entry'('habcd), p_addr_bits'('h00), t_entry'('h0000), 0 );
  endtask

  //----------------------------------------------------------------------
  // test_case_2_reset
  //----------------------------------------------------------------------

  task test_case_2_reset();
    t.test_case_begin( "test_case_2_reset" );

    //    rst raddr0              rdata0            raddr1              rdata1            waddr               waddr            wen
    check( 0, p_addr_bits'('h00), t_entry'('h0000), p_addr_bits'('h00), t_entry'('h0000), p_addr_bits'('h05), t_entry'('hf00d), 1 );
    check( 1, p_addr_bits'('h05), t_entry'('hf00d), p_addr_bits'('h00), t_entry'('h0000), p_addr_bits'('h00), t_entry'('h0000), 0 );
    check( 0, p_addr_bits'('h05), t_entry'('h0000), p_addr_bits'('h00), t_entry'('h0000), p_addr_bits'('h00), t_entry'('h0000), 0 );
  endtask

  //----------------------------------------------------------------------
  // test_case_3_zero
  //----------------------------------------------------------------------

  task test_case_3_zero();
    t.test_case_begin( "test_case_3_zero" );

    //    rst raddr0              rdata0            raddr1              rdata1            waddr               waddr            wen
    check( 0, p_addr_bits'('h00), t_entry'('h0000), p_addr_bits'('h00), t_entry'('h0000), p_addr_bits'('h00), t_entry'('hbaad), 1 );
    check( 1, p_addr_bits'('h00), t_entry'('h0000), p_addr_bits'('h00), t_entry'('h0000), p_addr_bits'('h00), t_entry'('h4321), 1 );
    check( 0, p_addr_bits'('h00), t_entry'('h0000), p_addr_bits'('h00), t_entry'('h0000), p_addr_bits'('h00), t_entry'('h0000), 0 );
  endtask

  //----------------------------------------------------------------------
  // test_case_4_multi_read
  //----------------------------------------------------------------------

  task test_case_4_multi_read();
    t.test_case_begin( "test_case_4_multi_read" );

    //    rst raddr0              rdata0            raddr1              rdata1            waddr               waddr            wen
    check( 0, p_addr_bits'('h00), t_entry'('h0000), p_addr_bits'('h00), t_entry'('h0000), p_addr_bits'('h06), t_entry'('h1234), 1 );
    check( 1, p_addr_bits'('h06), t_entry'('h1234), p_addr_bits'('h00), t_entry'('h0000), p_addr_bits'('h07), t_entry'('h5678), 1 );
    check( 0, p_addr_bits'('h06), t_entry'('h1234), p_addr_bits'('h07), t_entry'('h5678), p_addr_bits'('h00), t_entry'('h0000), 0 );
    check( 0, p_addr_bits'('h07), t_entry'('h5678), p_addr_bits'('h06), t_entry'('h1234), p_addr_bits'('h00), t_entry'('h0000), 0 );
  endtask

  //----------------------------------------------------------------------
  // test_case_5_random
  //----------------------------------------------------------------------

  t_entry rand_regs [p_num_regs-1:0];
  initial begin
    rand_regs = '{default: '0};
  end

  logic [p_addr_bits-1:0] rand_raddr0;
  logic [p_addr_bits-1:0] rand_raddr1;
  logic [p_addr_bits-1:0] rand_waddr;
  t_entry                 rand_wdata;
  logic                   rand_wen;
  t_entry                 exp_rdata0;
  t_entry                 exp_rdata1;

  task test_case_5_random();
    t.test_case_begin( "test_case_5_random" );

    for ( int i = 0; i < 20; i = i + 1 ) begin
      rand_raddr0 = p_addr_bits'($urandom());
      rand_raddr1 = p_addr_bits'($urandom());
      rand_waddr  = p_addr_bits'($urandom());
      rand_wdata  = t_entry'($urandom());
      rand_wen    = 1'($urandom());

      exp_rdata0  = rand_regs[rand_raddr0];
      exp_rdata1  = rand_regs[rand_raddr1];

      check( 0, rand_raddr0, exp_rdata0, rand_raddr1, exp_rdata1,
             rand_waddr, rand_wdata, rand_wen );

      if ( rand_wen ) rand_regs[rand_waddr] = rand_wdata;
    end
  endtask

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  task run_test_suite();
    t.test_suite_begin( suite_name );

    if ( (t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ( (t.n <= 0) || (t.n == 2)) test_case_2_reset();
    if ( (t.n <= 0) || (t.n == 3)) test_case_3_zero();
    if ( (t.n <= 0) || (t.n == 4)) test_case_4_multi_read();
    if ( (t.n <= 0) || (t.n == 5)) test_case_5_random();

  endtask
endmodule

//========================================================================
// Regfile_test
//========================================================================

module Regfile_test;
  RegfileTestSuite #(1)                  suite_1;
  RegfileTestSuite #(2, logic[15:0], 32) suite_2;
  RegfileTestSuite #(3, logic[31:0], 8 ) suite_3;
  RegfileTestSuite #(4, logic[ 7:0], 64) suite_4;

  int s;

  initial begin
    test_bench_begin( `__FILE__ );
    s = get_test_suite();

    if ((s <= 0) || (s == 1)) suite_1.run_test_suite();
    if ((s <= 0) || (s == 2)) suite_2.run_test_suite();
    if ((s <= 0) || (s == 3)) suite_3.run_test_suite();
    if ((s <= 0) || (s == 4)) suite_4.run_test_suite();

    test_bench_end();
  end
endmodule
