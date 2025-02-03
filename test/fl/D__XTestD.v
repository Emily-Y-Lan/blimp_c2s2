//========================================================================
// D__XTestD.v
//========================================================================
// A FL model of the Decode interface, to use in testing

`ifndef TEST_FL_D__X_TEST_D_V
`define TEST_FL_D__X_TEST_D_V

`include "intf/D__XIntf.v"
`include "test/FLTestUtils.v"

module D__XTestD #(
  parameter p_send_intv_delay = 0
)(
  input logic clk,
  input logic rst,
  
  D__XIntf.D_intf dut
);

  localparam p_addr_bits = dut.p_addr_bits;
  localparam p_data_bits = dut.p_data_bits;

  //----------------------------------------------------------------------
  // Store decode outputs in queue
  //----------------------------------------------------------------------

  typedef struct packed {
    logic [p_addr_bits-1:0] pc;
    logic [p_data_bits-1:0] op1;
    logic [p_data_bits-1:0] op2;
    logic             [4:0] waddr;
    rv_uop                  uop;
  } msg;

  msg curr_output;
  assign dut.pc    = curr_output.pc;
  assign dut.op1   = curr_output.op1;
  assign dut.op2   = curr_output.op2;
  assign dut.waddr = curr_output.waddr;
  assign dut.uop   = curr_output.uop;

  // verilator lint_off PINCONNECTEMPTY

  DelayStream #(
    .t_msg             (msg),
    .p_send_intv_delay (p_send_intv_delay)
  ) dut_queue (
    .clk (clk),
    .rst (rst),

    .send_val (1'b0),
    .send_rdy (),
    .send_msg (),

    .recv_val (dut.val),
    .recv_rdy (dut.rdy),
    .recv_msg (curr_output)
  );

  // verilator lint_on PINCONNECTEMPTY

  msg new_msg;

  task add_msg(
    input logic [p_addr_bits-1:0] pc,
    input logic [p_data_bits-1:0] op1,
    input logic [p_data_bits-1:0] op2,
    input logic             [4:0] waddr,
    input rv_uop                  uop
  );
    new_msg.pc    = pc;
    new_msg.op1   = op1;
    new_msg.op2   = op2;
    new_msg.waddr = waddr;
    new_msg.uop   = uop;

    dut_queue.enqueue( new_msg );
  endtask

  //----------------------------------------------------------------------
  // Check any expected redirection
  //----------------------------------------------------------------------

  typedef logic [p_addr_bits-1:0] target;

  target target_queue [$];

  task add_target(
    input target new_target
  );
    target_queue.push_back( new_target );
  endtask

  target exp_target;

  // verilator lint_off BLKSEQ

  always_ff @( posedge clk ) begin
    #3;
    if( dut.squash ) begin
      if( target_queue.size() > 0 ) begin
        exp_target = target_queue.pop_front();
        `CHECK_EQ( dut.branch_target, exp_target );
      end else begin
        // Unexpected branch - fail
        `CHECK_EQ( dut.branch_target, dut.branch_target + 1 );
      end
    end
  end

  // verilator lint_on BLKSEQ

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

  // verilator lint_off UNUSEDSIGNAL
  string trace;
  // verilator lint_on UNUSEDSIGNAL

  // verilator lint_off BLKSEQ
  always_comb begin
    if( dut.val & dut.rdy )
      trace = $sformatf("%11s", dut.uop.name());
    else
      trace = {11{" "}};
  end
  // verilator lint_on BLKSEQ

endmodule

`endif // TEST_FL_F__D_TEST_F_V
