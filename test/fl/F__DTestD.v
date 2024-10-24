//========================================================================
// F__DTestD.v
//========================================================================
// A FL model of the Decode interface, to use in testing

`include "hw/util/DelayStream.v"
`include "intf/F__DIntf.v"
`include "test/FLTestUtils.v"

`ifndef TEST_FL_F__D_TEST_D_V
`define TEST_FL_F__D_TEST_D_V

module F__DTestD #(
  parameter p_dut_intv_delay = 0,

  parameter p_addr_bits = 32,
  parameter p_inst_bits = 32
)(
  input logic clk,
  input logic rst,
  
  F__DIntf.D_intf dut
);

  FLTestUtils t( .* );
  
  //----------------------------------------------------------------------
  // Store expected results in queue
  //----------------------------------------------------------------------

  typedef struct {
    logic [p_inst_bits-1:0] exp_inst;
    logic [p_addr_bits-1:0] exp_pc;
    logic                   dut_squash;
    logic [p_addr_bits-1:0] dut_branch_target;
  } transaction;

  transaction transaction_queue [$];

  transaction new_transaction;

  task add_msg(
    logic [p_inst_bits-1:0] exp_inst,
    logic [p_addr_bits-1:0] exp_pc,
    logic                   dut_squash,
    logic [p_addr_bits-1:0] dut_branch_target
  );
    new_transaction.exp_inst          = exp_inst;
    new_transaction.exp_pc            = exp_pc;
    new_transaction.dut_squash        = dut_squash;
    new_transaction.dut_branch_target = dut_branch_target;

    transaction_queue.push_back( new_transaction );
  endtask

  function logic done();
    done = ( transaction_queue.size() == 0 );
  endfunction

  //----------------------------------------------------------------------
  // Store incoming messages in a queue
  //----------------------------------------------------------------------

  typedef struct packed {
    logic [p_inst_bits-1:0] inst;
    logic [p_addr_bits-1:0] pc;
  } dut_input;

  dut_input curr_input;
  assign curr_input.inst = dut.inst;
  assign curr_input.pc   = dut.pc;

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

  dut_input actual_msg;
  transaction exp_msg;

  initial begin
    dut.squash        = 1'b0;
    dut.branch_target = 'x;
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
        actual_msg = dut_queue.dequeue();
        exp_msg    = transaction_queue.pop_front();

        // Check the actual vs expectation
        `CHECK_EQ( actual_msg.inst, exp_msg.exp_inst );
        `CHECK_EQ( actual_msg.pc,   exp_msg.exp_pc   );

        // Set squash/branch target
        dut.squash        = exp_msg.dut_squash;
        dut.branch_target = exp_msg.dut_branch_target;
      end else begin
        dut.squash        = 1'b0;
        dut.branch_target = 'x;
      end
    end
  end

  // verilator lint_on BLKSEQ

endmodule

`endif // TEST_FL_F__D_TEST_D_V
