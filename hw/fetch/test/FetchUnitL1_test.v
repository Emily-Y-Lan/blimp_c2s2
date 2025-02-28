//========================================================================
// Fetch_test.v
//========================================================================
// A testbench for our fetch unit

`include "hw/fetch/fetch_unit_variants/FetchUnitL1.v"
`include "intf/F__DIntf.v"
`include "intf/MemIntf.v"
`include "test/fl/MemIntfTestServer.v"
`include "test/fl/TestOstream.v"
// `include "test/fl/TestPub.v"

import TestEnv::*;

//========================================================================
// FetchUnitL1TestSuite
//========================================================================
// A test suite for a particular parametrization of the Fetch unit

module FetchUnitL1TestSuite #(
  parameter p_suite_num    = 0,
  parameter p_opaq_bits    = 8,
  parameter p_seq_num_bits = 5,

  parameter p_mem_send_intv_delay = 1,
  parameter p_mem_recv_intv_delay = 1,
  parameter p_D_recv_intv_delay   = 0
);
  string suite_name = $sformatf("%0d: FetchUnitL1TestSuite_%0d_%0d_%0d_%0d", 
                                p_suite_num, p_opaq_bits,
                                p_mem_send_intv_delay, p_mem_recv_intv_delay,
                                p_D_recv_intv_delay);

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk, rst;
  TestUtils t( .* );

  `MEM_REQ_DEFINE ( p_opaq_bits );
  `MEM_RESP_DEFINE( p_opaq_bits );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  MemIntf #(
    .t_req_msg  (`MEM_REQ ( p_opaq_bits )),
    .t_resp_msg (`MEM_RESP( p_opaq_bits ))
  ) mem_intf();

  F__DIntf #(
    .p_seq_num_bits (p_seq_num_bits)
  ) F__D_intf();

  FetchUnitL1 #(
    .p_opaq_bits (p_opaq_bits)
  ) dut (
    .mem (mem_intf),
    .D   (F__D_intf),
    .*
  );

  //----------------------------------------------------------------------
  // FL Memory
  //----------------------------------------------------------------------

  MemIntfTestServer #(
    .t_req_msg         (`MEM_REQ ( p_opaq_bits )),
    .t_resp_msg        (`MEM_RESP( p_opaq_bits )),
    .p_send_intv_delay (p_mem_send_intv_delay),
    .p_recv_intv_delay (p_mem_recv_intv_delay),
    .p_opaq_bits       (p_opaq_bits)
  ) fl_mem (
    .dut (mem_intf),
    .*
  );

  //----------------------------------------------------------------------
  // FL D Ostream
  //----------------------------------------------------------------------

  typedef struct packed {
    logic [31:0] inst;
    logic [31:0] pc;
  } t_f__d_msg;

  t_f__d_msg f__d_msg;

  assign f__d_msg.inst = F__D_intf.inst;
  assign f__d_msg.pc   = F__D_intf.pc;

  logic [p_seq_num_bits-1:0] unused_seq_num;
  assign unused_seq_num = F__D_intf.seq_num;

  TestOstream #( t_f__d_msg, p_D_recv_intv_delay ) D_Ostream (
    .msg (f__d_msg),
    .val (F__D_intf.val),
    .rdy (F__D_intf.rdy),
    .*
  );

  t_f__d_msg msg_to_recv;

  task recv(
    input logic [31:0] inst,
    input logic [31:0] pc
  );
    msg_to_recv.inst = inst;
    msg_to_recv.pc   = pc;

    D_Ostream.recv(msg_to_recv);
  endtask

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

  string trace;

  // verilator lint_off BLKSEQ
  always_ff @( posedge clk ) begin
    #2;
    trace = "";

    trace = {trace, fl_mem.trace()};
    trace = {trace, " | "};
    trace = {trace, dut.trace()};
    trace = {trace, " | "};
    trace = {trace, D_Ostream.trace()};

    t.trace( trace );
  end
  // verilator lint_on BLKSEQ

  //----------------------------------------------------------------------
  // Include test cases
  //----------------------------------------------------------------------

  `include "hw/fetch/test/test_cases/basic_test_cases.v"

  //----------------------------------------------------------------------
  // test_case_2_branch_basic
  //----------------------------------------------------------------------

  // task test_case_2_branch_basic();
  //   t.test_case_begin( "test_case_2_branch_basic" );
  //   if( t.n != 0 )
  //     tracer.enable_trace();

  //   //               addr            data
  //   fl_mem.init_mem( p_rst_addr,     p_inst_bits'(32'hdeadbeef) );
  //   fl_mem.init_mem( p_rst_addr + 4, p_inst_bits'(32'hfedcba00) );
  //   fl_mem.init_mem( p_rst_addr + 8, p_inst_bits'(32'h12345678) );

  //   //                                                                        br
  //   //                      inst                        pc              sq    tar       
  //   fl_D_test_intf.add_msg( p_inst_bits'(32'hdeadbeef), p_rst_addr,     1'b0, '0             );
  //   fl_D_test_intf.add_msg( p_inst_bits'(32'hfedcba00), p_rst_addr + 4, 1'b1, p_rst_addr     );

  //   fl_D_test_intf.add_msg( p_inst_bits'(32'hdeadbeef), p_rst_addr,     1'b0, '0             );
  //   fl_D_test_intf.add_msg( p_inst_bits'(32'hfedcba00), p_rst_addr + 4, 1'b0, '0             );
  //   fl_D_test_intf.add_msg( p_inst_bits'(32'h12345678), p_rst_addr + 8, 1'b1, p_rst_addr + 4 );

  //   fl_D_test_intf.add_msg( p_inst_bits'(32'hfedcba00), p_rst_addr + 4, 1'b0, '0             );
  //   fl_D_test_intf.add_msg( p_inst_bits'(32'h12345678), p_rst_addr + 8, 1'b0, '0             );

  //   while( !fl_D_test_intf.done() ) begin
  //     #10;
  //   end
  //   tracer.disable_trace();
  // endtask

  //----------------------------------------------------------------------
  // test_case_3_branch_forward
  //----------------------------------------------------------------------

  // task test_case_3_branch_forward();
  //   t.test_case_begin( "test_case_3_branch_forward" );
  //   if( t.n != 0 )
  //     tracer.enable_trace();

  //   //               addr               data
  //   fl_mem.init_mem( p_rst_addr,        p_inst_bits'(32'h10101010) );
  //   fl_mem.init_mem( p_rst_addr + 'h4,  p_inst_bits'(32'h20202020) );
  //   fl_mem.init_mem( p_rst_addr + 'h10, p_inst_bits'(32'h30303030) );
  //   fl_mem.init_mem( p_rst_addr + 'h14, p_inst_bits'(32'h40404040) );
  //   fl_mem.init_mem( p_rst_addr + 'h48, p_inst_bits'(32'h50505050) );
  //   fl_mem.init_mem( p_rst_addr + 'h4c, p_inst_bits'(32'h60606060) );

  //   //                                                                           br
  //   //                      inst                        pc                 sq    tar       
  //   fl_D_test_intf.add_msg( p_inst_bits'(32'h10101010), p_rst_addr,        1'b0, '0                );
  //   fl_D_test_intf.add_msg( p_inst_bits'(32'h20202020), p_rst_addr + 'h4,  1'b1, p_rst_addr + 'h10 );

  //   fl_D_test_intf.add_msg( p_inst_bits'(32'h30303030), p_rst_addr + 'h10, 1'b0, '0                );
  //   fl_D_test_intf.add_msg( p_inst_bits'(32'h40404040), p_rst_addr + 'h14, 1'b1, p_rst_addr + 'h48 );

  //   fl_D_test_intf.add_msg( p_inst_bits'(32'h50505050), p_rst_addr + 'h48, 1'b0, '0                );
  //   fl_D_test_intf.add_msg( p_inst_bits'(32'h60606060), p_rst_addr + 'h4c, 1'b0, '0                );

  //   while( !fl_D_test_intf.done() ) begin
  //     #10;
  //   end
  //   tracer.disable_trace();
  // endtask

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  task run_test_suite();
    t.test_suite_begin( suite_name );

    run_basic_test_cases();
    // if ((t.n <= 0) || (t.n == 2)) test_case_2_branch_basic();
    // if ((t.n <= 0) || (t.n == 3)) test_case_3_branch_forward();

  endtask
endmodule

//========================================================================
// FetchUnitL1_test
//========================================================================

module FetchUnitL1_test;
  FetchUnitL1TestSuite #(1)                suite_1();
  FetchUnitL1TestSuite #(2, 8, 5, 0, 0, 0) suite_2();
  FetchUnitL1TestSuite #(3, 1, 2, 0, 0, 0) suite_3();
  FetchUnitL1TestSuite #(4, 8, 3, 3, 0, 0) suite_4();
  FetchUnitL1TestSuite #(5, 8, 4, 0, 3, 0) suite_5();
  FetchUnitL1TestSuite #(6, 8, 6, 0, 0, 3) suite_6();
  FetchUnitL1TestSuite #(7, 4, 5, 3, 3, 3) suite_7();
  FetchUnitL1TestSuite #(8, 1, 7, 9, 9, 9) suite_8();

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
    if ((s <= 0) || (s == 8)) suite_8.run_test_suite();

    test_bench_end();
  end
endmodule
