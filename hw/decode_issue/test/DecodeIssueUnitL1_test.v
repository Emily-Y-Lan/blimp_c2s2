//========================================================================
// DecodeIssueUnitL1_test.v
//========================================================================
// A testbench for our basic decode-issue unit

`include "defs/UArch.v"
`include "hw/decode_issue/decode_issue_unit_variants/DecodeIssueUnitL1.v"
`include "test/asm/rv32/assemble32.v"
`include "test/fl/TestPub.v"
`include "test/fl/TestIstream.v"
`include "test/fl/TestOstream.v"

import UArch::*;
import TestEnv::*;

//========================================================================
// DecodeIssueUnitL1TestSuite
//========================================================================
// A test suite for the basic decoder

module DecodeIssueUnitL1TestSuite #(
  parameter p_suite_num   = 0,
  parameter p_num_pipes   = 3,
  parameter p_addr_bits   = 32,
  parameter p_inst_bits   = 32,
  parameter p_rob_entries = 32,
  parameter p_rst_addr    = 32'h0,

  parameter p_F_send_intv_delay = 0,
  parameter p_X_recv_intv_delay = 0,

  parameter rv_op_vec [p_num_pipes-1:0] p_pipe_subsets = '{default: p_tinyrv1}
);

  string suite_name = $sformatf("%0d: DecodeIssueUnitL1TestSuite_%0d_%0d_%0d_%0d_%0d_%0d", 
                                p_suite_num, p_num_pipes, p_addr_bits, 
                                p_inst_bits, p_rst_addr,
                                p_F_send_intv_delay, p_X_recv_intv_delay);

  initial begin
    for( int i = 0; i < p_num_pipes; i = i + 1 ) begin
      suite_name = $sformatf("%s_%h", suite_name, p_pipe_subsets[i]);
    end
  end

  localparam p_seq_num_bits = $clog2( p_rob_entries );

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk, rst;
  TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------
  // Here, we additionally use virtual fl_X interfaces to allow for
  // non-constant indexing

  F__DIntf #(
    .p_addr_bits (p_addr_bits),
    .p_inst_bits (p_inst_bits)
  ) F__D_intf();

  D__XIntf #(
    .p_addr_bits    (p_addr_bits),
    .p_data_bits    (p_inst_bits),
    .p_seq_num_bits (p_seq_num_bits)
  ) D__X_intfs [p_num_pipes-1:0]();

  CompleteNotif #(
    .p_seq_num_bits (p_seq_num_bits),
    .p_data_bits    (p_inst_bits)
  ) complete_notif();

  DecodeIssueUnitL1 #(
    .p_isa_subset   (p_tinyrv1),
    .p_num_pipes    (p_num_pipes),
    .p_pipe_subsets (p_pipe_subsets)
  ) dut (
    .F        (F__D_intf),
    .Ex       (D__X_intfs),
    .complete (complete_notif),
    .*
  );

  //----------------------------------------------------------------------
  // FL D Interface
  //----------------------------------------------------------------------

  typedef struct packed {
    logic [p_inst_bits-1:0] inst;
    logic [p_addr_bits-1:0] pc;
  } t_f__d_msg;

  t_f__d_msg f__d_msg;

  assign F__D_intf.inst  = f__d_msg.inst;
  assign F__D_intf.pc    = f__d_msg.pc;

  TestIstream #( t_f__d_msg, p_F_send_intv_delay ) F_Istream (
    .msg (f__d_msg),
    .val (F__D_intf.val),
    .rdy (F__D_intf.rdy),
    .*
  );

  t_f__d_msg msg_to_send;

  task send(
    input logic [p_addr_bits-1:0] pc,
    input logic [p_inst_bits-1:0] inst
  );
    msg_to_send.inst  = inst;
    msg_to_send.pc    = pc;

    F_Istream.send(msg_to_send);
  endtask

  //----------------------------------------------------------------------
  // FL X Interfaces
  //----------------------------------------------------------------------

  typedef struct packed {
    logic [p_addr_bits-1:0] pc;
    logic [p_inst_bits-1:0] op1;
    logic [p_inst_bits-1:0] op2;
    logic             [4:0] waddr;
    rv_uop                  uop;
  } t_d__x_msg;

  t_d__x_msg                 d__x_msgs       [p_num_pipes];
  logic [p_seq_num_bits-1:0] unused_seq_nums [p_num_pipes];

  genvar i;
  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin
      assign d__x_msgs[i].pc    = D__X_intfs[i].pc;
      assign d__x_msgs[i].op1   = D__X_intfs[i].op1;
      assign d__x_msgs[i].op2   = D__X_intfs[i].op2;
      assign d__x_msgs[i].waddr = D__X_intfs[i].waddr;
      assign d__x_msgs[i].uop   = D__X_intfs[i].uop;
      assign unused_seq_nums[i] = D__X_intfs[i].seq_num;
    end
  endgenerate

  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin: X_Ostreams
      TestOstream #( t_d__x_msg, p_X_recv_intv_delay ) X_Ostream (
        .msg (d__x_msgs[i]),
        .val (D__X_intfs[i].val),
        .rdy (D__X_intfs[i].rdy),
        .*
      );
    end
  endgenerate

  //----------------------------------------------------------------------
  // Completion Interface
  //----------------------------------------------------------------------

  typedef struct packed {
    logic [p_seq_num_bits-1:0] seq_num;
    logic                [4:0] waddr;
    logic    [p_inst_bits-1:0] wdata;
    logic                      wen;
  } t_complete_msg;

  t_complete_msg complete_msg;

  assign complete_notif.seq_num = complete_msg.seq_num;
  assign complete_notif.waddr   = complete_msg.waddr;
  assign complete_notif.wdata   = complete_msg.wdata;
  assign complete_notif.wen     = complete_msg.wen;

  TestPub #(
    t_complete_msg
  ) CommitPub (
    .msg (complete_msg),
    .val (complete_notif.val),
    .*
  );

  t_complete_msg msg_to_pub;

  task pub(
    input logic [p_seq_num_bits-1:0] seq_num,
    input logic                [4:0] waddr,
    input logic    [p_inst_bits-1:0] wdata,
    input logic                      wen
  );
    msg_to_pub.seq_num = seq_num;
    msg_to_pub.waddr   = waddr;
    msg_to_pub.wdata   = wdata;
    msg_to_pub.wen     = wen;

    CommitPub.pub( msg_to_pub );
  endtask

  //----------------------------------------------------------------------
  // Handle giving messages to the correct pipe
  //----------------------------------------------------------------------

  function rv_op_vec vec_of_uop (input rv_uop uop);
    if( uop == OP_ADD  ) return OP_ADD_VEC;
    if( uop == OP_MUL  ) return OP_MUL_VEC;
    if( uop == OP_LW   ) return OP_LW_VEC;
    if( uop == OP_SW   ) return OP_SW_VEC;
    if( uop == OP_JAL  ) return OP_JAL_VEC;
    if( uop == OP_JALR ) return OP_JALR_VEC;
    if( uop == OP_BNE  ) return OP_BNE_VEC;
  endfunction

  t_d__x_msg msgs_to_recv     [p_num_pipes];
  logic      msgs_to_recv_val [p_num_pipes];

  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin
      always_ff @( posedge clk ) begin
        #1;
        if (msgs_to_recv_val[i]) begin
          X_Ostreams[i].X_Ostream.recv(
            msgs_to_recv[i]
          );
        end

        // verilator lint_off BLKSEQ
        msgs_to_recv_val[i] = 1'b0;
        // verilator lint_on BLKSEQ
      end

      initial begin
        msgs_to_recv_val[i] = 1'b0;
      end
    end
  endgenerate

  int        pipe_delays [p_num_pipes];
  int        pipe_found, first_iter;
  t_d__x_msg pipe_msg;

  always_ff @( posedge clk ) begin
    if( rst ) begin
      pipe_delays <= '{default: 0};
    end
  end

  task recv(
    input logic [p_addr_bits-1:0] pc,
    input logic [p_inst_bits-1:0] op1,
    input logic [p_inst_bits-1:0] op2,
    input logic             [4:0] waddr,
    input rv_uop                  uop,
  );
    // Set message correctly
    pipe_msg.pc    = pc;
    pipe_msg.op1   = op1;
    pipe_msg.op2   = op2;
    pipe_msg.waddr = waddr;
    pipe_msg.uop   = uop;

    pipe_found = 0;
    first_iter = 1;
    while( pipe_found == 0 ) begin
      // Decrement all delays
      for( int j = 0; j < p_num_pipes; j = j + 1 ) begin
        if( pipe_delays[j] > 0 ) begin
          if(( first_iter == 1 ) & (p_F_send_intv_delay > 1)) begin
            pipe_delays[j] = pipe_delays[j] - p_F_send_intv_delay;
          end else begin
            pipe_delays[j] = pipe_delays[j] - 1;
          end
          if( pipe_delays[j] < 0 ) pipe_delays[j] = 0;
        end
      end

      if( first_iter == 1 ) first_iter = 0;

      // Find correct pipe
      for( int j = 0; j < p_num_pipes; j = j + 1 ) begin
        if(( (p_pipe_subsets[j] & vec_of_uop(uop)) > 0 ) & ( pipe_delays[j] == 0 )) begin
          msgs_to_recv[j]     = pipe_msg;
          msgs_to_recv_val[j] = 1'b1;

          wait(msgs_to_recv_val[j] == 1'b0);
          pipe_delays[j] = p_X_recv_intv_delay;
          pipe_found = 1;
          break;
        end
      end
    end
  endtask

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

  string X_traces [p_num_pipes-1:0];
  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin
      // verilator lint_off BLKSEQ
      always_ff @( posedge clk ) begin
        #2;
        X_traces[i] = X_Ostreams[i].X_Ostream.trace();
      end
      // verilator lint_on BLKSEQ
    end
  endgenerate

  // Need to store other traces, to be aligned with X_Ostream traces
  string trace;
  string F_Istream_trace;
  string dut_trace;

  // verilator lint_off BLKSEQ
  always_ff @( posedge clk ) begin
    #2;
    F_Istream_trace = F_Istream.trace();
    dut_trace       = dut.trace();

    // Wait until X_Ostream traces are ready
    #1;
    trace = "";

    trace = {trace, F_Istream_trace};
    trace = {trace, " | "};
    trace = {trace, dut_trace};
    trace = {trace, " | "};
    for( int j = 0; j < p_num_pipes; j++ ) begin
      if( j > 0 )
        trace = {trace, " "};
      trace = {trace, X_traces[j]};
    end
    
    t.trace( trace );
  end
  // verilator lint_on BLKSEQ

  //----------------------------------------------------------------------
  // Include test cases
  //----------------------------------------------------------------------

  `include "hw/decode_issue/test/test_cases/basic_test_cases.v"
  `include "hw/decode_issue/test/test_cases/arith_test_cases.v"

  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  task run_test_suite();
    t.test_suite_begin( suite_name );

    run_basic();
    run_arith_l1();

  endtask
endmodule

//========================================================================
// DecodeIssueUnitL1_test
//========================================================================

module DecodeIssueUnitL1_test;
  DecodeIssueUnitL1TestSuite #(1) suite_1();
  DecodeIssueUnitL1TestSuite #(
    2, 
    2, 
    32, 
    32, 
    16, 
    32'h0, 
    0, 
    0, 
    {p_tinyrv1, OP_ADD_VEC}) 
  suite_2();
  DecodeIssueUnitL1TestSuite #(3, 
    5, 
    32, 
    32, 
    256, 
    32'h0, 
    0, 
    0, 
    {
      p_tinyrv1, 
      p_tinyrv1, 
      p_tinyrv1, 
      p_tinyrv1, 
      OP_MUL_VEC
    }
  ) suite_3();
  DecodeIssueUnitL1TestSuite #(
    4, 
    1, 
    32, 
    32, 
    8, 
    32'h0, 
    0, 
    0, 
    {p_tinyrv1}
  ) suite_4();
  DecodeIssueUnitL1TestSuite #(
    5, 
    3, 
    32, 
    32, 
    64, 
    32'h0, 
    3, 
    0, 
    {
      p_tinyrv1, 
      p_tinyrv1, 
      p_tinyrv1
    }
  ) suite_5();
  DecodeIssueUnitL1TestSuite #(
    6, 
    3, 
    32, 
    32, 
    128, 
    32'h0, 
    0, 
    3, 
    {
      p_tinyrv1, 
      p_tinyrv1, 
      p_tinyrv1
    }
  ) suite_6();
  DecodeIssueUnitL1TestSuite #(
    7, 
    3, 
    32, 
    32, 
    8, 
    32'h0, 
    3, 
    3, 
    {
      p_tinyrv1, 
      p_tinyrv1, 
      p_tinyrv1
    }
  ) suite_7();

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

    test_bench_end();
  end
endmodule
