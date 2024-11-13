//========================================================================
// DecodeIssue.v
//========================================================================
// A modular decode unit for decoding and issuing instructions

`ifndef HW_DECODE_DECODE_V
`define HW_DECODE_DECODE_V

`include "hw/decode_issue/decode_variants/DecodeBasic.v"
`include "intf/F__DIntf.v"
`include "intf/D__XIntf.v"

module DecodeIssue #(
  parameter p_decode_issue_type = "basic",
  parameter p_num_pipes         = 1
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

  D__XIntf.D_intf Ex [p_num_pipes-1:0]
);

generate
  //----------------------------------------------------------------------
  // basic
  //----------------------------------------------------------------------

  if ( p_decode_issue_type == "basic" ) begin
    DecodeBasic #(p_num_pipes) decode (
      .*
    );
  end
  
  else begin
    $error("Unknown decode type: '%s'", p_decode_issue_type);
  end
endgenerate

endmodule

`endif // HW_DECODE_DECODE_V
