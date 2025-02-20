//========================================================================
// BlimpBasic.v
//========================================================================
// A top-level implementation of the Blimp processor with an ALU and
// multiplier

`ifndef HW_TOP_BLIMPV1_V
`define HW_TOP_BLIMPV1_V

`include "defs/UArch.v"
`include "hw/fetch/fetch_unit_variants/FetchUnitL1.v"
`include "hw/decode_issue/decode_issue_unit_variants/DecodeIssueUnitL1.v"
`include "hw/execute/execute_units_l1/ALU.v"
`include "hw/execute/execute_units_l1/Multiplier.v"
`include "hw/writeback_commit/writeback_commit_unit_variants/WritebackCommitUnitL1.v"
`include "intf/MemIntf.v"
`include "intf/F__DIntf.v"
`include "intf/D__XIntf.v"
`include "intf/X__WIntf.v"
`include "intf/CompleteNotif.v"
`include "intf/CommitNotif.v"
`include "intf/InstTraceNotif.v"

module BlimpV1 #(
  parameter p_rst_addr    = 32'h0,
  parameter p_opaq_bits   = 8,
  parameter p_rob_entries = 32
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

  localparam p_seq_num_bits = $clog2(p_rob_entries);
  localparam p_addr_bits    = inst_trace.p_addr_bits;
  localparam p_data_bits    = inst_trace.p_data_bits;

  //----------------------------------------------------------------------
  // Interfaces
  //----------------------------------------------------------------------

  F__DIntf #(
    .p_addr_bits (p_addr_bits),
    .p_inst_bits (p_data_bits)
  ) f__d_intf();

  D__XIntf #(
    .p_addr_bits    (p_addr_bits),
    .p_data_bits    (p_data_bits),
    .p_seq_num_bits (p_seq_num_bits)
  ) d__x_intfs[2]();

  X__WIntf #(
    .p_addr_bits    (p_addr_bits),
    .p_data_bits    (p_data_bits),
    .p_seq_num_bits (p_seq_num_bits)
  ) x__w_intfs[2]();

  CompleteNotif #(
    .p_data_bits    (p_data_bits),
    .p_seq_num_bits (p_seq_num_bits)
  ) complete_notif();

  CommitNotif #(
    .p_addr_bits    (p_addr_bits),
    .p_data_bits    (p_data_bits),
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

  FetchUnitL1 #(
    .p_rst_addr  (p_rst_addr),
    .p_opaq_bits (p_opaq_bits)
  ) FU (
    .mem (inst_mem),
    .D   (f__d_intf),
    .*
  );

  DecodeIssueUnitL1 #(
    .p_isa_subset   (OP_ADD_VEC | OP_MUL_VEC),
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

  ALU #(
    .p_addr_bits    (p_addr_bits),
    .p_data_bits    (p_data_bits),
    .p_seq_num_bits (p_seq_num_bits)
  ) ALU_XU (
    .D (d__x_intfs[0]),
    .W (x__w_intfs[0]),
    .*
  );

  Multiplier #(
    .p_addr_bits    (p_addr_bits),
    .p_data_bits    (p_data_bits),
    .p_seq_num_bits (p_seq_num_bits)
  ) MUL_XU (
    .D (d__x_intfs[1]),
    .W (x__w_intfs[1]),
    .*
  );

  WritebackCommitUnitL1 #(
    .p_num_pipes (2)
  ) WCU (
    .Ex       (x__w_intfs),
    .complete (complete_notif),
    .commit   (commit_notif),
    .*
  );

  logic [p_seq_num_bits-1:0] unused_seq_num;
  assign unused_seq_num = commit_notif.seq_num;

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

`endif // HW_TOP_BLIMPV1_V
