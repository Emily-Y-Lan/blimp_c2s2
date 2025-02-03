//========================================================================
// WritebackBasic_test.v
//========================================================================
// A testbench for our basic writeback-commit unit

`include "hw/writeback_commit/writeback_variants/WritebackBasic.v"
`include "test/fl/CommitTestSub.v"
`include "test/fl/WritebackTestSub.v"
`include "test/fl/X__WTestX.v"
`include "test/TestUtils.v"
`include "test/TraceUtils.v"

import TestEnv::*;

//========================================================================
// WritebackBasicTestSuite
//========================================================================
// A test suite for the writeback-commit unit

module WritebackBasicTestSuite #(
  parameter p_suite_num    = 0,
  parameter p_num_pipes    = 1,
  parameter p_addr_bits    = 32,
  parameter p_data_bits    = 32,
  parameter p_seq_num_bits = 8,

  parameter p_X_send_intv_delay = 0
);

  //verilator lint_off UNUSEDSIGNAL
  string suite_name = $sformatf("%0d: WritebackBasicTestSuite_%0d_%0d_%0d_%0d_%0d", 
                                p_suite_num, p_num_pipes,
                                p_addr_bits, p_data_bits, p_seq_num_bits,
                                p_X_send_intv_delay);
  //verilator lint_on UNUSEDSIGNAL

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk, rst;
  TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  X__WIntf #(
    .p_data_bits (p_data_bits)
  ) Ex_intf [p_num_pipes-1:0]();

  WritebackNotif #(
    .p_data_bits (p_data_bits)
  ) writeback_notif();

  CommitNotif #(
    .p_seq_num_bits (p_seq_num_bits),
    .p_data_bits    (p_data_bits)
  ) commit_notif();

  WritebackBasic #(
    .p_num_pipes (p_num_pipes)
  ) dut (
    .Ex        (Ex_intf),
    .writeback (writeback_notif),
    .commit    (commit_notif),
    .*
  );

  genvar i;
  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin: fl_X
      X__WTestX #(
        .p_send_intv_delay (p_X_send_intv_delay)
      ) fl_X_test (
        .dut (Ex_intf[i]),
        .*
      );
    end
  endgenerate

  WritebackTestSub fl_writeback_test_sub (
    .dut (writeback_notif),
    .*
  );

  CommitTestSub fl_commit_test_sub (
    .dut (commit_notif),
    .*
  );

  //----------------------------------------------------------------------
  // Trace the design
  //----------------------------------------------------------------------

  string fl_X_traces [p_num_pipes-1:0];
  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin
      assign fl_X_traces[i] = fl_X[i].fl_X_test.trace;
    end
  endgenerate

  string fl_X_trace;
  always_comb begin
    fl_X_trace = "";
    for( int j = 0; j < p_num_pipes; j = j + 1 ) begin
      fl_X_trace = { fl_X_trace, fl_X_traces[j], " " };
    end
  end

  Tracer tracer ( clk, {
    fl_X_trace,
    " | ",
    dut.trace,
    " | ",
    fl_writeback_test_sub.trace,
    " - ",
    fl_commit_test_sub.trace
  } );

  //----------------------------------------------------------------------
  // Handle giving messages to the correct pipe
  //----------------------------------------------------------------------

  typedef struct {
    logic             [4:0] exp_waddr;
    logic [p_data_bits-1:0] exp_wdata;
    logic                   exp_wen;
  } X_msg;

  X_msg msgs [p_num_pipes-1:0][$];

  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin
      always_ff @( posedge clk ) begin
        foreach (msgs[i][j])
          fl_X[i].fl_X_test.add_msg(
            msgs[i][j].exp_waddr,
            msgs[i][j].exp_wdata,
            msgs[i][j].exp_wen
          );
        
        msgs[i].delete();
      end
    end
  endgenerate

  X_msg pipe_msg;

  task add_msg(
    // verilator lint_off UNUSEDSIGNAL
    input int                     pipe_num,
    // verilator lint_on UNUSEDSIGNAL

    input logic             [4:0] exp_waddr,
    input logic [p_data_bits-1:0] exp_wdata,
    input logic                   exp_wen
  );
    pipe_msg.exp_waddr = exp_waddr;
    pipe_msg.exp_wdata = exp_wdata;
    pipe_msg.exp_wen   = exp_wen;

    msgs[pipe_num].push_back( pipe_msg );
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );
    if( t.n != 0 )
      tracer.enable_trace();

    //       pipe addr  data          wen
    add_msg( 0,   5'h1, 32'hdeadbeef, 1'b1 );
    add_msg( 0,   5'h2, 32'hcafecafe, 1'b1 );

    //                             addr, data
    fl_writeback_test_sub.add_msg( 5'h1, 32'hdeadbeef );
    fl_writeback_test_sub.add_msg( 5'h2, 32'hcafecafe );
    while( !fl_writeback_test_sub.done() | !fl_commit_test_sub.done() ) begin
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

  endtask
endmodule

//========================================================================
// WritebackBasic_test
//========================================================================

module WritebackBasic_test;
  WritebackBasicTestSuite #(1) suite_1();

  int s;

  initial begin
    test_bench_begin( `__FILE__ );
    s = get_test_suite();

    if ((s <= 0) || (s == 1)) suite_1.run_test_suite();

    test_bench_end();
  end
endmodule

