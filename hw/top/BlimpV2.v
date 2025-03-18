//========================================================================
// BlimpV2.v
//========================================================================
// A top-level implementation of the Blimp processor with OOO completion

`ifndef HW_TOP_BLIMPV2_V
`define HW_TOP_BLIMPV2_V

`include "defs/UArch.v"
`include "hw/fetch/fetch_unit_variants/FetchUnitL2.v"
`include "hw/decode_issue/decode_issue_unit_variants/DecodeIssueUnitL2.v"
`include "hw/execute/execute_units_l1/ALU.v"
`include "hw/execute/execute_units_l2/PipelinedMultiplier.v"
`include "hw/writeback_commit/writeback_commit_unit_variants/WritebackCommitUnitL2.v"
`include "intf/MemIntf.v"
`include "intf/F__DIntf.v"
`include "intf/D__XIntf.v"
`include "intf/X__WIntf.v"
`include "intf/CompleteNotif.v"
`include "intf/CommitNotif.v"
`include "intf/InstTraceNotif.v"

module BlimpV2 #(
  parameter p_seq_num_bits = 5
) (
  input logic clk,
  input logic rst,

  //----------------------------------------------------------------------
  // Instruction Memory
  //----------------------------------------------------------------------

  MemIntf.client inst_mem,

  //----------------------------------------------------------------------
  // Instruction Trace
  //----------------------------------------------------------------------

  InstTraceNotif.pub inst_trace
);

  //----------------------------------------------------------------------
  // Interfaces
  //----------------------------------------------------------------------

  F__DIntf #(
    .p_seq_num_bits (p_seq_num_bits)
  ) f__d_intf();

  D__XIntf #(
    .p_seq_num_bits (p_seq_num_bits)
  ) d__x_intfs[2]();

  X__WIntf #(
    .p_seq_num_bits (p_seq_num_bits)
  ) x__w_intfs[2]();

  CompleteNotif #(
    .p_seq_num_bits (p_seq_num_bits)
  ) complete_notif();

  CommitNotif #(
    .p_seq_num_bits (p_seq_num_bits)
  ) commit_notif();

  assign inst_trace_notif.pc    = commit_notif.pc;
  assign inst_trace_notif.waddr = commit_notif.waddr;
  assign inst_trace_notif.wdata = commit_notif.wdata;
  assign inst_trace_notif.wen   = commit_notif.wen;
  assign inst_trace_notif.val   = commit_notif.val;

  //----------------------------------------------------------------------
  // Units
  //----------------------------------------------------------------------

  FetchUnitL2 FU (
    .mem    (inst_mem),
    .D      (f__d_intf),
    .commit (commit_notif),
    .*
  );

  DecodeIssueUnitL2 #(
    .p_isa_subset   (p_tinyrv1_arith),
    .p_num_pipes    (2),
    .p_pipe_subsets ({
      OP_ADD_VEC, // ALU
      OP_MUL_VEC  // Multiplier
    })
  ) DIU (
    .F        (f__d_intf),
    .Ex       (d__x_intfs),
    .complete (complete_notif),
    .*
  );

  ALU ALU_XU (
    .D (d__x_intfs[0]),
    .W (x__w_intfs[0]),
    .*
  );

  PipelinedMultiplier #(
    .p_pipeline_stages (4)
  ) MUL_XU (
    .D (d__x_intfs[1]),
    .W (x__w_intfs[1]),
    .*
  );

  WritebackCommitUnitL2 #(
    .p_num_pipes (2)
  ) WCU (
    .Ex       (x__w_intfs),
    .complete (complete_notif),
    .commit   (commit_notif),
    .*
  );

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

`ifndef SYNTHESIS
  function string trace();
    trace = {
      FU.trace(),
      " | ",
      DIU.trace(),
      " | ",
      ALU_XU.trace(),
      " | ",
      MUL_XU.trace(),
      " | ",
      WCU.trace()
    };
  endfunction
`endif

endmodule

`endif // HW_TOP_BLIMPV2_V
