//========================================================================
// FPGAMem.v
//========================================================================
// FPGA-based memory, for use with Blimp
//
// For Altera, we use M10K memory blocks; this instance uses 256 blocks
// to hold 256KB of memory. Bytes are separated for sub-word memory
// operations. Operations on addresses at or above 0x00040000 are aliased
// to their lower addresses.
//
// We use a separate clock for memory, due to the latency of reading:
//  - https://people.ece.cornell.edu/land/courses/ece5760/DE1_SOC/Memory/index.html
//
// We handle transactions in a pipeline, to give enough timing for memory
// operations:
//
// REQ -> READ/WRITE -> RESP

`ifndef FPGA_FPGAMEM_V
`define FPGA_FPGAMEM_V

`include "fpga/net/MemNetReq.v"
`include "fpga/net/MemNetResp.v"
`include "hw/common/Fifo.v"

module FPGAMem #(
  parameter p_opaq_bits = 8
)(
  input  logic clk,
  input  logic rst,
  input  logic mem_clk, // >= 3x faster than clk

  MemNetReq.server  req,
  MemNetResp.server resp
);

  // ---------------------------------------------------------------------
  // M10K Memory
  // ---------------------------------------------------------------------

  // Need 256KB in total
  reg [7:0] mem_b0 [65535:0]  /* synthesis ramstyle = "no_rw_check, M10K" */;
  reg [7:0] mem_b1 [65535:0]  /* synthesis ramstyle = "no_rw_check, M10K" */;
  reg [7:0] mem_b2 [65535:0]  /* synthesis ramstyle = "no_rw_check, M10K" */;
  reg [7:0] mem_b3 [65535:0]  /* synthesis ramstyle = "no_rw_check, M10K" */;

  logic [15:0] raddr, waddr;
  logic  [7:0] rdata0, rdata1, rdata2, rdata3;
  logic  [7:0] wdata0, wdata1, wdata2, wdata3;
  logic           we0,    we1,    we2,    we3;

  always_ff @( posedge mem_clk ) begin
    if( we0 ) begin
      mem_b0[waddr] <= wdata0;
    end
    rdata0 <= mem_b0[raddr];
  end

  always_ff @( posedge mem_clk ) begin
    if( we1 ) begin
      mem_b1[waddr] <= wdata1;
    end
    rdata1 <= mem_b1[raddr];
  end

  always_ff @( posedge mem_clk ) begin
    if( we2 ) begin
      mem_b2[waddr] <= wdata2;
    end
    rdata2 <= mem_b2[raddr];
  end

  always_ff @( posedge mem_clk ) begin
    if( we3 ) begin
      mem_b3[waddr] <= wdata3;
    end
    rdata3 <= mem_b3[raddr];
  end

  // ---------------------------------------------------------------------
  // Use a FIFO to decouple incoming messages
  // ---------------------------------------------------------------------

  typedef struct packed {
    t_op                    op;
    logic [p_opaq_bits-1:0] opaque;
    logic [1:0]             origin;
    logic [31:0]            addr;
    logic [3:0]             strb;
    logic [31:0]            data;
  } fifo_msg_t;

  logic fifo_push, fifo_pop, fifo_empty, fifo_full;
  fifo_msg_t fifo_wdata, fifo_rdata;

  Fifo #(
    .p_entry_bits (71 + p_opaq_bits),
    .p_depth      (4)
  ) req_fifo (
    .clk   (clk),
    .rst   (rst),
    .push  (fifo_push),
    .pop   (fifo_pop),
    .empty (fifo_empty),
    .full  (fifo_full),
    .wdata (fifo_wdata),
    .rdata (fifo_rdata)
  );

  assign fifo_push  = req.val;
  assign req.rdy    = !fifo_full;
  assign fifo_wdata = req.msg;

  // ---------------------------------------------------------------------
  // Pipeline
  // ---------------------------------------------------------------------

  typedef struct packed {
    logic                   val;
    t_op                    op;
    logic [p_opaq_bits-1:0] opaque;
    logic [1:0]             origin;
    logic [31:0]            addr;
    logic [3:0]             strb;
    logic [31:0]            data;
  } pipe_msg_t;

  pipe_msg_t rw_msg, resp_msg;
  logic      rw_val, rw_rdy;

  logic  req_xfer, rw_xfer, resp_xfer;
  assign req_xfer  = !fifo_empty & fifo_pop;
  assign rw_xfer   = rw_val & rw_rdy;
  assign resp_xfer = resp.val & resp.rdy;

  // verilator lint_off ENUMVALUE
  pipe_msg_t rw_msg_next, resp_msg_next;
  always_ff @( posedge clk ) begin
    if ( rst )
      rw_msg <= '{ 
        val:     1'b0, 
        op:     'x,
        opaque: 'x,
        origin: 'x,
        addr:   'x,
        strb:   'x,
        data:   'x
      };
    else
      rw_msg <= rw_msg_next;
    if ( rst )
      resp_msg <= '{ 
        val:     1'b0, 
        op:     'x,
        opaque: 'x,
        origin: 'x,
        addr:   'x,
        strb:   'x,
        data:   'x
      };
    else
      resp_msg <= resp_msg_next;
  end

  logic [31:0] rdata;

  always_comb begin
    rw_msg_next = rw_msg;
    if( req_xfer )
      rw_msg_next = '{
        val: 1'b1,
        op:     fifo_rdata.op,
        opaque: fifo_rdata.opaque,
        origin: fifo_rdata.origin,
        addr:   fifo_rdata.addr,
        strb:   fifo_rdata.strb,
        data:   fifo_rdata.data
      };
    else if( rw_xfer )
      rw_msg_next = '{ 
        val:     1'b0, 
        op:     'x,
        opaque: 'x,
        origin: 'x,
        addr:   'x,
        strb:   'x,
        data:   'x
      };
  end

  always_comb begin
    resp_msg_next = resp_msg;
    if( rw_xfer )
      resp_msg_next = '{
        val:    1'b1,
        op:     rw_msg.op,
        opaque: rw_msg.opaque,
        origin: rw_msg.origin,
        addr:   rw_msg.addr,
        strb:   rw_msg.strb,
        data:   rdata
      };
    else if( resp_xfer )
      resp_msg_next = '{ 
        val:     1'b0, 
        op:     'x,
        opaque: 'x,
        origin: 'x,
        addr:   'x,
        strb:   'x,
        data:   'x
      };
  end
  // verilator lint_on ENUMVALUE

  assign resp.msg.op     = resp_msg.op;
  assign resp.msg.opaque = resp_msg.opaque;
  assign resp.msg.origin = resp_msg.origin;
  assign resp.msg.addr   = resp_msg.addr;
  assign resp.msg.strb   = resp_msg.strb;
  assign resp.msg.data   = resp_msg.data;

  // ---------------------------------------------------------------------
  // Memory Signals
  // ---------------------------------------------------------------------

  logic we;
  assign we = rw_msg.val & ( rw_msg.op == MEM_MSG_WRITE );

  assign rdata =  { rdata3, rdata2, rdata1, rdata0 };
  assign wdata0 = rw_msg.data[ 7: 0];
  assign wdata1 = rw_msg.data[15: 8];
  assign wdata2 = rw_msg.data[23:16];
  assign wdata3 = rw_msg.data[31:24];
  assign we0    = we & rw_msg.strb[0];
  assign we1    = we & rw_msg.strb[1];
  assign we2    = we & rw_msg.strb[2];
  assign we3    = we & rw_msg.strb[3];

  logic [15:0] mem_addr;
  assign       mem_addr = rw_msg.addr[17:2]; // Don't include bytes

  // Same address for read and write
  assign raddr = mem_addr;
  assign waddr = mem_addr;

  // ---------------------------------------------------------------------
  // Control Signals
  // ---------------------------------------------------------------------

  assign resp.val = resp_msg.val;
  assign rw_val = rw_msg.val;

  // Break combinational loop - currently inserts a bubble
  assign rw_rdy = ( resp_msg.val & resp_xfer ) | !resp_msg.val;

  assign fifo_pop = (( rw_msg.val & rw_xfer ) | !rw_msg.val) & !fifo_empty;
endmodule

`endif // FPGA_FPGAMEM_V
