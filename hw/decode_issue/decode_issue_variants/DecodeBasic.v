//========================================================================
// DecodeBasic.v
//========================================================================
// A basic in-order, single-issue decoder that implements TinyRV1

`ifndef HW_DECODE_DECODE_VARIANTS_BASIC_V
`define HW_DECODE_DECODE_VARIANTS_BASIC_V

`include "defs/ISA.v"
`include "hw/decode_issue/Decoder.v"
`include "hw/decode_issue/ImmGen.v"
`include "hw/decode_issue/InstRouter.v"
`include "hw/decode_issue/Regfile.v"
`include "intf/F__DIntf.v"
`include "intf/D__XIntf.v"
`include "test/asm/rv32/disassemble32.v"

import ISA::*;

module DecodeBasic #(
  parameter p_isa_subset                               = p_tinyrv1,
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
  F_input F_reg_next;
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
    else if ( F.rdy ) // The receiver is ready
      F_reg_next = '{ val: 1'b0, inst: 'x, pc: 'x };
    else
      F_reg_next = F_reg;
  end

  //----------------------------------------------------------------------
  // Instantiate Decoder, Regfile, ImmGen
  //----------------------------------------------------------------------

  rv_uop      decoder_uop;
  logic [4:0] decoder_raddr0;
  logic [4:0] decoder_raddr1;
  logic [4:0] decoder_waddr;
  rv_imm_type decoder_imm_sel;
  logic       decoder_op2_sel;

  // verilator lint_off UNUSEDSIGNAL
  logic       decoder_wen;
  // verilator lint_on UNUSEDSIGNAL
  
  Decoder #(
    .p_isa_subset (p_isa_subset),
    .p_inst_bits  (p_inst_bits)
  ) decoder (
    .inst    (F_reg.inst),
    .uop     (decoder_uop),
    .raddr0  (decoder_raddr0),
    .raddr1  (decoder_raddr1),
    .waddr   (decoder_waddr),
    .wen     (decoder_wen),
    .imm_sel (decoder_imm_sel),
    .op2_sel (decoder_op2_sel)
  );

  logic [p_inst_bits-1:0] rdata0, rdata1;

  Regfile #(
    .t_entry (logic [p_inst_bits-1:0]),
    .p_num_regs (32)
  ) regfile (
    .clk   (clk),
    .rst   (rst),
    .raddr ({decoder_raddr1, decoder_raddr0}),
    .rdata ({rdata1, rdata0}),
    .waddr ('0),
    .wdata ('0),
    .wen   ('0)
  );

  logic [31:0] imm;

  ImmGen imm_gen (
    .inst    (F_reg.inst),
    .imm_sel (decoder_imm_sel),
    .imm     (imm)
  );

  //----------------------------------------------------------------------
  // Route the instruction (set val/rdy for pipes) based on uop
  //----------------------------------------------------------------------

  InstRouter #(p_num_pipes, p_pipe_subsets) inst_router (
    .uop   (decoder_uop),
    .val   (F_reg.val),
    .Ex    (Ex),
    .F_rdy (F.rdy)
  );

  //----------------------------------------------------------------------
  // Pass remaining signals to pipes
  //----------------------------------------------------------------------
  
  logic [p_inst_bits-1:0] op1, op2;

  always_comb begin
    op1 = rdata0;
    if ( decoder_op2_sel )
      op2 = imm;
    else
      op2 = rdata1;
  end

  genvar k;
  generate
    for( k = 0; k < p_num_pipes; k = k + 1 ) begin: pipe_signals
      assign Ex[k].pc    = F_reg.pc;
      assign Ex[k].op1   = op1;
      assign Ex[k].op2   = op2;
      assign Ex[k].uop   = decoder_uop;
      assign Ex[k].waddr = decoder_waddr;
      
      // logic unused_squash;
      // logic [p_addr_bits-1:0] unused_branch_target;

      // assign unused_squash = Ex[k].squash;
      // assign unused_branch_target = Ex[k].branch_target;
    end
  endgenerate

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

`ifndef SYNTHESIS
  // verilator lint_off UNUSEDSIGNAL
  string trace;
  // verilator lint_on UNUSEDSIGNAL
  
  always_comb begin
    if( F_reg.val & F.rdy )
      trace = $sformatf("%-20s", disassemble32(F_reg.inst) );
    else
      trace = {20{" "}};
  end
`endif

endmodule

`endif // HW_DECODE_DECODE_VARIANTS_BASIC_V
