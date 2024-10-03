//========================================================================
// Fifo.v
//========================================================================
// A general-purpose FIFO using a pointer-based approach

`ifndef HW_COMMON_FIFO_V
`define HW_COMMON_FIFO_V

module Fifo
#(
  parameter WIDTH = 32,
  parameter DEPTH = 32
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

  input  logic [WIDTH-1:0] wdata,
  output logic [WIDTH-1:0] rdata
);

  //----------------------------------------------------------------------
  // Create our pointers
  //----------------------------------------------------------------------

  localparam ADDR_BITS = $clog2(DEPTH);

  logic [ADDR_BITS:0] rptr, wptr;

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
  assign full  = ( wptr[ADDR_BITS-1:0] == rptr[ADDR_BITS-1:0] )
               & ( wptr[ADDR_BITS]     != rptr[ADDR_BITS]     );

  //----------------------------------------------------------------------
  // Create our data array
  //----------------------------------------------------------------------

  logic [WIDTH-1:0] arr [DEPTH-1:0];

  always @( posedge clk ) begin
    if( rst ) begin
      arr <= '{default: '0};
    end else if( push ) begin
      arr[wptr[ADDR_BITS-1:0]] <= wdata;
    end
  end

  assign rdata = arr[rptr[ADDR_BITS-1:0]];

endmodule

`endif // HW_COMMON_FIFO_V
