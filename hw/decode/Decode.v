//========================================================================
// Decode.v
//========================================================================
// A modular decode unit for decoding and issuing instructions

`ifndef HW_DECODE_DECODE_V
`define HW_DECODE_DECODE_V

`include "defs/ISA.v"

module Decode #(
  parameter p_decode_type                 = "simple",
  parameter p_num_pipes                   = 1,
  parameter p_pipe_types [p_num_pipe-1:0] = {
    RVI_ARITH | RVI_MEM | RVI_JUMP | RVI_BRANCH
  }
);

endmodule

`endif // HW_DECODE_DECODE_V
