//========================================================================
// Decode.v
//========================================================================
// A modular decode unit for decoding and issuing instructions

`ifndef HW_DECODE_DECODE_V
`define HW_DECODE_DECODE_V

`include "defs/ISA.v"
`include "hw/decode_issue/variants/DecodeBasic.v"
`include "intf/F__DIntf.v"
`include "intf/D__XIntf.v"

module Decode #(
  parameter p_decode_type = "basic"
) (
  input  logic clk,
  input  logic rst,

  //----------------------------------------------------------------------
  // F <-> D Interface
  //----------------------------------------------------------------------

  F__DIntf.D_intf F,

  //----------------------------------------------------------------------
  // D <-> X Interface
  //----------------------------------------------------------------------

  D__XIntf.D_intf Ex
);

generate
  //----------------------------------------------------------------------
  // basic
  //----------------------------------------------------------------------

  if ( p_decode_type == "basic" ) begin
    DecodeBasics decode (
      .*
    );
  end else begin
    $error("Unknown decode type: '%s'", p_decode_type);
  end
endgenerate

endmodule

`endif // HW_DECODE_DECODE_V
