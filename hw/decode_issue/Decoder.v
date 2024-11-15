//========================================================================
// Decoder.v
//========================================================================
// A parametrized decoder to linearize opcodes

`ifndef HW_DECODE_DECODER_V
`define HW_DECODE_DECODER_V

`include "hw/decode_issue/decoder_variants/DecoderRV32.v"

module Decoder #(
  parameter p_isa_subset = p_tinyrv1,
  parameter p_inst_bits  = 32
) (
  input  logic [p_inst_bits-1:0] inst,

  output rv_uop                  uop,
  output logic [4:0]             raddr0,
  output logic [4:0]             raddr1,
  output rv_imm_type             imm_sel,
  output logic                   op2_sel
);

  generate
    //--------------------------------------------------------------------
    // RV32I
    //--------------------------------------------------------------------

    if ( p_inst_bits == 32 ) begin
      DecoderRV32 #(
        .p_isa_subset (p_isa_subset)
      ) decoder (
        .*
      );
    end

    else begin
      $error("Unsupported instruction size: '%d'", p_inst_bits);
    end
  endgenerate

endmodule

`endif // HW_DECODE_DECODER_V
