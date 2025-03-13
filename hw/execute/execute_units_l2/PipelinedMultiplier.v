//========================================================================
// PipelinedMultiplier.v
//========================================================================
// A multiplier with a parametrizable latency

`ifndef HW_EXECUTE_EXECUTE_VARIANTS_L2_PIPELINEDMULTIPLIER_V
`define HW_EXECUTE_EXECUTE_VARIANTS_L2_PIPELINEDMULTIPLIER_V

`include "defs/UArch.v"
`include "intf/D__XIntf.v"
`include "intf/X__WIntf.v"

import UArch::*;

module PipelinedMultiplier #(
  parameter p_pipeline_stages = 1
)(
  input  logic clk,
  input  logic rst,

  //----------------------------------------------------------------------
  // D <-> X Interface
  //----------------------------------------------------------------------

  D__XIntf.X_intf D,

  //----------------------------------------------------------------------
  // X <-> W Interface
  //----------------------------------------------------------------------

  X__WIntf.X_intf W
);

  localparam p_seq_num_bits = D.p_seq_num_bits;
  
  //----------------------------------------------------------------------
  // Register inputs
  //----------------------------------------------------------------------

  typedef struct packed {
    logic                      val;
    logic               [31:0] pc;
    logic [p_seq_num_bits-1:0] seq_num;
    logic               [31:0] op1;
    logic               [31:0] op2;
    logic                [4:0] waddr;
    rv_uop                     uop;
  } D_input;

  typedef struct packed {
    logic               [31:0] pc;
    logic [p_seq_num_bits-1:0] seq_num;
    logic                [4:0] waddr;
    logic               [31:0] wdata;
    logic                      wen;
    logic                      val;
  } W_input;

  D_input D_reg;
  D_input D_reg_next;
  W_input mul_output;
  logic   D_xfer;
  logic   W_xfer;
  logic   mul_output_rdy;

  // verilator lint_off ENUMVALUE

  always_ff @( posedge clk ) begin
    if ( rst )
      D_reg <= '{ 
        val:     1'b0, 
        pc:      'x,
        seq_num: 'x,
        op1:     'x, 
        op2:     'x,
        waddr:   'x,
        uop:     'x
      };
    else
      D_reg <= D_reg_next;
  end

  always_comb begin
    D_xfer = D.val & D.rdy;
    W_xfer = mul_output.val & mul_output_rdy;

    if ( D_xfer )
      D_reg_next = '{ 
        val:     1'b1, 
        pc:      D.pc,
        seq_num: D.seq_num,
        op1:     D.op1, 
        op2:     D.op2,
        waddr:   D.waddr,
        uop:     D.uop
      };
    else if ( W_xfer )
      D_reg_next = '{ 
        val:     1'b0, 
        pc:      'x,
        seq_num: 'x,
        op1:     'x, 
        op2:     'x,
        waddr:   'x,
        uop:     'x
      };
    else
      D_reg_next = D_reg;
  end

  // verilator lint_on ENUMVALUE

  //----------------------------------------------------------------------
  // Arithmetic Operations
  //----------------------------------------------------------------------
  
  logic [31:0] op1, op2;
  assign op1 = D_reg.op1;
  assign op2 = D_reg.op2;

  rv_uop uop;
  assign uop = D_reg.uop;

  always_comb begin
    case( uop )
      OP_MUL:  mul_output.wdata = op1 * op2;
      default: mul_output.wdata = 'x;
    endcase
  end

  //----------------------------------------------------------------------
  // Assign remaining output signals
  //----------------------------------------------------------------------

  assign D.rdy = mul_output_rdy | (!D_reg.val);
  assign mul_output.val = D_reg.val;

  assign mul_output.pc      = D_reg.pc;
  assign mul_output.wen     = 1'b1;
  assign mul_output.seq_num = D_reg.seq_num;
  assign mul_output.waddr   = D_reg.waddr;

  //----------------------------------------------------------------------
  // Pipeline stages
  //----------------------------------------------------------------------

  W_input pipeline_outputs [p_pipeline_stages];
  logic   pipeline_rdy     [p_pipeline_stages]/* verilator split_var */;

  assign pipeline_outputs[0] = mul_output;
  assign mul_output_rdy      = pipeline_rdy[0];

  assign W.val     = pipeline_outputs[p_pipeline_stages-1].val;
  assign W.pc      = pipeline_outputs[p_pipeline_stages-1].pc;
  assign W.seq_num = pipeline_outputs[p_pipeline_stages-1].seq_num;
  assign W.waddr   = pipeline_outputs[p_pipeline_stages-1].waddr;
  assign W.wdata   = pipeline_outputs[p_pipeline_stages-1].wdata;
  assign W.wen     = pipeline_outputs[p_pipeline_stages-1].val;
  assign pipeline_rdy[p_pipeline_stages-1] = W.rdy;

  genvar i;
  generate
    for( i = 1; i < p_pipeline_stages; i = i + 1 ) begin
      always_ff @( posedge clk ) begin
        if( rst )
          pipeline_outputs[i] <= '0; // Invalid
        else if( pipeline_outputs[i - 1].val & pipeline_rdy[i - 1] )
          pipeline_outputs[i] <= pipeline_outputs[i - 1];
        else if( pipeline_outputs[i].val & pipeline_rdy[i] )
          pipeline_outputs[i] <= '0; // Invalid
      end
      assign pipeline_rdy[i - 1] = pipeline_rdy[i] |
                                   !( pipeline_outputs[i - 1].val );
    end
  endgenerate

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

`ifndef SYNTHESIS
  function int ceil_div_4( int val );
    return (val / 4) + ((val % 4) > 0 ? 1 : 0);
  endfunction

  int str_len;
  assign str_len = 11                         + 1 + // uop
                   ceil_div_4(p_seq_num_bits) + 1 + // seq_num
                   ceil_div_4(5)              + 1 + // waddr
                   8                          + 1 + // op1
                   8                          + 1 + // op2
                   8;                               // wdata

  function string trace();
    if( W.val & W.rdy )
      trace = $sformatf("%11s:%h:%h:%h:%h:%h", D_reg.uop.name(), 
                        W.seq_num, W.waddr, op1, op2, W.wdata );
    else
      trace = {str_len{" "}};
  endfunction
`endif

endmodule

`endif // HW_EXECUTE_EXECUTE_VARIANTS_L2_PIPELINEDMULTIPLIER_V
