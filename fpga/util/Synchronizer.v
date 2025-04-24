//========================================================================
// Synchronizer.v
//========================================================================
// A module for synchronizing signals to our system clock

`ifndef FPGA_UTIL_SYNCHRONIZER_V
`define FPGA_UTIL_SYNCHRONIZER_V

module Synchronizer (
  input  logic clk,
  input  logic in,
  output logic out
);
  logic in_buf;

  always_ff @( posedge clk ) begin
    in_buf <= in;
    out    <= in_buf;
  end
endmodule

`endif // FPGA_UTIL_SYNCHRONIZER_V