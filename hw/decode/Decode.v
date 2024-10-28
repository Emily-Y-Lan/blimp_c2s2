//========================================================================
// Decode.v
//========================================================================
// A modular decode unit for decoding and issuing instructions

`ifndef HW_DECODE_DECODE_V
`define HW_DECODE_DECODE_V

module Decode #(
  parameter p_decode_type                 = "simple",
  parameter p_num_pipes                   = 1,
  parameter p_pipe_types [p_num_pipe-1:0] = 1
);

endmodule

`endif  // HW_DECODE_DECODE_V
