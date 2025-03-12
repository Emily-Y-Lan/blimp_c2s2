//========================================================================
// RenameTable_test.v
//========================================================================
// A testbench for our rename table

`include "hw/decode_issue/rename_table/RenameTable.v"
`include "intf/CompleteNotif.v"
`include "test/fl/TestCaller.v"
`include "test/TestUtils.v"

import TestEnv::*;

//========================================================================
// RenameTableTestSuite
//========================================================================
// A test suite for the rename table

module RenameTableTestSuite #(
  parameter p_suite_num     = 0,
  parameter p_num_phys_regs = 36
);

  localparam p_phys_addr_bits = $clog2( p_num_phys_regs );

  string suite_name = $sformatf("%0d: RenameTableTestSuite_%0d", 
                                p_suite_num, p_num_phys_regs);
  
  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk, rst;
  TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic                  [4:0] dut_alloc_areg;
  logic [p_phys_addr_bits-1:0] dut_alloc_preg;
  logic [p_phys_addr_bits-1:0] dut_alloc_ppreg;
  logic                        dut_alloc_en;
  logic                        dut_alloc_rdy;

  logic                  [4:0] dut_lookup_areg [2];
  logic [p_phys_addr_bits-1:0] dut_lookup_preg [2];
  logic                        dut_lookup_en   [2];

  CompleteNotif #(
    .p_phys_addr_bits (p_phys_addr_bits)
  ) complete_notif();

  RenameTable #(
    .p_num_phys_regs (p_num_phys_regs)
  ) dut (
    .alloc_areg  (dut_alloc_areg),
    .alloc_preg  (dut_alloc_preg),
    .alloc_ppreg (dut_alloc_ppreg),
    .alloc_en    (dut_alloc_en),
    .alloc_rdy   (dut_alloc_rdy),

    .lookup_areg (dut_lookup_areg),
    .lookup_preg (dut_lookup_preg),
    .lookup_en   (dut_lookup_en),

    .complete    (complete_notif),
    .*
  );

  //----------------------------------------------------------------------
  // Allocation
  //----------------------------------------------------------------------

  typedef logic [4:0] t_alloc_call_msg;

  typedef struct packed {
    logic [p_phys_addr_bits-1:0] alloc_preg;
    logic [p_phys_addr_bits-1:0] alloc_ppreg;
  } t_alloc_ret_msg;

  t_alloc_ret_msg alloc_ret_msg;
  assign alloc_ret_msg.alloc_preg  = dut_alloc_preg;
  assign alloc_ret_msg.alloc_ppreg = dut_alloc_ppreg;

  TestCaller #(
    .t_call_msg (t_alloc_call_msg),
    .t_ret_msg  (t_alloc_ret_msg)
  ) alloc_caller (
    .call_msg (dut_alloc_areg),
    .ret_msg  (alloc_ret_msg),
    .en       (dut_alloc_en),
    .rdy      (dut_alloc_rdy),
    .*
  );

  t_alloc_ret_msg msg_from_alloc;

  task alloc(
    input logic                  [4:0] alloc_areg,
    input logic [p_phys_addr_bits-1:0] alloc_preg,
    input logic [p_phys_addr_bits-1:0] alloc_ppreg
  );
    msg_from_alloc.alloc_preg  = alloc_preg;
    msg_from_alloc.alloc_ppreg = alloc_ppreg;

    alloc_caller.call( alloc_areg, msg_from_alloc );
  endtask

  //----------------------------------------------------------------------
  // Lookup
  //----------------------------------------------------------------------

  typedef logic                  [4:0] t_lookup_call_msg;
  typedef logic [p_phys_addr_bits-1:0] t_lookup_ret_msg;

  TestCaller #(
    .t_call_msg (t_lookup_call_msg),
    .t_ret_msg  (t_lookup_ret_msg)
  ) lookup_caller[2] (
    .call_msg (dut_lookup_areg),
    .ret_msg  (dut_lookup_preg),
    .en       (dut_lookup_en),
    .rdy      (1'b1),
    .*
  );

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );
    if( !t.run_test ) return;

    //     areg preg ppreg
    alloc( 1,   32,  1 );

    //                     areg preg
    lookup_caller[0].call( 1,   32 );
    lookup_caller[1].call( 1,   32 );

    t.test_case_end();
  endtask

  task run_test_suite();
    t.test_suite_begin( suite_name );

    test_case_1_basic();
  endtask
endmodule

//========================================================================
// RenameTable_test
//========================================================================

module RenameTable_test;
  RenameTableTestSuite #(1)     suite_1();
  RenameTableTestSuite #(2, 64) suite_2();

  int s;

  initial begin
    test_bench_begin( `__FILE__ );
    s = get_test_suite();

    if ((s <= 0) || (s == 1)) suite_1.run_test_suite();
    if ((s <= 0) || (s == 2)) suite_2.run_test_suite();

    test_bench_end();
  end
endmodule
