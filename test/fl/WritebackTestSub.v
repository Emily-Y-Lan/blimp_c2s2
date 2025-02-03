//========================================================================
// WritebackTestSub.v
//========================================================================
// A FL model of a writeback subscriber, to check messages

`ifndef TEST_FL_WRITEBACK_TEST_SUB_V
`define TEST_FL_WRITEBACK_TEST_SUB_V

`include "intf/WritebackNotif.v"
`include "test/FLTestUtils.v"

module WritebackTestSub (
  input logic clk,
  input logic rst,
  
  WritebackNotif.sub dut
);

  FLTestUtils t( .* );

  localparam p_data_bits = dut.p_data_bits;

  //----------------------------------------------------------------------
  // Store expected results in queue
  //----------------------------------------------------------------------

  typedef struct {
    logic             [4:0] exp_waddr;
    logic [p_data_bits-1:0] exp_wdata;
  } transaction;

  transaction transaction_queue [$];

  always_ff @( posedge clk ) begin
    if( rst )
      transaction_queue.delete();
  end

  transaction new_transaction;

  // verilator lint_off BLKSEQ
  task add_msg(
    input logic             [4:0] exp_waddr,
    input logic [p_data_bits-1:0] exp_wdata,
  );
    new_transaction.exp_waddr = exp_waddr;
    new_transaction.exp_wdata = exp_wdata;

    transaction_queue.push_back( new_transaction );
  endtask
  // verilator lint_on BLKSEQ

  function logic done();
    done = ( transaction_queue.size() == 0 );
  endfunction

  //----------------------------------------------------------------------
  // Check incoming notifications
  //----------------------------------------------------------------------

  transaction exp_msg;
  
  // verilator lint_off BLKSEQ

  always_ff @( posedge clk ) begin
    #1;
    if( !done() & dut.wen ) begin
      exp_msg        = transaction_queue.pop_front();

      #2;

      // Check the actual vs expectation
      `CHECK_EQ( dut.waddr,   exp_msg.exp_waddr   );
      `CHECK_EQ( dut.wdata,   exp_msg.exp_wdata   );
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
  int str_len;
  // verilator lint_on UNUSEDSIGNAL

  assign str_len = ceil_div_4( 5 )     + 1 +  // addr
                   ceil_div_4( p_data_bits ); // data
  
  always_comb begin
    if( dut.wen )
      trace = $sformatf("%h:%h", dut.waddr, dut.wdata );
    else
      trace = {str_len{" "}};
  end

endmodule

`endif // TEST_FL_WRITEBACK_TEST_SUB_V
