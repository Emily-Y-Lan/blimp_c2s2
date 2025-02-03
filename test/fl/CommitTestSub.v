//========================================================================
// CommitTestSub.v
//========================================================================
// A FL model of a commit subscriber, to check messages

`ifndef TEST_FL_COMMIT_TEST_SUB_V
`define TEST_FL_COMMIT_TEST_SUB_V

`include "intf/CommitNotif.v"
`include "test/FLTestUtils.v"

module CommitTestSub (
  input logic clk,
  input logic rst,
  
  CommitNotif.sub dut
);

  FLTestUtils t( .* );

  localparam p_data_bits    = dut.p_data_bits;
  localparam p_seq_num_bits = dut.p_seq_num_bits;

  //----------------------------------------------------------------------
  // Store expected results in queue
  //----------------------------------------------------------------------

  typedef struct {
    logic [p_seq_num_bits-1:0] exp_seq_num;
    logic                [4:0] exp_waddr;
    logic    [p_data_bits-1:0] exp_wdata;
    logic                      exp_wen;
  } transaction;

  transaction transaction_queue [$];

  always_ff @( posedge clk ) begin
    if( rst )
      transaction_queue.delete();
  end

  transaction new_transaction;

  // verilator lint_off BLKSEQ
  task add_msg(
    input logic [p_seq_num_bits-1:0] exp_seq_num,
    input logic                [4:0] exp_waddr,
    input logic    [p_data_bits-1:0] exp_wdata,
    input logic                      exp_wen
  );
    new_transaction.exp_seq_num = exp_seq_num;
    new_transaction.exp_waddr   = exp_waddr;
    new_transaction.exp_wdata   = exp_wdata;
    new_transaction.exp_wen     = exp_wen;

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
    if( !done() & dut.val ) begin
      exp_msg        = transaction_queue.pop_front();

      #2;

      // Check the actual vs expectation
      `CHECK_EQ( dut.seq_num, exp_msg.exp_seq_num   );
      `CHECK_EQ( dut.waddr,   exp_msg.exp_waddr   );
      `CHECK_EQ( dut.wdata,   exp_msg.exp_wdata   );
      `CHECK_EQ( dut.wen,     exp_msg.exp_wen   );
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

  assign str_len = ceil_div_4( p_seq_num_bits ) + 1 + // seq_num
                   ceil_div_4( 5 )              + 1 + // addr
                   ceil_div_4( p_data_bits )    + 1 + // data
                   1;                                 // wen
  
  always_comb begin
    if( dut.wen )
      trace = $sformatf("%h:%h:%h:%b", dut.seq_num, dut.waddr, dut.wdata, dut.wen );
    else
      trace = {str_len{" "}};
  end

endmodule

`endif // TEST_FL_COMMIT_TEST_SUB_V
