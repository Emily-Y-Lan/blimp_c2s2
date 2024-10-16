//========================================================================
// Fetch_flat.v
//========================================================================
// A flat representation of our fetch unit

`ifndef HW_FETCH_FLAT_FETCH_FLAT_V
`define HW_FETCH_FLAT_FETCH_FLAT_V

`include "hw/fetch/Fetch.v"

`include "intf/F__DIntf.v"
`include "intf/MemIntf.v"

`include "types/MemMsg.v"

module Fetch_flat
#(
  parameter p_rst_addr = 32'b0,

  //----------------------------------------------------------------------
  // Interface Parameters
  //----------------------------------------------------------------------

  parameter p_addr_bits = 32,
  parameter p_inst_bits = 32,
  parameter p_opaq_bits = 8
)
(
  input  logic   clk,
  input  logic   rst,

  //----------------------------------------------------------------------
  // Memory Interface
  //----------------------------------------------------------------------

  output logic                  mem_req_val,
  input  logic                  mem_req_rdy,
  output t_mem_req_msg_32_32_8  mem_req_msg,

  input  logic                  mem_resp_val,
  output logic                  mem_resp_rdy,
  input  t_mem_resp_msg_32_32_8 mem_resp_msg,

  //----------------------------------------------------------------------
  // F <-> D Interface
  //----------------------------------------------------------------------

  output [p_inst_bits-1:0] D_inst,
  output [p_addr_bits-1:0] D_pc,
  output logic             D_val,
  input  logic             D_rdy,

  input  logic             D_squash,

  input  [p_addr_bits-1:0] D_branch_target,
  input  logic             D_branch_val
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Memory Interface
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  MemIntf #(
    .t_req_msg  (t_mem_req_msg_32_32_8), 
    .t_resp_msg (t_mem_resp_msg_32_32_8)
  ) mem;

  assign mem_req_val  = mem.req_val;
  assign mem_req_msg  = mem.req_msg;
  assign mem_resp_rdy = mem.resp_rdy;

  assign mem.req_rdy  = mem_req_rdy;
  assign mem.resp_val = mem_resp_val;
  assign mem.resp_msg = mem_resp_msg;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Memory Interface
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  F__DIntf #(
    .p_addr_bits (p_addr_bits),
    .p_inst_bits (p_inst_bits)
  ) D;

  assign D_inst          = D.inst;
  assign D_pc            = D.pc;
  assign D_val           = D.val;

  assign D.rdy           = D_rdy;
  assign D.squash        = D_squash;
  assign D.branch_target = D_branch_target;
  assign D.branch_val    = D_branch_val;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module Instantiation
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Fetch #( 
    .p_rst_addr  (p_rst_addr),
    .p_addr_bits (p_addr_bits),
    .p_opaq_bits (p_opaq_bits)
  ) fetch ( .* );

endmodule

`endif // HW_FETCH_FLAT_FETCH_FLAT_V
