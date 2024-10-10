//========================================================================
// Fifo.v
//========================================================================
// A general-purpose FIFO using a pointer-based approach

`ifndef HW_COMMON_FIFO_V
`define HW_COMMON_FIFO_V

module Fifo
#(
  parameter type t_entry = logic [31:0],
  parameter p_depth      = 32
)(
  input  logic clk,
  input  logic rst,

  //----------------------------------------------------------------------
  // Control/Status Signals
  //----------------------------------------------------------------------

  input  logic push,
  input  logic pop,
  output logic empty,
  output logic full,

  //----------------------------------------------------------------------
  // Data Signals
  //----------------------------------------------------------------------

  input  t_entry wdata,
  output t_entry rdata
);

  //----------------------------------------------------------------------
  // Create our pointers
  //----------------------------------------------------------------------

  localparam p_addr_bits = $clog2(p_depth);

  logic [p_addr_bits:0] rptr, wptr;

  always @( posedge clk ) begin
    if( rst ) begin
      rptr <= '0;
      wptr <= '0;
    end else begin
      if( push ) wptr <= wptr + 1;
      if( pop  ) rptr <= rptr + 1;
    end
  end

  assign empty = ( wptr == rptr );
  assign full  = ( wptr[p_addr_bits-1:0] == rptr[p_addr_bits-1:0] )
               & ( wptr[p_addr_bits]     != rptr[p_addr_bits]     );

  //----------------------------------------------------------------------
  // Create our data array
  //----------------------------------------------------------------------

  t_entry arr [p_depth-1:0];

  always @( posedge clk ) begin
    if( rst ) begin
      arr <= '{default: '0};
    end else if( push ) begin
      arr[wptr[p_addr_bits-1:0]] <= wdata;
    end
  end

  assign rdata = arr[rptr[p_addr_bits-1:0]];

endmodule

`endif // HW_COMMON_FIFO_V
