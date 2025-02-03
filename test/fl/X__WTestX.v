//========================================================================
// X__WTestX.v
//========================================================================
// A FL model of the Execute interface, to use in testing

`ifndef TEST_FL_X__W_TEST_X_V
`define TEST_FL_X__W_TEST_X_V

`include "hw/util/DelayStream.v"
`include "intf/X__WIntf.v"
`include "test/FLTestUtils.v"

module X__WTestX #(
  parameter p_send_intv_delay = 0
)(
  input logic clk,
  input logic rst,
  
  X__WIntf.X_intf dut
);

  localparam p_data_bits = dut.p_data_bits;

  //----------------------------------------------------------------------
  // Store execute outputs in queue
  //----------------------------------------------------------------------

  typedef struct packed {
    logic             [4:0] waddr;
    logic [p_data_bits-1:0] wdata;
    logic                   wen;
  } msg;

  msg curr_output;
  assign dut.waddr = curr_output.waddr;
  assign dut.wdata = curr_output.wdata;
  assign dut.wen   = curr_output.wen;

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

  // verilator lint_off BLKSEQ
  task add_msg(
    input logic             [4:0] waddr,
    input logic [p_data_bits-1:0] wdata,
    input logic                   wen
  );
    new_msg.waddr = waddr;
    new_msg.wdata = wdata;
    new_msg.wen   = wen;

    dut_queue.enqueue( new_msg );
  endtask
  // verilator lint_on BLKSEQ

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

  function int ceil_div_4( int val );
    return (val / 4) + (val % 4);
  endfunction

  // verilator lint_off UNUSEDSIGNAL
  string trace;
  int str_len;
  // verilator lint_on UNUSEDSIGNAL

  assign str_len = ceil_div_4( 5 )     + 1 +  // addr
                   ceil_div_4( p_data_bits ); // data
  
  always_comb begin
    if( dut.val & dut.rdy )
      trace = $sformatf("%h:%h", curr_output.waddr, curr_output.wdata );
    else
      trace = {str_len{" "}};
  end

endmodule

`endif // TEST_FL_F__D_TEST_F_V
