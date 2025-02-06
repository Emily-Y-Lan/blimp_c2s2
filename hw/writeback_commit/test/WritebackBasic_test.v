//========================================================================
// WritebackBasic_test.v
//========================================================================
// A testbench for our basic writeback-commit unit

`include "hw/writeback_commit/writeback_variants/WritebackBasic.v"
`include "test/fl/TestSub.v"
`include "test/fl/TestIstream.v"
`include "intf/CompleteNotif.v"
`include "intf/X__WIntf.v"
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
  ) X__W_intfs [p_num_pipes-1:0]();

  CompleteNotif #(
    .p_seq_num_bits (p_seq_num_bits),
    .p_data_bits    (p_data_bits)
  ) complete_notif();

  WritebackBasic #(
    .p_num_pipes (p_num_pipes)
  ) dut (
    .Ex        (Ex_intf),
    .writeback (writeback_notif),
    .complete  (complete_notif),
    .*
  );

  //----------------------------------------------------------------------
  // FL X Istreams
  //----------------------------------------------------------------------

  typedef struct packed {
    logic             [4:0] waddr;
    logic [p_data_bits-1:0] wdata;
    logic                   wen;
  } t_x__w_msg;

  t_x__w_msg x__w_msgs[p_num_pipes];

  genvar i;
  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin
      assign X__W_intfs[i].waddr = x__w_msgs[i].waddr;
      assign X__W_intfs[i].wdata = x__w_msgs[i].wdata;
      assign X__W_intfs[i].wen   = x__w_msgs[i].wen;
    end
  endgenerate

  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin: X_Istreams
      TestIstream #(
        .p_send_intv_delay (p_X_send_intv_delay)
      ) X_Istream (
        .msg (x__w_msgs[i]),
        .val (X__W_intfs[i].val),
        .rdy (X__W_intfs[i].rdy),
        .*
      );
    end
  endgenerate

  t_x__w_msg msgs_to_send [p_num_pipes-1:0][$];
  logic      msgs_done    [p_num_pipes];

  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin
      always_ff @( posedge clk ) begin
        foreach (msgs_to_send[i][j]) begin
          X_Istreams[i].X_Istream.send(
            msgs[i][j]
          );
        end
        
        msgs_to_send[i].delete();
        msgs_done[i] = 1'b1;
      end

      initial begin
        msgs_done[i] = 1'b1;
      end
    end
  endgenerate

  t_x__w_msg pipe_msg;

  task send(
    input int                     pipe_num,
    input logic             [4:0] waddr,
    input logic [p_data_bits-1:0] wdata,
    input logic                   wen
  );
    pipe_msg.waddr = waddr;
    pipe_msg.wdata = wdata;
    pipe_msg.wen   = wen;

    msgs[pipe_num].push_back( pipe_msg );
  endtask

  string X_traces [p_num_pipes-1:0];
  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin
      assign X_traces[i] = X_Istreams[i].X_Istream.trace;
    end
  endgenerate

  string X_trace;
  always_comb begin
    X_trace = "";
    for( int j = 0; j < p_num_pipes; j = j + 1 ) begin
      X_trace = { X_trace, X_traces[j], " " };
    end
  end

  //----------------------------------------------------------------------
  // Completion Test Subscriber
  //----------------------------------------------------------------------

  typedef struct packed {
    logic [p_seq_num_bits-1:0] seq_num;
    logic                [4:0] waddr;
    logic    [p_data_bits-1:0] wdata;
    logic                      wen;
  } t_complete_msg;

  t_complete_msg complete_msg;

  assign complete_msg.seq_num = complete_notif.seq_num;
  assign complete_msg.waddr   = complete_notif.waddr;
  assign complete_msg.wdata   = complete_notif.wdata;
  assign complete_msg.wen     = complete_notif.wen;

  TestSub #(
    t_complete_msg
  ) CommitSub (
    .msg (t_complete_msg),
    .val (complete_notif.val),
    .*
  );

  t_complete_msg msg_to_sub;

  task sub(
    input logic [p_seq_num_bits-1:0] seq_num,
    input logic                [4:0] waddr,
    input logic    [p_data_bits-1:0] wdata,
    input logic                      wen
  );
    msg_to_sub.seq_num = seq_num;
    msg_to_sub.waddr   = waddr;
    msg_to_sub.wdata   = wdata;
    msg_to_sub.wen     = wen;

    CommitSub.sub( msg_to_sub );
  endtask

  //----------------------------------------------------------------------
  // Trace the design
  //----------------------------------------------------------------------

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
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );
    if( t.n != 0 )
      tracer.enable_trace();

    fork
      begin
        //    pipe addr  data          wen
        send( 0,   5'h1, 32'hdeadbeef, 1'b1 );
        send( 0,   5'h2, 32'hcafecafe, 1'b1 );
      end

      begin
        
      end
    join

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

