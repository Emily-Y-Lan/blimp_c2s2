//========================================================================
// MemIntfTestServer.v
//========================================================================
// A FL model of a memory server, to use in testing

`include "intf/MemIntf.v"
`include "test/FLTestUtils.v"
`include "types/MemMsg.v"

`ifndef TEST_FL_MEM_INTF_TEST_SERVER_V
`define TEST_FL_MEM_INTF_TEST_SERVER_V

module MemIntfTestServer #(
  parameter type t_req_msg  = t_mem_req_msg_32_32_8,
  parameter type t_resp_msg = t_mem_resp_msg_32_32_8,

  parameter p_transac_delay = 1,

  parameter p_addr_bits = 32,
  parameter p_data_bits = 32
)(
  input  logic clk,
  input  logic rst,
  
  
  MemIntf.server dut
);

  FLTestUtils t( .* );
  
  //----------------------------------------------------------------------
  // Store memory values in association array
  //----------------------------------------------------------------------

  logic [p_data_bits-1:0] mem [logic [p_addr_bits-1:0]];

  always_ff @( posedge clk ) begin
    if( rst )
      mem.delete();
  end

  task init_mem(
    input logic [p_addr_bits-1:0] addr,
    input logic [p_data_bits-1:0] data
  );
    mem[addr] = data;
  endtask

  //----------------------------------------------------------------------
  // Manipulate server interface appropriately
  //----------------------------------------------------------------------

  typedef struct {
    int       delay;
    t_req_msg msg;
  } mem_req;

  mem_req mem_req_queue [$];

  // verilator lint_off BLKSEQ
  always @( posedge clk ) begin
    foreach (mem_req_queue[i]) begin
      if( mem_req_queue[i].delay > 0 )
        mem_req_queue[i].delay -= 1;
    end
  end
  // verilator lint_on BLKSEQ

  typedef t_resp_msg mem_resp;

  mem_resp mem_resp_queue [$];

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Handle requests
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mem_req req_transaction;

  initial begin
    dut.req_rdy = 1'b0;

    // Wait for reset
    @( negedge rst );
    
    // Align with clock edge
    @( posedge clk );
    #1;

    while ( 1 ) begin

      // Offset assignments by #1 to avoid conflicts with resetting
      // signals after a transaction

      #1;
      dut.req_rdy = 1'b1;

      // Get the transaction #1 before the clock edge
      while( !dut.req_val ) #10;
      #7;
      req_transaction.msg   = dut.req_msg;
      req_transaction.delay = p_transac_delay;
      if( dut.req_val ) mem_req_queue.push_back( req_transaction );

      #2;
      dut.req_rdy = 1'b0;
    end
  end

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Handle transactions
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mem_req   curr_req;
  t_req_msg curr_req_msg;
  mem_resp  curr_resp;

  // verilator lint_off BLKSEQ
  always @( posedge clk ) begin
    if( mem_req_queue.size() > 0 ) begin
      if( mem_req_queue[0].delay == 0 ) begin
        curr_req = mem_req_queue.pop_front();
        curr_req_msg = curr_req.msg;

        // Execute the transaction
        case( curr_req_msg.op )
          MEM_MSG_READ: begin
            if( mem.exists( curr_req_msg.addr ) == 1 )
              curr_resp.data = mem[curr_req_msg.addr];
            else
              curr_resp.data = 'x;
            curr_resp.len  = curr_req_msg.len;
          end
          MEM_MSG_WRITE: begin
            // TODO: Support len - right now, assume all bytes
            mem[curr_req_msg.addr] = curr_req_msg.data;
            curr_resp.data = 'x;
            curr_resp.len  = curr_req_msg.len;
          end
        endcase

        curr_resp.op     = curr_req_msg.op;
        curr_resp.addr   = curr_req_msg.addr;
        curr_resp.opaque = curr_req_msg.opaque;

        // Propagate assignments
        #1;

        // Store the result to be sent back
        mem_resp_queue.push_back( curr_resp );
      end
    end
  end
  // verilator lint_on BLKSEQ

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Handle responses
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mem_resp resp_transaction;

  initial begin
    dut.resp_val = 1'b0;
    dut.resp_msg = 'x;

    // Wait for reset
    @( negedge rst );

    // Align with clock edge
    @( posedge clk );
    #1;

    while ( 1 ) begin
      // Wait for new messages to be put in the queue
      #1;

      while( mem_resp_queue.size() == 0 ) #10;
      resp_transaction = mem_resp_queue.pop_front();

      dut.resp_val = 1'b1;
      dut.resp_msg = resp_transaction;

      // Check the transaction #1 before the clock edge
      #7;
      while( !dut.resp_val ) #10;

      #2;
      dut.resp_val = 1'b0;
      dut.resp_msg = 'x;
    end
  end
endmodule

`endif // TEST_FL_MEM_INTF_TEST_SERVER_V
