//========================================================================
// DecodeBasic.v
//========================================================================
// A basic in-order, single-issue decoder that implements TinyRV1

`ifndef HW_DECODE_DECODE_VARIANTS_BASIC_V
`define HW_DECODE_DECODE_VARIANTS_BASIC_V

`include "hw/decode/ImmGen.v"
`include "hw/decode/Regfile.v"
`include "defs/ISA.v"
`include "intf/F__DIntf.v"
`include "intf/D__XIntf.v"

module Decode (
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

  localparam p_addr_bits = F.p_addr_bits;
  localparam p_inst_bits = F.p_inst_bits;
  
  //----------------------------------------------------------------------
  // Pipeline registers for F interface
  //----------------------------------------------------------------------

  typedef struct packed {
    logic                   val;
    logic [p_inst_bits-1:0] inst;
    logic [p_addr_bits-1:0] pc;
  } F_input;

  F_input F_reg;
  F_input F_reg_next
  logic   F_xfer;

  always_ff @( posedge clk ) begin
    if ( rst )
      F_reg <= '{ val: 1'b0, inst: 'x, pc: 'x };
    else
      F_reg <= F_reg_next;
  end

  always_comb begin
    F_xfer = F.val & F.rdy;

    if ( F_xfer )
      F_reg_next = '{ val: 1'b1, inst: F.inst, pc: F.pc };
    else
      F_reg_next = '{ val: 1'b0, inst: 'x, pc: 'x };
  end

  //----------------------------------------------------------------------
  // Control signal table
  //----------------------------------------------------------------------

  localparam n = 1'd0;
  localparam y = 1'd1;

  localparam arith_inst  = 2'd0;
  localparam mem_inst    = 2'd1;
  localparam branch_inst = 2'd2;

  // OP2 Mux
  localparam op2_rf  = 1'd0;
  localparam op2_imm = 1'd1;

  task cs
  (
    input logic       cs_inst_val,
    input logic [1:0] cs_inst_type,
    input arith_type  cs_arith_type,
    input mem_type    cs_mem_type,
    input branch_type cs_branch_type,
    input imm_type    cs_imm_type,
    input logic       cs_rf_wen
  )
  endtask



endmodule

`endif // HW_DECODE_DECODE_VARIANTS_BASIC_V
