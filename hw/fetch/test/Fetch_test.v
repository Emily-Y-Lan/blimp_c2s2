//========================================================================
// Fetch_test.v
//========================================================================
// A testbench for our fetch unit

`include "hw/fetch/Fetch.v"
`include "intf/F__DIntf.v"
`include "intf/MemIntf.v"
`include "test/TraceUtils.v"
`include "test/fl/F__DTestD.v"
`include "test/fl/MemIntfTestServer.v"

import TestEnv::*;

//========================================================================
// FetchTestSuite
//========================================================================
// A test suite for a particular parametrization of the Fetch unit

module FetchTestSuite #(
  parameter p_suite_num = 0,
  parameter p_rst_addr  = 32'b0,
  parameter p_addr_bits = 32,
  parameter p_inst_bits = 32,
  parameter p_opaq_bits = 8,

  parameter p_mem_send_intv_delay = 1,
  parameter p_mem_recv_intv_delay = 1,
  parameter p_D_dut_intv_delay    = 0
);
  string suite_name = $sformatf("%0d: FetchTestSuite_%0p_%0d_%0d_%0d_%0d_%0d_%0d", 
                                p_suite_num, p_rst_addr, p_addr_bits,
                                p_inst_bits, p_opaq_bits,
                                p_mem_send_intv_delay, p_mem_recv_intv_delay,
                                p_D_dut_intv_delay);

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk, rst;
  TestUtils t( .* );

  `MEM_REQ_DEFINE ( p_inst_bits, p_addr_bits, p_opaq_bits );
  `MEM_RESP_DEFINE( p_inst_bits, p_addr_bits, p_opaq_bits );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  MemIntf #(
    .t_req_msg  (`MEM_REQ ( p_inst_bits, p_addr_bits, p_opaq_bits )),
    .t_resp_msg (`MEM_RESP( p_inst_bits, p_addr_bits, p_opaq_bits ))
  ) mem_intf;

  F__DIntf #(
    .p_addr_bits (p_addr_bits),
    .p_inst_bits (p_inst_bits)
  ) F__D_intf;

  Fetch #(
    .p_rst_addr  (p_rst_addr ),
    // .p_addr_bits (p_addr_bits),
    // .p_inst_bits (p_inst_bits),
    .p_opaq_bits (p_opaq_bits)
  ) dut (
    .mem (mem_intf),
    .D   (F__D_intf),
    .*
  );

  MemIntfTestServer #(
    .t_req_msg         (`MEM_REQ ( p_inst_bits, p_addr_bits, p_opaq_bits )),
    .t_resp_msg        (`MEM_RESP( p_inst_bits, p_addr_bits, p_opaq_bits )),
    .p_send_intv_delay (p_mem_send_intv_delay),
    .p_recv_intv_delay (p_mem_recv_intv_delay),
    .p_addr_bits       (p_addr_bits),
    .p_data_bits       (p_inst_bits),
    .p_opaq_bits       (p_opaq_bits)
  ) fl_mem_test_server (
    .dut (mem_intf),
    .*
  );

  F__DTestD #(
    .p_dut_intv_delay (p_D_dut_intv_delay),
    .p_addr_bits      (p_addr_bits),
    .p_inst_bits      (p_inst_bits)
  ) fl_D_test_intf (
    .dut (F__D_intf),
    .*
  );

  Tracer tracer ( clk, {
    fl_mem_test_server.trace,
    " | ",
    dut.trace,
    " | ",
    fl_D_test_intf.trace
  });

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );
    if( t.n != 0 )
      tracer.enable_trace();

    //                           addr            data
    fl_mem_test_server.init_mem( p_rst_addr,     p_inst_bits'(32'hdeadbeef) );
    fl_mem_test_server.init_mem( p_rst_addr + 4, p_inst_bits'(32'hcafef00d) );
    fl_mem_test_server.init_mem( p_rst_addr + 8, p_inst_bits'(32'hbaadb0ba) );

    //                                                                        br
    //                      inst                        pc              sq    tar
    fl_D_test_intf.add_msg( p_inst_bits'(32'hdeadbeef), p_rst_addr,     1'b0, '0 );
    fl_D_test_intf.add_msg( p_inst_bits'(32'hcafef00d), p_rst_addr + 4, 1'b0, '0 );
    fl_D_test_intf.add_msg( p_inst_bits'(32'hbaadb0ba), p_rst_addr + 8, 1'b0, '0 );

    while( !fl_D_test_intf.done() ) begin
      #10;
    end
    tracer.disable_trace();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_branch_basic
  //----------------------------------------------------------------------

  task test_case_2_branch_basic();
    t.test_case_begin( "test_case_2_branch_basic" );
    if( t.n != 0 )
      tracer.enable_trace();

    //                           addr            data
    fl_mem_test_server.init_mem( p_rst_addr,     p_inst_bits'(32'hdeadbeef) );
    fl_mem_test_server.init_mem( p_rst_addr + 4, p_inst_bits'(32'hfedcba00) );
    fl_mem_test_server.init_mem( p_rst_addr + 8, p_inst_bits'(32'h12345678) );

    //                                                                        br
    //                      inst                        pc              sq    tar       
    fl_D_test_intf.add_msg( p_inst_bits'(32'hdeadbeef), p_rst_addr,     1'b0, '0             );
    fl_D_test_intf.add_msg( p_inst_bits'(32'hfedcba00), p_rst_addr + 4, 1'b1, p_rst_addr     );

    fl_D_test_intf.add_msg( p_inst_bits'(32'hdeadbeef), p_rst_addr,     1'b0, '0             );
    fl_D_test_intf.add_msg( p_inst_bits'(32'hfedcba00), p_rst_addr + 4, 1'b0, '0             );
    fl_D_test_intf.add_msg( p_inst_bits'(32'h12345678), p_rst_addr + 8, 1'b1, p_rst_addr + 4 );

    fl_D_test_intf.add_msg( p_inst_bits'(32'hfedcba00), p_rst_addr + 4, 1'b0, '0             );
    fl_D_test_intf.add_msg( p_inst_bits'(32'h12345678), p_rst_addr + 8, 1'b0, '0             );

    while( !fl_D_test_intf.done() ) begin
      #10;
    end
    tracer.disable_trace();
  endtask

  //----------------------------------------------------------------------
  // test_case_3_branch_forward
  //----------------------------------------------------------------------

  task test_case_3_branch_forward();
    t.test_case_begin( "test_case_3_branch_forward" );
    if( t.n != 0 )
      tracer.enable_trace();

    //                           addr               data
    fl_mem_test_server.init_mem( p_rst_addr,        p_inst_bits'(32'h10101010) );
    fl_mem_test_server.init_mem( p_rst_addr + 'h4,  p_inst_bits'(32'h20202020) );
    fl_mem_test_server.init_mem( p_rst_addr + 'h10, p_inst_bits'(32'h30303030) );
    fl_mem_test_server.init_mem( p_rst_addr + 'h14, p_inst_bits'(32'h40404040) );
    fl_mem_test_server.init_mem( p_rst_addr + 'h48, p_inst_bits'(32'h50505050) );
    fl_mem_test_server.init_mem( p_rst_addr + 'h4c, p_inst_bits'(32'h60606060) );

    //                                                                           br
    //                      inst                        pc                 sq    tar       
    fl_D_test_intf.add_msg( p_inst_bits'(32'h10101010), p_rst_addr,        1'b0, '0                );
    fl_D_test_intf.add_msg( p_inst_bits'(32'h20202020), p_rst_addr + 'h4,  1'b1, p_rst_addr + 'h10 );

    fl_D_test_intf.add_msg( p_inst_bits'(32'h30303030), p_rst_addr + 'h10, 1'b0, '0                );
    fl_D_test_intf.add_msg( p_inst_bits'(32'h40404040), p_rst_addr + 'h14, 1'b1, p_rst_addr + 'h48 );

    fl_D_test_intf.add_msg( p_inst_bits'(32'h50505050), p_rst_addr + 'h48, 1'b0, '0                );
    fl_D_test_intf.add_msg( p_inst_bits'(32'h60606060), p_rst_addr + 'h4c, 1'b0, '0                );

    while( !fl_D_test_intf.done() ) begin
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
    if ((t.n <= 0) || (t.n == 2)) test_case_2_branch_basic();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_branch_forward();

  endtask
endmodule

//========================================================================
// Fetch_test
//========================================================================

module Fetch_test;
  FetchTestSuite #(2, 32'h00FFFF00, 32, 32, 8, 0, 0, 0) suite_2;
  FetchTestSuite #(1)                                   suite_1;
  FetchTestSuite #(3, 8'hF0,         8,  8, 1, 0, 0, 0) suite_3;
  FetchTestSuite #(4, 32'h0,        32, 32, 8, 3, 0, 0) suite_4;
  FetchTestSuite #(5, 32'h0,        32, 32, 8, 0, 3, 0) suite_5;
  FetchTestSuite #(6, 32'h0,        32, 32, 8, 0, 0, 3) suite_6;
  FetchTestSuite #(7, 16'hA000,     16, 32, 4, 3, 3, 3) suite_7;
  FetchTestSuite #(3, 8'hF0,         8,  8, 1, 9, 9, 9) suite_8;

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
    if ((s <= 0) || (s == 7)) suite_7.run_test_suite();
    if ((s <= 0) || (s == 7)) suite_8.run_test_suite();

    test_bench_end();
  end
endmodule
