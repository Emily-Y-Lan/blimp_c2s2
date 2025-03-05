//========================================================================
// Regfile_test.v
//========================================================================
// A testbench for our parametrized register

`include "test/TestUtils.v"
`include "hw/decode_issue/Regfile.v"

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
  logic [p_addr_bits-1:0] dut_raddr   [1:0];
  t_entry                 dut_rdata   [1:0];
  logic [p_addr_bits-1:0] dut_waddr;
  t_entry                 dut_wdata;
  logic                   dut_wen;
  logic [p_addr_bits-1:0] dut_pending_set_addr;
  logic                   dut_pending_set_val;
  logic                   dut_read_pending [1:0];
  logic [p_addr_bits-1:0] dut_check_addr;
  logic                   dut_check_addr_pending;


  Regfile #(
    .t_entry    (t_entry),
    .p_num_regs (p_num_regs)
  ) DUT (
    .clk                (clk),
    .rst                (rst | dut_rst),
    .raddr              (dut_raddr),
    .rdata              (dut_rdata),
    .waddr              (dut_waddr),
    .wdata              (dut_wdata),
    .wen                (dut_wen),
    .pending_set_addr   (dut_pending_set_addr),
    .pending_set_val    (dut_pending_set_val),
    .read_pending       (dut_read_pending),
    .check_addr         (dut_check_addr),
    .check_addr_pending (dut_check_addr_pending)
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
    input logic                   read_pending0,
    input logic [p_addr_bits-1:0] raddr1,
    input t_entry                 rdata1,
    input logic                   read_pending1,
    input logic [p_addr_bits-1:0] waddr,
    input t_entry                 wdata,
    input logic                   wen,
    input logic [p_addr_bits-1:0] check_addr,
    input logic                   check_addr_pending,
    input logic [p_addr_bits-1:0] pending_set_addr,
    input logic                   pending_set_val
  );
    if ( !t.failed ) begin
      dut_rst              = _rst;
      dut_raddr[0]         = raddr0;
      dut_raddr[1]         = raddr1;
      dut_waddr            = waddr;
      dut_wdata            = wdata;
      dut_wen              = wen;
      dut_check_addr       = check_addr;
      dut_pending_set_addr = pending_set_addr;
      dut_pending_set_val  = pending_set_val;

      #8;

      if ( t.verbose ) begin
        $display( "%3d: %b %d %d %b %d(%h) %d (%d (%b)) > %h (%b) %h (%b) (%b)", t.cycles,
                  dut_rst, dut_raddr[0], dut_raddr[1],
                  dut_wen, dut_waddr, dut_wdata, dut_check_addr,
                  dut_pending_set_addr, dut_pending_set_val,
                  dut_rdata[0], dut_read_pending[0],
                  dut_rdata[1], dut_read_pending[1],
                  dut_check_addr_pending );
      end

      `CHECK_EQ( dut_rdata[0],           rdata0             );
      `CHECK_EQ( dut_rdata[1],           rdata1             );
      `CHECK_EQ( dut_read_pending[0],    read_pending0      );
      `CHECK_EQ( dut_read_pending[1],    read_pending1      );
      `CHECK_EQ( dut_check_addr_pending, check_addr_pending );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );
    if( !t.run_test ) return;

    //    rst raddr0 rdata0 p0 raddr1 rdata1 p1 waddr waddr  wen caddr cpend paddr pval
    check( 0, 0,     'h00,  0, 0,     'h00,  0, 0,   'h00,   0,  0,    0,    '0,   0 );
    check( 0, 0,     'h00,  0, 0,     'h00,  0, 1,   'hab,   1,  0,    0,    '0,   0 );
    check( 0, 1,     'hab,  0, 1,     'hab,  0, 0,   'h00,   0,  0,    0,    '0,   0 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_reset
  //----------------------------------------------------------------------

  task test_case_2_reset();
    t.test_case_begin( "test_case_2_reset" );
    if( !t.run_test ) return;

    //    rst raddr0 rdata0 p0 raddr1 rdata1 p1 waddr waddr wen caddr cpend paddr pval
    check( 0, 0,     'h00,  0, 0,     'h00,  0, 5,    'hf0, 1,  0,    0,    '0,   0 );
    check( 1, 5,     'hf0,  0, 0,     'h00,  0, 0,    'h00, 0,  0,    0,    '0,   0 );
    check( 0, 5,     'h00,  0, 0,     'h00,  0, 0,    'h00, 0,  0,    0,    '0,   0 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_3_zero
  //----------------------------------------------------------------------

  task test_case_3_zero();
    t.test_case_begin( "test_case_3_zero" );
    if( !t.run_test ) return;

    //    rst raddr0              rdata0            p0 raddr1              rdata1            p1 waddr               waddr            wen caddr cpend paddr pval
    check( 0, p_addr_bits'('h00), t_entry'('h0000), 0, p_addr_bits'('h00), t_entry'('h0000), 0, p_addr_bits'('h00), t_entry'('hbaad), 1, 0,    0,    '0,   0 );
    check( 1, p_addr_bits'('h00), t_entry'('h0000), 0, p_addr_bits'('h00), t_entry'('h0000), 0, p_addr_bits'('h00), t_entry'('h4321), 1, 0,    0,    '0,   0 );
    check( 0, p_addr_bits'('h00), t_entry'('h0000), 0, p_addr_bits'('h00), t_entry'('h0000), 0, p_addr_bits'('h00), t_entry'('h0000), 0, 0,    0,    '0,   0 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_4_all
  //----------------------------------------------------------------------

  logic [p_addr_bits-1:0] curr_addr;
  t_entry                 curr_data;
  logic [p_addr_bits-1:0] prev_addr;
  t_entry                 prev_data;

  task test_case_4_all();
    t.test_case_begin( "test_case_4_all" );
    if( !t.run_test ) return;

    prev_addr = '0;
    prev_data = '0;

    for ( int i = 1; i < p_num_regs; i = i + 1 ) begin
      curr_addr = p_addr_bits'(i);
      curr_data = t_entry'($urandom());

      check( 0, prev_addr, prev_data, 0, prev_addr, prev_data, 0, curr_addr, curr_data, 1, 0, 0, '0, 0 );

      prev_addr = curr_addr;
      prev_data = curr_data;
    end

    check( 0, prev_addr, prev_data, 0, prev_addr, prev_data, 0, p_addr_bits'('0), t_entry'('0), 0, 0, 0, '0, 0 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_5_multi_read
  //----------------------------------------------------------------------

  task test_case_5_multi_read();
    t.test_case_begin( "test_case_5_multi_read" );
    if( !t.run_test ) return;

    //    rst raddr0              rdata0            p0 raddr1              rdata1            p1 waddr               waddr            wen caddr cpend paddr pval
    check( 0, p_addr_bits'('h00), t_entry'('h0000), 0, p_addr_bits'('h00), t_entry'('h0000), 0, p_addr_bits'('h06), t_entry'('h1234), 1, 0,    0,    '0,   0 );
    check( 0, p_addr_bits'('h06), t_entry'('h1234), 0, p_addr_bits'('h00), t_entry'('h0000), 0, p_addr_bits'('h07), t_entry'('h5678), 1, 0,    0,    '0,   0 );
    check( 0, p_addr_bits'('h06), t_entry'('h1234), 0, p_addr_bits'('h07), t_entry'('h5678), 0, p_addr_bits'('h00), t_entry'('h0000), 0, 0,    0,    '0,   0 );
    check( 0, p_addr_bits'('h07), t_entry'('h5678), 0, p_addr_bits'('h06), t_entry'('h1234), 0, p_addr_bits'('h00), t_entry'('h0000), 0, 0,    0,    '0,   0 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_6_pending
  //----------------------------------------------------------------------

  task test_case_6_pending();
    t.test_case_begin( "test_case_6_pending" );
    if( !t.run_test ) return;

    //    rst raddr0              rdata0            p0 raddr1              rdata1            p1 waddr               waddr            wen caddr cpend paddr pval
    check( 0, p_addr_bits'('h00), t_entry'('h0000), 0, p_addr_bits'('h01), t_entry'('h0000), 0, p_addr_bits'('h06), t_entry'('h1234), 1, 0,    0,    '0,   0 );
    check( 0, p_addr_bits'('h06), t_entry'('h1234), 0, p_addr_bits'('h00), t_entry'('h0000), 0, p_addr_bits'('h07), t_entry'('h5678), 1, 0,    0,    '0,   0 );
    check( 0, p_addr_bits'('h06), t_entry'('h1234), 0, p_addr_bits'('h07), t_entry'('h5678), 0, p_addr_bits'('h00), t_entry'('h0000), 0, 0,    0,    '0,   0 );
    check( 0, p_addr_bits'('h07), t_entry'('h5678), 0, p_addr_bits'('h06), t_entry'('h1234), 0, p_addr_bits'('h00), t_entry'('h0000), 0, 0,    0,    '0,   0 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_7_random
  //----------------------------------------------------------------------

  t_entry rand_regs [p_num_regs-1:0];
  logic   pbits     [p_num_regs-1:0];
  initial begin
    rand_regs = '{default: '0};
    pbits     = '{default: 1'b0};
  end

  logic [p_addr_bits-1:0] rand_raddr0;
  logic [p_addr_bits-1:0] rand_raddr1;
  logic [p_addr_bits-1:0] rand_waddr;
  t_entry                 rand_wdata;
  logic                   rand_wen;
  t_entry                 exp_rdata0;
  t_entry                 exp_rdata1;
  logic                   exp_pending0;
  logic                   exp_pending1;
  logic [p_addr_bits-1:0] rand_paddr;
  logic                   rand_pval;
  logic [p_addr_bits-1:0] rand_caddr;
  logic                   exp_cpend;

  task test_case_7_random();
    t.test_case_begin( "test_case_7_random" );
    if( !t.run_test ) return;

    for ( int i = 0; i < 30; i = i + 1 ) begin
      rand_raddr0 = p_addr_bits'($urandom());
      rand_raddr1 = p_addr_bits'($urandom());
      rand_waddr  = p_addr_bits'($urandom());
      rand_wdata  = t_entry'($urandom());
      rand_wen    = 1'($urandom());
      rand_paddr  = p_addr_bits'($urandom());
      rand_pval   = 1'($urandom());
      rand_caddr  = p_addr_bits'($urandom());

      exp_rdata0   = rand_wen & ( rand_waddr == rand_raddr0 ) & ( rand_waddr != '0 )
                     ? rand_wdata : rand_regs[rand_raddr0];
      exp_rdata1   = rand_wen & ( rand_waddr == rand_raddr1 ) & ( rand_waddr != '0 )
                     ? rand_wdata : rand_regs[rand_raddr1];
      exp_pending0 = !( rand_wen & ( rand_waddr == rand_raddr0 )) & pbits[rand_raddr0];
      exp_pending1 = !( rand_wen & ( rand_waddr == rand_raddr1 )) & pbits[rand_raddr1];
      exp_cpend    = pbits[rand_caddr] & (rand_caddr != '0) & (rand_caddr != rand_waddr);

      check( 0, rand_raddr0, exp_rdata0, exp_pending0,
             rand_raddr1, exp_rdata1, exp_pending1,
             rand_waddr, rand_wdata, rand_wen, 
             rand_caddr, exp_cpend,
             rand_paddr, rand_pval );

      if ( rand_wen & ( rand_waddr != '0 ) ) rand_regs[rand_waddr] = rand_wdata;
      for( int j = 1; j < p_num_regs; j = j + 1 ) begin
        if( rand_pval & ( rand_paddr == p_addr_bits'(j) ))
          pbits[rand_paddr] = 1'b1;
        else if( rand_wen & ( rand_waddr == p_addr_bits'(j) ))
          pbits[rand_waddr] = 1'b0;
      end
    end

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  task run_test_suite();
    t.test_suite_begin( suite_name );

    test_case_1_basic();
    test_case_2_reset();
    test_case_3_zero();
    test_case_4_all();
    test_case_5_multi_read();
    test_case_6_pending();
    test_case_7_random();

  endtask
endmodule

//========================================================================
// Regfile_test
//========================================================================

module Regfile_test;
  RegfileTestSuite #(1)                  suite_1();
  RegfileTestSuite #(2, logic[15:0], 32) suite_2();
  RegfileTestSuite #(3, logic[31:0], 8 ) suite_3();
  RegfileTestSuite #(4, logic[ 7:0], 64) suite_4();

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
