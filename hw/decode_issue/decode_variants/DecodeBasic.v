//========================================================================
// DecodeBasic.v
//========================================================================
// A basic in-order, single-issue decoder that implements TinyRV1

`ifndef HW_DECODE_DECODE_VARIANTS_BASIC_V
`define HW_DECODE_DECODE_VARIANTS_BASIC_V

`include "hw/common/PriorityEncoder.v"
`include "hw/decode_issue/Decoder.v"
`include "hw/decode_issue/ImmGen.v"
`include "hw/decode_issue/Regfile.v"
`include "intf/F__DIntf.v"
`include "intf/D__XIntf.v"

module DecodeBasic #(
  parameter p_num_pipes = 1
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
    else
      F_reg_next = '{ val: 1'b0, inst: 'x, pc: 'x };
  end

  //----------------------------------------------------------------------
  // Determine whether we're ready, based on the pipes
  //----------------------------------------------------------------------

  logic intf_val    [p_num_pipes-1:0];
  logic intf_rdy    [p_num_pipes-1:0];
  logic transac_rdy [p_num_pipes-1:0];

  genvar i;
  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin: rdy_logic
      assign Ex[i].val = intf_val[i] & F_reg.val;
      assign intf_rdy[i] = Ex[i].rdy;

      // Indicate we're ready only if that pipe is valid
      assign transac_rdy[i] = Ex[i].rdy & Ex[i].val;
    end
  endgenerate

  assign F.rdy = intf_rdy.or();

  //----------------------------------------------------------------------
  // Arbitrate between decoders, if needed
  //----------------------------------------------------------------------

  logic [p_num_pipes-1:0] decoder_val;
  logic [p_num_pipes-1:0] decoder_arb_val;

  PriorityEncoder #(p_num_pipes) decoder_arb (
    .in  (decoder_val),
    .out (decoder_arb_val)
  );

  //----------------------------------------------------------------------
  // Instantiate decoder for each pipe
  //----------------------------------------------------------------------

  logic [4:0]  decoder_raddr0  [p_num_pipes-1:0];
  logic [4:0]  decoder_raddr1  [p_num_pipes-1:0];
  rv_imm_type  decoder_imm_sel [p_num_pipes-1:0];
  logic        decoder_op2_sel [p_num_pipes-1:0];

  genvar j;
  generate
    for( j = 0; j < p_num_pipes; j = j + 1 ) begin: decoders
      logic [4:0] raddr0;
      logic [4:0] raddr1;
      rv_imm_type imm_sel;
      logic       op2_sel;

      Decoder #(
        .p_isa_subset (Ex[j].p_isa_subset),
        .p_inst_bits  (p_inst_bits)
      ) decoder (
        .inst    (F_reg.inst),
        .val     (decoder_val[j]),
        .uop     (Ex[j].uop),
        .raddr0  (raddr0),
        .raddr1  (raddr1),
        .imm_sel (imm_sel),
        .op2_sel (op2_sel)
      );

      always_comb begin
        if( decoder_arb_val[j] ) begin
          decoder_raddr0[j]  = raddr0;
          decoder_raddr1[j]  = raddr1;
          decoder_imm_sel[j] = imm_sel;
          decoder_op2_sel[j] = op2_sel;
        end else begin
          decoder_raddr0[j]  = '0;
          decoder_raddr1[j]  = '0;
          decoder_imm_sel[j] = rv_imm_type'('0);
          decoder_op2_sel[j] = '0;
        end
      end
    end
  endgenerate

  //----------------------------------------------------------------------
  // Determine actual control signals
  //----------------------------------------------------------------------

  logic [4:0] raddr0;
  logic [4:0] raddr1;
  rv_imm_type imm_sel;
  logic       op2_sel;

  assign raddr0  = decoder_raddr0.or();
  assign raddr1  = decoder_raddr1.or();
  assign imm_sel = decoder_imm_sel.or();
  assign op2_sel = decoder_op2_sel.or();

  //----------------------------------------------------------------------
  // Instantiate Register File and Immediate Generator
  //----------------------------------------------------------------------

  logic [p_inst_bits-1:0] rdata0, rdata1;

  Regfile #(
    .t_entry (logic [p_inst_bits-1:0]),
    .p_num_regs (32)
  ) regfile (
    .clk   (clk),
    .rst   (rst),
    .raddr ({raddr1, raddr0}),
    .rdata ({rdata1, rdata0}),
    .waddr ('0),
    .wdata ('0),
    .wen   ('0)
  );

  logic [31:0] imm;

  ImmGen imm_gen (
    .inst    (F_reg.inst),
    .imm_sel (imm_sel),
    .imm     (imm)
  );

  //----------------------------------------------------------------------
  // Pass remaining signals to pipes
  //----------------------------------------------------------------------
  
  logic [p_inst_bits-1:0] op1, op2;

  always_comb begin
    op1 = rdata0;
    if ( op2_sel )
      op2 = imm;
    else
      op2 = rdata1;
  end

  genvar k;
  generate
    for( k = 0; k < p_num_pipes; k = k + 1 ) begin: pipe_signals
      assign Ex[k].pc  = F_reg.pc;
      assign Ex[k].op1 = op1;
      assign Ex[k].op2 = op2;
      
      logic unused_squash;
      logic [p_addr_bits-1:0] unused_branch_target;

      assign unused_squash = Ex[k].squash;
      assign unused_branch_target = Ex[k].branch_target;
    end
  endgenerate

endmodule

`endif // HW_DECODE_DECODE_VARIANTS_BASIC_V
