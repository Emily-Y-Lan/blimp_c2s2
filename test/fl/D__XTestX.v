//========================================================================
// D__XTestX.v
//========================================================================
// A FL model of the Execute interface, to use in testing

`ifndef TEST_FL_D__X_TEST_X_V
`define TEST_FL_D__X_TEST_X_V

`include "defs/UArch.v"
`include "hw/util/DelayStream.v"
`include "intf/D__XIntf.v"
`include "test/FLTestUtils.v"

import UArch::*;

module D__XTestX #(
  parameter p_dut_intv_delay = 0
)(
  input logic clk,
  input logic rst,
  
  D__XIntf.X_intf dut
);

  FLTestUtils t( .* );

  localparam p_addr_bits = dut.p_addr_bits;
  localparam p_data_bits = dut.p_data_bits;

  //----------------------------------------------------------------------
  // Store expected results in queue
  //----------------------------------------------------------------------

  typedef struct {
    logic [p_addr_bits-1:0] exp_pc;
    logic [p_data_bits-1:0] exp_op1;
    logic [p_data_bits-1:0] exp_op2;
    logic             [4:0] exp_waddr;
    rv_uop                  exp_uop;
    logic                   dut_squash;
    logic [p_addr_bits-1:0] dut_branch_target;
  } transaction;

  transaction transaction_queue [$];

  always_ff @( posedge clk ) begin
    if( rst )
      transaction_queue.delete();
  end

  transaction new_transaction;

  // verilator lint_off BLKSEQ
  task add_msg(
    input logic [p_addr_bits-1:0] exp_pc,
    input logic [p_data_bits-1:0] exp_op1,
    input logic [p_data_bits-1:0] exp_op2,
    input logic             [4:0] exp_waddr,
    input rv_uop                  exp_uop,
    input logic                   dut_squash,
    input logic [p_addr_bits-1:0] dut_branch_target
  );
    new_transaction.exp_pc            = exp_pc;
    new_transaction.exp_op1           = exp_op1;
    new_transaction.exp_op2           = exp_op2;
    new_transaction.exp_uop           = exp_uop;
    new_transaction.exp_waddr         = exp_waddr;
    new_transaction.dut_squash        = dut_squash;
    new_transaction.dut_branch_target = dut_branch_target;

    transaction_queue.push_back( new_transaction );
  endtask
  // verilator lint_on BLKSEQ

  function logic done();
    done = ( transaction_queue.size() == 0 );
  endfunction

  //----------------------------------------------------------------------
  // Store incoming messages in a queue
  //----------------------------------------------------------------------

  typedef struct packed {
    logic [p_addr_bits-1:0] pc;
    logic [p_data_bits-1:0] op1;
    logic [p_data_bits-1:0] op2;
    logic             [4:0] waddr;
    rv_uop                  uop;
  } dut_input;

  dut_input curr_input;
  assign curr_input.pc    = dut.pc;
  assign curr_input.op1   = dut.op1;
  assign curr_input.op2   = dut.op2;
  assign curr_input.waddr = dut.waddr;
  assign curr_input.uop   = dut.uop;

  // verilator lint_off PINCONNECTEMPTY

  DelayStream #(
    .t_msg             (dut_input),
    .p_send_intv_delay (p_dut_intv_delay)
  ) dut_queue (
    .clk (clk),
    .rst (rst),

    .send_val (dut.val),
    .send_rdy (dut.rdy),
    .send_msg (curr_input),

    .recv_val (),
    .recv_rdy (1'b0),
    .recv_msg ()
  );

  // verilator lint_on PINCONNECTEMPTY

  //----------------------------------------------------------------------
  // Check messages, assign squash/target
  //----------------------------------------------------------------------

  dut_input   actual_msg;
  transaction exp_msg;
  logic       processing_msg;

  initial begin
    dut.squash        = 1'b0;
    dut.branch_target = 'x;
    processing_msg    = 1'b0;
  end
  
  // verilator lint_off BLKSEQ

  always_ff @( posedge clk ) begin
    #1;
    if( rst ) begin
      dut.squash        = 1'b0;
      dut.branch_target = 'x;
    end
    else begin
      if( !done() & (dut_queue.num_msgs() > 0) ) begin
        actual_msg     = dut_queue.dequeue();
        exp_msg        = transaction_queue.pop_front();
        processing_msg = 1'b1;

        // Set squash/branch target
        dut.squash        = exp_msg.dut_squash;
        dut.branch_target = exp_msg.dut_branch_target;

        #2;

        // Check the actual vs expectation
        `CHECK_EQ( actual_msg.pc,    exp_msg.exp_pc    );
        `CHECK_EQ( actual_msg.op1,   exp_msg.exp_op1   );
        `CHECK_EQ( actual_msg.op2,   exp_msg.exp_op2   );
        `CHECK_EQ( actual_msg.waddr, exp_msg.exp_waddr );
        `CHECK_EQ( actual_msg.uop,   exp_msg.exp_uop   );
        
        processing_msg = 1'b0;
      end else begin
        dut.squash        = 1'b0;
        dut.branch_target = 'x;
      end
    end
  end

  // verilator lint_on BLKSEQ

  //----------------------------------------------------------------------
  // Linetrace
  //----------------------------------------------------------------------

  function int ceil_div_4( int val );
    return (val / 4) + (val % 4);
  endfunction

  // verilator lint_off UNUSEDSIGNAL
  string trace;
  // verilator lint_on UNUSEDSIGNAL

  // verilator lint_off BLKSEQ
  always_comb begin
    if( processing_msg )
      trace = $sformatf("%-11s", actual_msg.uop.name());
    else
      trace = {11{" "}};

    trace = {trace, " "};

    if( processing_msg & exp_msg.dut_squash )
      trace = {trace, $sformatf("(%h)", exp_msg.dut_branch_target)};
    else
      trace = {trace, $sformatf("(%s)", {ceil_div_4(p_addr_bits){" "}})};
  end
  // verilator lint_on BLKSEQ

endmodule

`endif // TEST_FL_D__X_TEST_X_V
