//========================================================================
// X__WTestW.v
//========================================================================
// A FL model of the Writeback interface, to use in testing

`ifndef TEST_FL_X__W_TEST_W_V
`define TEST_FL_X__W_TEST_W_V

`include "hw/util/DelayStream.v"
`include "intf/X__WIntf.v"
`include "test/FLTestUtils.v"

module X__WTestW #(
  parameter p_dut_intv_delay = 0
)(
  input logic clk,
  input logic rst,
  
  X__WIntf.W_intf dut
);

  FLTestUtils t( .* );

  localparam p_data_bits = dut.p_data_bits;
  
  //----------------------------------------------------------------------
  // Store expected results in queue
  //----------------------------------------------------------------------

  typedef struct {
    logic             [4:0] exp_waddr;
    logic [p_data_bits-1:0] exp_wdata;
    logic                   exp_wen;
  } transaction;

  transaction transaction_queue [$];

  transaction new_transaction;

  task add_msg(
    input logic             [4:0] exp_waddr,
    input logic [p_data_bits-1:0] exp_wdata,
    input logic                   exp_wen
  );
    new_transaction.exp_waddr = exp_waddr;
    new_transaction.exp_wdata = exp_wdata;
    new_transaction.exp_wen   = exp_wen;

    transaction_queue.push_back( new_transaction );
  endtask

  function logic done();
    done = ( transaction_queue.size() == 0 );
  endfunction

  //----------------------------------------------------------------------
  // Store incoming messages in a queue
  //----------------------------------------------------------------------

  typedef struct packed {
    logic             [4:0] waddr;
    logic [p_data_bits-1:0] wdata;
    logic                   wen;
  } dut_input;

  dut_input curr_input;
  assign curr_input.waddr = dut.waddr;
  assign curr_input.wdata = dut.wdata;
  assign curr_input.wen   = dut.wen;

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
    processing_msg = 1'b0;
  end
  
  // verilator lint_off BLKSEQ

  always_ff @( posedge clk ) begin
    #1;
    if( !done() & (dut_queue.num_msgs() > 0) ) begin
      actual_msg = dut_queue.dequeue();
      exp_msg    = transaction_queue.pop_front();
      processing_msg = 1'b1;

      #2;

      // Check the actual vs expectation
      `CHECK_EQ( actual_msg.waddr, exp_msg.exp_waddr );
      `CHECK_EQ( actual_msg.wdata, exp_msg.exp_wdata );
      `CHECK_EQ( actual_msg.wen,   exp_msg.exp_wen   );

      processing_msg = 1'b0;
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
    int str_len;

    str_len = 1             + 1 +      // wen
              ceil_div_4(5) + 1 +      // waddr
              ceil_div_4(p_data_bits); // wdata

    if( processing_msg )
      trace = $sformatf("%b:%h:%h", actual_msg.wen, 
                        actual_msg.waddr, actual_msg.wdata);
    else
      trace = {str_len{" "}};
  end
  // verilator lint_on BLKSEQ

endmodule

`endif // TEST_FL_X__W_TEST_W_V
