//========================================================================
// TestIstream.v
//========================================================================
// A FL input stream for providing stimulus to DUTs

`ifndef TEST_FL_TESTISTREAM_V
`define TEST_FL_TESTISTREAM_V

module TestIstream #(
  parameter type t_msg        = logic[31:0],
  parameter p_send_intv_delay = 0
)(
  input  logic clk,
  
  output t_msg msg,
  output logic val,
  input  logic rdy
);

  //----------------------------------------------------------------------
  // send
  //----------------------------------------------------------------------
  // A function to send a stimulus across a stream interface

  logic msg_sent;

  task send (
    input t_msg dut_msg
  );

    val      = 1'b0;
    msg      = 'x;
    msg_sent = 1'b0;
    
    // Delay for the send interval
    for( int i = 0; i < p_send_intv_delay; i = i + 1 ) begin
      @( posedge clk );
    end

    // Offset from the clock edge
    #1;

    val = 1'b1;
    msg = dut_msg;

    do begin
      #2
      msg_sent = rdy;
      @( posedge clk );
      #1;
    end while( !msg_sent );

    val = 1'b0;

  endtask

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

  // verilator lint_off UNUSEDSIGNAL
  string trace;
  // verilator lint_on UNUSEDSIGNAL

  string test_trace;
  int trace_len;
  initial begin
    test_trace = $sformatf("%x", msg);
    trace_len = test_trace.len();
  end

  // verilator lint_off BLKSEQ
  always_comb begin
    if( val & rdy )
      trace = $sformatf("%x", msg);
    else if( rdy )
      trace = {(trace_len){" "}};
    else if( val )
      trace = {{(trace_len-1){" "}}, "#"};
    else
      trace = {{(trace_len-1){" "}}, "."};
  end
  // verilator lint_on BLKSEQ

endmodule

`endif // TEST_FL_TESTISTREAM_V
