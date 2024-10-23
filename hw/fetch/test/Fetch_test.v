//========================================================================
// Fetch_test.v
//========================================================================
// A testbench for our fetch unit

`include "hw/fetch/Fetch.v"
`include "intf/F__DIntf.v"
`include "intf/MemIntf.v"
`include "test/fl/F__DTestD.v"
`include "test/fl/MemIntfTestServer.v"

import TestEnv::*;

//========================================================================
// FetchTestSuite
//========================================================================
// A test suite for a particular parametrization of the FIFO

module FetchTestSuite #(
  parameter p_suite_num = 0,
  parameter p_rst_addr  = 32'b0,
  parameter p_addr_bits = 32,
  parameter p_inst_bits = 32,
  parameter p_opaq_bits = 8,

  parameter p_mem_transac_delay = 1,
  parameter p_D_branch_delay    = 0
);
  string suite_name = $sformatf("%0d: FetchTestSuite_%0p_%0d_%0d_%0d_%0d_%0d", 
                                p_suite_num, p_rst_addr, p_addr_bits,
                                p_inst_bits, p_opaq_bits, p_mem_transac_delay,
                                p_D_branch_delay);

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk, rst;
  TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  MemIntf  mem_intf;
  F__DIntf F__D_intf;

  Fetch #(
    .p_rst_addr  (p_rst_addr ),
    .p_addr_bits (p_addr_bits),
    .p_inst_bits (p_inst_bits),
    .p_opaq_bits (p_opaq_bits)
  ) dut (
    .mem (mem_intf),
    .D   (F__D_intf),
    .*
  );

  MemIntfTestServer #(
    .t_req_msg  (t_mem_req_msg_32_32_8),
    .t_resp_msg (t_mem_resp_msg_32_32_8),
    .p_transac_delay (p_mem_transac_delay),
    .p_addr_bits  (p_addr_bits),
    .p_data_bits  (p_inst_bits)
  ) fl_mem_test_server (
    .dut (mem_intf),
    .*
  );

  F__DTestD #(
    .p_branch_delay (p_D_branch_delay),
    .p_addr_bits    (p_addr_bits),
    .p_inst_bits    (p_inst_bits)
  ) fl_D_test_intf (
    .dut (F__D_intf),
    .*
  );

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //                           addr        data
    fl_mem_test_server.init_mem( p_rst_addr, 32'hdeadbeef );

    //                                                      br  br
    //                      inst          pc          sq    tar val
    fl_D_test_intf.add_msg( 32'hdeadbeef, p_rst_addr, 1'b0, '0, 1'b0 );

    while( !fl_D_test_intf.done() ) #10;
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
// Fetch_test
//========================================================================

module Fetch_test;
  FetchTestSuite #(1)                         suite_1;
  FetchTestSuite #(2, 32'h0, 32, 32, 8, 3, 0) suite_2;
  FetchTestSuite #(3, 32'h0, 32, 32, 8, 0, 3) suite_3;

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
