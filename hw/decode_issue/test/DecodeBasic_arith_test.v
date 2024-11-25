//========================================================================
// DecodeBasic_test.v
//========================================================================
// A testbench for our basic decoder

`include "defs/ISA.v"
`include "hw/decode_issue/DecodeIssue.v"
`include "test/TraceUtils.v"
`include "test/fl/F__DTestF.v"
`include "test/fl/D__XTestX.v"

import ISA::*;
import TestEnv::*;

//========================================================================
// DecodeBasicTestSuite
//========================================================================
// A test suite for the basic decoder

module DecodeBasicTestSuite #(
  parameter p_suite_num  = 0,
  parameter p_num_pipes  = 3,
  parameter p_addr_bits  = 32,
  parameter p_inst_bits  = 32,
  parameter p_rst_addr   = 32'h0,

  parameter p_F_send_intv_delay = 0,
  parameter p_X_recv_intv_delay = 0,

  parameter rv_op_vec [p_num_pipes-1:0] p_pipe_subsets = '{default: p_tinyrv1}
);

  string suite_name = $sformatf("%0d: DecodeBasicTestSuite_%0d_%0d_%0d_%0d_%0d_%0d", 
                                p_suite_num, p_num_pipes, p_addr_bits, 
                                p_inst_bits, p_rst_addr,
                                p_F_send_intv_delay, p_X_recv_intv_delay);

  initial begin
    for( int i = 0; i < p_num_pipes; i = i + 1 ) begin
      suite_name = $sformatf("%s_%h", suite_name, p_pipe_subsets[i]);
    end
  end

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
    .p_addr_bits (p_addr_bits),
    .p_data_bits (p_inst_bits)
  ) Ex_intf [p_num_pipes-1:0]();

  DecodeIssue #(
    .p_decode_issue_type ("basic_tinyrv1"),
    .p_num_pipes         (p_num_pipes),
    .p_pipe_subsets      (p_pipe_subsets)
  ) dut (
    .F  (F__D_intf),
    .Ex (Ex_intf),
    .*
  );

  F__DTestF #(
    .p_send_intv_delay (p_F_send_intv_delay),
    .p_rst_addr        (p_rst_addr)
  ) fl_F_test_intf (
    .dut (F__D_intf),
    .*
  );

  genvar i;
  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin: fl_X
      D__XTestX #(
        .p_dut_intv_delay (p_X_recv_intv_delay)
      ) fl_test_intf (
        .dut (Ex_intf[i]),
        .*
      );
    end
  endgenerate

  //----------------------------------------------------------------------
  // Trace the design
  //----------------------------------------------------------------------

  string fl_X_traces [p_num_pipes-1:0];
  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin
      assign fl_X_traces[i] = fl_X[i].fl_test_intf.trace;
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
    fl_F_test_intf.trace,
    " | ",
    dut.trace,
    " | ",
    fl_X_trace
  } );

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

  typedef struct {
    logic [p_addr_bits-1:0] exp_pc;
    logic [p_inst_bits-1:0] exp_op1;
    logic [p_inst_bits-1:0] exp_op2;
    logic             [4:0] exp_waddr;
    rv_uop                  exp_uop;
    logic                   dut_squash;
    logic [p_addr_bits-1:0] dut_branch_target;
  } X_msg;

  X_msg msgs [p_num_pipes-1:0][$];

  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin
      always_ff @( posedge clk ) begin
        foreach (msgs[i][j])
          fl_X[i].fl_test_intf.add_msg(
            msgs[i][j].exp_pc,
            msgs[i][j].exp_op1,
            msgs[i][j].exp_op2,
            msgs[i][j].exp_waddr,
            msgs[i][j].exp_uop,
            msgs[i][j].dut_squash,
            msgs[i][j].dut_branch_target
          );
        
        msgs[i].delete();
      end
    end
  endgenerate

  int   pipe_delays [p_num_pipes];
  int   pipe_found, first_iter;
  X_msg pipe_msg;

  always_ff @( posedge clk ) begin
    if( rst ) begin
      pipe_delays <= '{default: 0};
    end
  end

  task add_msg(
    input logic [p_addr_bits-1:0] exp_pc,
    input logic [p_inst_bits-1:0] exp_op1,
    input logic [p_inst_bits-1:0] exp_op2,
    input logic             [4:0] exp_waddr,
    input rv_uop                  exp_uop,
    input logic                   dut_squash,
    input logic [p_addr_bits-1:0] dut_branch_target
  );
    // Set message correctly
    pipe_msg.exp_pc            = exp_pc;
    pipe_msg.exp_op1           = exp_op1;
    pipe_msg.exp_op2           = exp_op2;
    pipe_msg.exp_waddr         = exp_waddr;
    pipe_msg.exp_uop           = exp_uop;
    pipe_msg.dut_squash        = dut_squash;
    pipe_msg.dut_branch_target = dut_branch_target;

    pipe_found = 0;
    first_iter = 1;
    while( pipe_found == 0 ) begin
      // Decrement all delays
      for( int j = 0; j < p_num_pipes; j = j + 1 ) begin
        if( pipe_delays[j] > 0 ) begin
          if(( first_iter == 1 ) & (p_F_send_intv_delay > 1)) begin
            pipe_delays[j] = pipe_delays[j] - p_F_send_intv_delay;
            first_iter = 0;
          end else begin
            pipe_delays[j] = pipe_delays[j] - 1;
          end
          if( pipe_delays[j] < 0 ) pipe_delays[j] = 0;
        end
      end

      // Find correct pipe
      for( int j = 0; j < p_num_pipes; j = j + 1 ) begin
        if(( (p_pipe_subsets[j] & vec_of_uop(exp_uop)) > 0 ) & ( pipe_delays[j] == 0 )) begin
          msgs[j].push_back( pipe_msg );
          pipe_delays[j] = p_X_recv_intv_delay;
          pipe_found = 1;
          break;
        end
      end
    end
  endtask

  //----------------------------------------------------------------------
  // Keep track of whether we're done
  //----------------------------------------------------------------------
  // Must use intermediate with a generate statement to have constant
  // indexing into interface array

  logic [p_num_pipes-1:0] pipe_done;

  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin
      always_ff @( posedge clk ) begin
        if( rst )
          pipe_done[i] <= 1'b0;
        else
          pipe_done[i] <= fl_X[i].fl_test_intf.done();
      end
    end
  endgenerate

  function logic done;
    return &pipe_done;
  endfunction

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );
    if( t.n != 0 )
      tracer.enable_trace();

    //                       addr                                        inst
    fl_F_test_intf.add_inst( p_addr_bits'(p_rst_addr + p_addr_bits'(0)), "mul x1, x0, x0" );
    fl_F_test_intf.add_inst( p_addr_bits'(p_rst_addr + p_addr_bits'(4)), "addi x1, x0, 10" );

    //       pc                                          op1    op2    waddr  uop     sq br_tar
    add_msg( p_addr_bits'(p_rst_addr + p_addr_bits'(0)), 32'h0, 32'h0, 5'h1,  OP_MUL, 0, 'x );
    add_msg( p_addr_bits'(p_rst_addr + p_addr_bits'(4)), 32'h0, 32'hA, 5'h1,  OP_ADD, 0, 'x );
    while( !done() ) begin
      #10;
    end
    tracer.disable_trace();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_add
  //----------------------------------------------------------------------

  task test_case_2_add();
    t.test_case_begin( "test_case_2_add" );
    if( t.n != 0 )
      tracer.enable_trace();
  
    //                       addr                                        inst
    fl_F_test_intf.add_inst( p_addr_bits'(p_rst_addr + p_addr_bits'(0)), "add x3, x1, x2" );
    fl_F_test_intf.add_inst( p_addr_bits'(p_rst_addr + p_addr_bits'(4)), "add x2, x5, x4" );
  
    //       pc                                          op1    op2    waddr  uop     sq br_tar
    add_msg( p_addr_bits'(p_rst_addr + p_addr_bits'(0)), 32'h0, 32'h0, 5'h3,  OP_ADD, 0, 'x );
    add_msg( p_addr_bits'(p_rst_addr + p_addr_bits'(4)), 32'h0, 32'h0, 5'h2,  OP_ADD, 0, 'x );
    while( !done() ) begin
      #10;
    end
    tracer.disable_trace();
  endtask

  //----------------------------------------------------------------------
  // test_case_3_addi
  //----------------------------------------------------------------------

  task test_case_3_addi();
    t.test_case_begin( "test_case_3_addi" );
    if( t.n != 0 )
      tracer.enable_trace();
  
    //                       addr                                        inst
    fl_F_test_intf.add_inst( p_addr_bits'(p_rst_addr + p_addr_bits'(0)), "addi x3, x1, 10" );
    fl_F_test_intf.add_inst( p_addr_bits'(p_rst_addr + p_addr_bits'(4)), "addi x2, x5, 2047" );
  
    //       pc                                          op1    op2      waddr  uop     sq br_tar
    add_msg( p_addr_bits'(p_rst_addr + p_addr_bits'(0)), 32'h0, 32'hA,   5'h3,  OP_ADD, 0, 'x );
    add_msg( p_addr_bits'(p_rst_addr + p_addr_bits'(4)), 32'h0, 32'h7FF, 5'h2,  OP_ADD, 0, 'x );
    while( !done() ) begin
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
    if ((t.n <= 0) || (t.n == 2)) test_case_2_add();
    if ((t.n <= 0) || (t.n == 2)) test_case_3_addi();

  endtask
endmodule

//========================================================================
// DecodeBasic_test
//========================================================================

module DecodeBasic_test;
  DecodeBasicTestSuite #(1)                                                  suite_1();
  DecodeBasicTestSuite #(2, 2, 32, 32, 32'h0, 0, 0, {p_tinyrv1, OP_ADD_VEC}) suite_2();
  DecodeBasicTestSuite #(3, 5, 32, 32, 32'h0, 0, 0, {
    p_tinyrv1, 
    p_tinyrv1, 
    p_tinyrv1, 
    p_tinyrv1, 
    OP_MUL_VEC
  }) suite_3();
  DecodeBasicTestSuite #(4, 1, 32, 32, 32'h0, 0, 0, {p_tinyrv1}            ) suite_4();
  DecodeBasicTestSuite #(5, 3, 32, 32, 32'h0, 3, 0, {
    p_tinyrv1, 
    p_tinyrv1, 
    p_tinyrv1
  }) suite_5();
  DecodeBasicTestSuite #(6, 3, 32, 32, 32'h0, 0, 3, {
    p_tinyrv1, 
    p_tinyrv1, 
    p_tinyrv1
  }) suite_6();
  DecodeBasicTestSuite #(7, 3, 32, 32, 32'h0, 3, 3, {
    p_tinyrv1, 
    p_tinyrv1, 
    p_tinyrv1
  }) suite_7();

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
