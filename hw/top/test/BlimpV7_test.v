//========================================================================
// BlimpV7_test.v
//========================================================================
// The top-level testing module for Blimp V7

`include "asm/assemble.v"
`include "hw/top/BlimpV7.v"
`include "intf/MemIntf.v"
`include "intf/InstTraceNotif.v"
`include "test/fl/MemIntfTestServer_2Port.v"
`include "test/fl/InstTraceSub.v"
`include "fl/fl_vtrace.v"

import TestEnv::*;

//========================================================================
// BlimpV7TestSuite
//========================================================================
// A test suite for a particular parametrization of the Blimp V7 module

module BlimpV7TestSuite #(
  parameter p_suite_num     = 0,
  parameter p_opaq_bits     = 8,
  parameter p_seq_num_bits  = 5,
  parameter p_num_phys_regs = 36,

  parameter p_mem_send_intv_delay = 1,
  parameter p_mem_recv_intv_delay = 1
);

  string suite_name = $sformatf("%0d: BlimpV7TestSuite_%0d_%0d_%0d_%0d", 
                                p_suite_num,
                                p_opaq_bits, p_seq_num_bits,
                                p_mem_send_intv_delay, p_mem_recv_intv_delay);

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk, rst;
  TestUtils t( .* );

  initial t.timeout = 20000;

  `MEM_REQ_DEFINE ( p_opaq_bits );
  `MEM_RESP_DEFINE( p_opaq_bits );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  MemIntf #(
    .t_req_msg  (`MEM_REQ ( p_opaq_bits )),
    .t_resp_msg (`MEM_RESP( p_opaq_bits ))
  ) mem_intf[2]();

  InstTraceNotif inst_trace_notif();

  BlimpV7 #(
    .p_opaq_bits     (p_opaq_bits),
    .p_seq_num_bits  (p_seq_num_bits),
    .p_num_phys_regs (p_num_phys_regs)
  ) dut (
    .inst_mem   (mem_intf[0]),
    .data_mem   (mem_intf[1]),
    .inst_trace (inst_trace_notif),
    .*
  );

  //----------------------------------------------------------------------
  // FL Memory
  //----------------------------------------------------------------------

  MemIntfTestServer_2Port #(
    .t_req_msg         (`MEM_REQ ( p_opaq_bits )),
    .t_resp_msg        (`MEM_RESP( p_opaq_bits )),
    .p_send_intv_delay (p_mem_send_intv_delay),
    .p_recv_intv_delay (p_mem_recv_intv_delay),
    .p_opaq_bits       (p_opaq_bits)
  ) fl_mem (
    .dut (mem_intf),
    .*
  );

  logic [31:0] asm_binary;
  
  task asm(
    input logic [31:0] addr,
    input string       inst
  );
    asm_binary = assemble( inst, addr );
    fl_mem.init_mem( addr, asm_binary );
    fl_init        ( addr, asm_binary );
  endtask

  task data(
    input logic [31:0] addr,
    input logic [31:0] data
  );
    fl_mem.init_mem( addr, data );
    fl_init        ( addr, data );
  endtask

  //----------------------------------------------------------------------
  // Instruction Tracing
  //----------------------------------------------------------------------

  InstTraceSub inst_trace_sub (
    .pc    (inst_trace_notif.pc),
    .waddr (inst_trace_notif.waddr),
    .wdata (inst_trace_notif.wdata),
    .wen   (inst_trace_notif.wen),
    .val   (inst_trace_notif.val),
    .*
  );

  task check_trace(
    input logic [31:0] pc,
    input logic  [4:0] waddr,
    input logic [31:0] wdata,
    input logic        wen
  );

    inst_trace_sub.check_trace(
      pc,
      waddr,
      wdata,
      wen
    );
  endtask

  logic      check_traces_success;
  inst_trace check_traces_fl_trace;

  task check_traces();
    while( 1 ) begin
      check_traces_success = fl_trace( check_traces_fl_trace );
      if( !check_traces_success ) return;
      
      inst_trace_sub.check_trace(
        check_traces_fl_trace.pc,
        check_traces_fl_trace.waddr,
        check_traces_fl_trace.wdata,
        check_traces_fl_trace.wen
      );
    end
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
    trace = {trace, " || "};
    trace = {trace, dut.trace()};
    trace = {trace, " || "};
    trace = {trace, inst_trace_sub.trace()};

    t.trace( trace );
  end
  // verilator lint_on BLKSEQ

  //----------------------------------------------------------------------
  // Include Tests
  //----------------------------------------------------------------------

  `include "hw/top/test/test_cases/directed/addi_test_cases.v"
  `include "hw/top/test/test_cases/directed/add_test_cases.v"
  `include "hw/top/test/test_cases/directed/mul_test_cases.v"
  `include "hw/top/test/test_cases/directed/lw_test_cases.v"
  `include "hw/top/test/test_cases/directed/sw_test_cases.v"
  `include "hw/top/test/test_cases/directed/jal_test_cases.v"
  `include "hw/top/test/test_cases/directed/jalr_test_cases.v"
  `include "hw/top/test/test_cases/directed/bne_test_cases.v"

  `include "hw/top/test/test_cases/directed/sub_test_cases.v"
  `include "hw/top/test/test_cases/directed/and_test_cases.v"
  `include "hw/top/test/test_cases/directed/or_test_cases.v"
  `include "hw/top/test/test_cases/directed/xor_test_cases.v"
  `include "hw/top/test/test_cases/directed/slt_test_cases.v"
  `include "hw/top/test/test_cases/directed/sltu_test_cases.v"
  `include "hw/top/test/test_cases/directed/sra_test_cases.v"
  `include "hw/top/test/test_cases/directed/srl_test_cases.v"
  `include "hw/top/test/test_cases/directed/sll_test_cases.v"

  `include "hw/top/test/test_cases/directed/andi_test_cases.v"
  `include "hw/top/test/test_cases/directed/ori_test_cases.v"
  `include "hw/top/test/test_cases/directed/xori_test_cases.v"
  `include "hw/top/test/test_cases/directed/slti_test_cases.v"
  `include "hw/top/test/test_cases/directed/sltiu_test_cases.v"
  `include "hw/top/test/test_cases/directed/srai_test_cases.v"
  `include "hw/top/test/test_cases/directed/srli_test_cases.v"
  `include "hw/top/test/test_cases/directed/slli_test_cases.v"
  `include "hw/top/test/test_cases/directed/lui_test_cases.v"
  `include "hw/top/test/test_cases/directed/auipc_test_cases.v"

  `include "hw/top/test/test_cases/directed/beq_test_cases.v"
  `include "hw/top/test/test_cases/directed/blt_test_cases.v"
  `include "hw/top/test/test_cases/directed/bge_test_cases.v"
  `include "hw/top/test/test_cases/directed/bltu_test_cases.v"
  `include "hw/top/test/test_cases/directed/bgeu_test_cases.v"

  `include "hw/top/test/test_cases/golden/addi_test_cases.v"
  `include "hw/top/test/test_cases/golden/add_test_cases.v"
  `include "hw/top/test/test_cases/golden/mul_test_cases.v"
  `include "hw/top/test/test_cases/golden/lw_test_cases.v"
  `include "hw/top/test/test_cases/golden/sw_test_cases.v"
  `include "hw/top/test/test_cases/golden/jal_test_cases.v"
  `include "hw/top/test/test_cases/golden/jalr_test_cases.v"
  `include "hw/top/test/test_cases/golden/bne_test_cases.v"

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  task run_test_suite();
    t.test_suite_begin( suite_name );

    run_directed_addi_tests();
    run_directed_add_tests();
    run_directed_mul_tests();
    run_directed_lw_tests();
    run_directed_sw_tests();
    run_directed_jal_tests();
    run_directed_jalr_tests();
    run_directed_bne_tests();

    run_directed_sub_tests();
    run_directed_and_tests();
    run_directed_or_tests();
    run_directed_xor_tests();
    run_directed_slt_tests();
    run_directed_sltu_tests();
    run_directed_sra_tests();
    run_directed_srl_tests();
    run_directed_sll_tests();

    run_directed_andi_tests();
    run_directed_ori_tests();
    run_directed_xori_tests();
    run_directed_slti_tests();
    run_directed_sltiu_tests();
    run_directed_srai_tests();
    run_directed_srli_tests();
    run_directed_slli_tests();
    run_directed_lui_tests();
    run_directed_auipc_tests();

    run_directed_beq_tests();
    run_directed_blt_tests();
    run_directed_bge_tests();
    run_directed_bltu_tests();
    run_directed_bgeu_tests();

    run_golden_addi_tests();
    run_golden_add_tests();
    run_golden_mul_tests();
    run_golden_lw_tests();
    run_golden_sw_tests();
    run_golden_jal_tests();
    run_golden_jalr_tests();
    run_golden_bne_tests();

  endtask
endmodule

//========================================================================
// BlimpV7_test
//========================================================================

module BlimpV7_test;
  BlimpV7TestSuite #(1)                  suite_1();
  BlimpV7TestSuite #(2,  8, 5, 36, 1, 1) suite_2();
  BlimpV7TestSuite #(3,  2, 2, 48, 1, 1) suite_3();
  BlimpV7TestSuite #(4,  4, 3, 33, 1, 1) suite_4();
  BlimpV7TestSuite #(7,  4, 6, 52, 3, 3) suite_5();

  int s;

  initial begin
    test_bench_begin( `__FILE__ );
    s = get_test_suite();

    if ((s <= 0) || (s == 1)) suite_1.run_test_suite();
    if ((s <= 0) || (s == 2)) suite_2.run_test_suite();
    if ((s <= 0) || (s == 3)) suite_3.run_test_suite();
    if ((s <= 0) || (s == 4)) suite_4.run_test_suite();
    if ((s <= 0) || (s == 5)) suite_5.run_test_suite();

    test_bench_end();
  end
endmodule
