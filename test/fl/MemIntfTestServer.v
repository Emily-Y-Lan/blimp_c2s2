//========================================================================
// MemIntfTestServer.v
//========================================================================
// A FL model of a memory server, to use in testing

`include "hw/util/DelayStream.v"
`include "intf/MemIntf.v"
`include "test/FLTestUtils.v"
`include "types/MemMsg.v"

`ifndef TEST_FL_MEM_INTF_TEST_SERVER_V
`define TEST_FL_MEM_INTF_TEST_SERVER_V

module MemIntfTestServer #(
  parameter type t_req_msg  = `MEM_REQ ( 32, 32, 8 ),
  parameter type t_resp_msg = `MEM_RESP( 32, 32, 8 ),

  parameter p_send_intv_delay  = 1,
  parameter p_recv_intv_delay = 1,

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
  // Have queues for sending and receiving memory messages
  //----------------------------------------------------------------------

  // verilator lint_off PINCONNECTEMPTY
  
  DelayStream #(
    .t_msg             (t_req_msg),
    .p_send_intv_delay (p_send_intv_delay)
  ) req_queue (
    .clk      (clk),
    .rst      (rst),

    .send_val (dut.req_val),
    .send_rdy (dut.req_rdy),
    .send_msg (dut.req_msg),

    .recv_val (),
    .recv_rdy (1'b0),
    .recv_msg ()
  );

  DelayStream #(
    .t_msg             (t_resp_msg),
    .p_recv_intv_delay (p_recv_intv_delay)
  ) resp_queue (
    .clk      (clk),
    .rst      (rst),

    .send_val (1'b0),
    .send_rdy (),
    .send_msg ('x),

    .recv_val (dut.resp_val),
    .recv_rdy (dut.resp_rdy),
    .recv_msg (dut.resp_msg)
  );

  // verilator lint_on PINCONNECTEMPTY

  //----------------------------------------------------------------------
  // Handle transactions
  //----------------------------------------------------------------------

  t_req_msg  curr_req;
  t_resp_msg curr_resp;

  // verilator lint_off BLKSEQ
  always @( posedge clk ) begin
    if( req_queue.num_msgs() > 0 ) begin
      curr_req = req_queue.dequeue();

      // Execute the transaction
      case( curr_req.op )
        MEM_MSG_READ: begin
          if( mem.exists( curr_req.addr ) == 1 )
            curr_resp.data = mem[curr_req.addr];
          else
            curr_resp.data = 'x;
          curr_resp.len  = curr_req.len;
        end
        MEM_MSG_WRITE: begin
          // TODO: Support len - right now, assume all bytes
          mem[curr_req.addr] = curr_req.data;
          curr_resp.data = 'x;
          curr_resp.len  = curr_req.len;
        end
      endcase

      curr_resp.op     = curr_req.op;
      curr_resp.addr   = curr_req.addr;
      curr_resp.opaque = curr_req.opaque;

      // Store the result to be sent back
      resp_queue.enqueue( curr_resp );
    end
  end
  // verilator lint_on BLKSEQ

endmodule

`endif // TEST_FL_MEM_INTF_TEST_SERVER_V
