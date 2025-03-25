//========================================================================
// InstRouter.v
//========================================================================
// A router for instructions in a decode unit, to send instructions to the
// correct pipe

`ifndef HW_DECODE_INSTROUTER_V
`define HW_DECODE_INSTROUTER_V

`include "defs/UArch.v"

import UArch::*;

//------------------------------------------------------------------------
// InstRouterUnit
//------------------------------------------------------------------------
// An individual instruction router for a specific pipe

module InstRouterUnit #(
  parameter p_isa_subset = p_tinyrv1
) (
  input  rv_uop uop,
  input  logic  uop_val,
  input  logic  already_found,
  input  logic  rdy,

  output logic  val,
  output logic  been_found
);

  logic val_uop;
  
  generate
    always_comb begin
      val_uop = 0;

      if( ( p_isa_subset & OP_ADD_VEC   ) > 0 ) val_uop |= ( uop == OP_ADD   );
      if( ( p_isa_subset & OP_SUB_VEC   ) > 0 ) val_uop |= ( uop == OP_SUB   );
      if( ( p_isa_subset & OP_AND_VEC   ) > 0 ) val_uop |= ( uop == OP_AND   );
      if( ( p_isa_subset & OP_OR_VEC    ) > 0 ) val_uop |= ( uop == OP_OR    );
      if( ( p_isa_subset & OP_XOR_VEC   ) > 0 ) val_uop |= ( uop == OP_XOR   );
      if( ( p_isa_subset & OP_SLT_VEC   ) > 0 ) val_uop |= ( uop == OP_SLT   );
      if( ( p_isa_subset & OP_SLTU_VEC  ) > 0 ) val_uop |= ( uop == OP_SLTU  );
      if( ( p_isa_subset & OP_SRA_VEC   ) > 0 ) val_uop |= ( uop == OP_SRA   );
      if( ( p_isa_subset & OP_SRL_VEC   ) > 0 ) val_uop |= ( uop == OP_SRL   );
      if( ( p_isa_subset & OP_SLL_VEC   ) > 0 ) val_uop |= ( uop == OP_SLL   );
      if( ( p_isa_subset & OP_MUL_VEC   ) > 0 ) val_uop |= ( uop == OP_MUL   );
      if( ( p_isa_subset & OP_LUI_VEC   ) > 0 ) val_uop |= ( uop == OP_LUI   );
      if( ( p_isa_subset & OP_AUIPC_VEC ) > 0 ) val_uop |= ( uop == OP_AUIPC );
      if( ( p_isa_subset & OP_LW_VEC    ) > 0 ) val_uop |= ( uop == OP_LW    );
      if( ( p_isa_subset & OP_SW_VEC    ) > 0 ) val_uop |= ( uop == OP_SW    );
      if( ( p_isa_subset & OP_JAL_VEC   ) > 0 ) val_uop |= ( uop == OP_JAL   );
      if( ( p_isa_subset & OP_JALR_VEC  ) > 0 ) val_uop |= ( uop == OP_JALR  );
      if( ( p_isa_subset & OP_BEQ_VEC   ) > 0 ) val_uop |= ( uop == OP_BEQ   );
      if( ( p_isa_subset & OP_BNE_VEC   ) > 0 ) val_uop |= ( uop == OP_BNE   );
      if( ( p_isa_subset & OP_BLT_VEC   ) > 0 ) val_uop |= ( uop == OP_BLT   );
      if( ( p_isa_subset & OP_BGE_VEC   ) > 0 ) val_uop |= ( uop == OP_BGE   );
      if( ( p_isa_subset & OP_BLTU_VEC  ) > 0 ) val_uop |= ( uop == OP_BLTU  );
      if( ( p_isa_subset & OP_BGEU_VEC  ) > 0 ) val_uop |= ( uop == OP_BGEU  );
    end
  endgenerate

  assign val        = (val_uop & uop_val) & (!already_found);
  assign been_found = (val_uop & rdy)     | already_found;

endmodule

//------------------------------------------------------------------------
// InstRouter
//------------------------------------------------------------------------

module InstRouter #(
  parameter p_num_pipes                                = 3,
  parameter rv_op_vec [p_num_pipes-1:0] p_pipe_subsets = '{default: p_tinyrv1}
) (
  input rv_uop    uop,
  input  logic    val,
  output logic    xfer,

  D__XIntf.D_intf Ex [p_num_pipes-1:0]
);

  // verilator lint_off UNUSEDSIGNAL
  logic found [p_num_pipes:0];
  // verilator lint_on UNUSEDSIGNAL
  assign found[0] = 1'b0;
  
  logic [p_num_pipes-1:0] xfer_vec;
  
  genvar i;
  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin: inst_router_units
      InstRouterUnit #(p_pipe_subsets[i]) router_unit (
        .uop           (uop),
        .uop_val       (val),
        .already_found (found[i]),
        .rdy           (Ex[i].rdy),
        .val           (Ex[i].val),
        .been_found    (found[i+1])
      );

      assign xfer_vec[i] = Ex[i].val & Ex[i].rdy;
    end
  endgenerate

  assign xfer = (|xfer_vec);

endmodule

`endif // HW_DECODE_INSTROUTER_V
