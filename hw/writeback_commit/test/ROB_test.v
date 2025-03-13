//========================================================================
// ROB_test.v
//========================================================================
// A testbench for our basic writeback-commit unit

`include "hw/writeback_commit/ROB.v"
`include "test/TestUtils.v"

import TestEnv::*;

//========================================================================
// ROBTestSuite
//========================================================================
// A test suite for the ROB

module ROBTestSuite #(
  parameter p_suite_num      = 0,
  parameter type t_entry     = t_rob_data,
  parameter p_depth          = 4
);

  //verilator lint_off UNUSEDSIGNAL
  string suite_name = $sformatf("%0d: ROBTestSuite_%0d_%0d", 
                                p_suite_num, $bits(t_rob_data), p_depth);
  //verilator lint_on UNUSEDSIGNAL

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk, rst;
  TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic                  deq_front_en;
  logic                  deq_front_rdy;
  t_entry deq_front_data;

  logic   ins_en;
  logic   ins_rdy;
  t_entry ins_data;

  ROB #(
    .p_depth (p_depth)
  ) dut (
    .*
  );

  //----------------------------------------------------------------------
  // FL Istreams
  //----------------------------------------------------------------------

  logic msg_sent;

  task send(
    t_entry      l_ins_data
  );
    ins_data = l_ins_data;
    ins_en   = 1'b1;

    do begin
      #2
      msg_sent = ins_rdy;
      @( posedge clk );
      #1;
    end while( !msg_sent );

    ins_en = 1'b0;
  endtask

  //----------------------------------------------------------------------
  // FL Ostreams
  //---------------------------------------------------------------------- 

  logic msg_recv;
  t_entry dut_msg;

  task recv(
    input t_entry exp_deq_front_data
  );
    deq_front_en = 1'b1;

    do begin
      #2
      msg_recv = deq_front_rdy;
      dut_msg  = deq_front_data;
      @( posedge clk );
      #1;
    end while( !msg_recv );

    `CHECK_EQ( dut_msg, exp_deq_front_data );
    
    deq_front_en = 1'b0;
  endtask

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

  string trace, test_trace;
  int trace_len;

  // verilator lint_off BLKSEQ
  always_ff @( posedge clk ) begin
    #2;
    trace = "";
    test_trace = $sformatf("t:%x, d:%x", ins_data, ins_data);
    trace_len = test_trace.len();

    if( ins_en && ins_rdy )
      trace = $sformatf("t:%x, d:%x", ins_data, ins_data);
    else if( ins_rdy )
      trace = {(trace_len){" "}};
    else if( ins_en )
      trace = {{(trace_len-1){" "}}, "#"};
    else
      trace = {{(trace_len-1){" "}}, "."};
    trace = {trace, " | "};
    trace = {trace, dut.trace()};
    trace = {trace, " | "};
    if( deq_front_en & deq_front_rdy )
      trace = {trace, $sformatf("%x", deq_front_data)};
    else if( deq_front_rdy )
      trace = {trace, {(trace_len){" "}}};
    else if( deq_front_en )
      trace = {trace, {{(trace_len-1){" "}}, "#"}};
    else
      trace = {trace, {{(trace_len-1){" "}}, "."}};

    t.trace( trace );
  end
  // verilator lint_on BLKSEQ

  //----------------------------------------------------------------------
  // Include test cases
  //----------------------------------------------------------------------

  `include "hw/writeback_commit/test/test_cases/rob_test_cases.v"

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  task run_test_suite();
    t.test_suite_begin( suite_name );

    run_rob_test_cases();
  endtask


endmodule

//========================================================================
// ROB_test
//========================================================================

module ROB_test;
  ROBTestSuite #(1) suite_1();

  int s;

  initial begin
    test_bench_begin( `__FILE__ );
    s = get_test_suite();

    if ((s <= 0) || (s == 1)) suite_1.run_test_suite();

    test_bench_end();
  end
endmodule
