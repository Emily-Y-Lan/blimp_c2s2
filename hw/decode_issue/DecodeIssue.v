//========================================================================
// DecodeIssue.v
//========================================================================
// A modular decode unit for decoding and issuing instructions

`ifndef HW_DECODE_DECODE_V
`define HW_DECODE_DECODE_V

`include "defs/UArch.v"
`include "hw/decode_issue/decode_variants/DecodeBasic.v"
`include "intf/F__DIntf.v"
`include "intf/D__XIntf.v"

import UArch::*;

module DecodeIssue #(
  parameter p_decode_issue_type                        = "basic_tinyrv1",
  parameter p_num_pipes                                = 1,
  parameter rv_op_vec [p_num_pipes-1:0] p_pipe_subsets = '{default: p_tinyrv1}
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

`ifndef SYNTHESIS
  // verilator lint_off UNUSEDSIGNAL
  string trace;
  // verilator lint_on UNUSEDSIGNAL
`endif

  generate
    //----------------------------------------------------------------------
    // basic
    //----------------------------------------------------------------------
  
    if ( p_decode_issue_type == "basic_tinyrv1" ) begin
      DecodeBasic #(
        .p_isa_subset   (p_tinyrv1),
        .p_num_pipes    (p_num_pipes),
        .p_pipe_subsets (p_pipe_subsets)
      ) decode (
        .*
      );

`ifndef SYNTHESIS
      assign trace = decode.trace;
`endif
    end
    
    else begin
      $error("Unknown decode type: '%s'", p_decode_issue_type);
    end
  endgenerate

endmodule

`endif // HW_DECODE_DECODE_V
