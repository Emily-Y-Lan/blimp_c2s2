//========================================================================
// WritebackCommit.v
//========================================================================
// A modular unit for writing back results and committing instructions

`ifndef HW_WRITEBACK_WRITEBACK_COMMIT_V
`define HW_WRITEBACK_WRITEBACK_COMMIT_V

`include "hw/writeback_commit/writeback_variants/WritebackBasic.v"
`include "intf/CompleteNotif.v"
`include "intf/WritebackNotif.v"
`include "intf/X__WIntf.v"

module WritebackCommit #(
  parameter p_writeback_commit_type = "basic_writeback",
  parameter p_num_pipes             = 1
) (
  input  logic clk,
  input  logic rst,

  //----------------------------------------------------------------------
  // X <-> W Interface
  //----------------------------------------------------------------------

  X__WIntf.W_intf Ex [p_num_pipes-1:0],

  //----------------------------------------------------------------------
  // Writeback Interface
  //----------------------------------------------------------------------

  WritebackNotif.pub writeback,

  //----------------------------------------------------------------------
  // Completion Interface
  //----------------------------------------------------------------------

  CompleteNotif.pub complete
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
  
    if ( p_writeback_commit_type == "basic_writeback" ) begin
      WritebackBasic #(
        .p_num_pipes    (p_num_pipes)
      ) writeback_basic (
        .*
      );

`ifndef SYNTHESIS
      assign trace = writeback_basic.trace;
`endif
    end
    
    else begin
      $error("Unknown writeback-commit type: '%s'", p_writeback_commit_type);
    end
  endgenerate

endmodule

`endif // HW_DECODE_DECODE_V
