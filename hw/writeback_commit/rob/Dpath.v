//========================================================================
// Dpath.v
//========================================================================
// Collection of OccReg's that make up the ROB's datapath

`ifndef HW_WRITEBACKCOMMIT_ROB_DPATH_V
`define HW_WRITEBACKCOMMIT_ROB_DPATH_V

`include "hw/writeback_commit/rob/OccReg.v"

module rob_Dpath
#(
  parameter type t_entry     = logic [31:0],
  parameter p_depth          = 4,
  parameter type t_depth_arr = logic [p_depth-1:0]
)(
  input logic clk,
  input logic rst,

  //----------------------------------------------------------------------
  // Data interface
  //----------------------------------------------------------------------

  input  logic       wr_data     [p_depth],
  input  t_entry     wr_data_in,
  output t_entry     data_out    [p_depth],
  input  logic       clr_occ     [p_depth],
  output t_depth_arr occ
);

  //----------------------------------------------------------------------
  // Register generation
  //----------------------------------------------------------------------

  genvar i;
  generate
    for(i = 0; i < p_depth; i++) begin : reg_gen

      rob_OccReg #(
        .t_entry     (t_entry)
      ) dpath_reg (
        .clk               (clk),
        .rst               (rst),
        .wr_data           (wr_data[i]),
        .wr_data_in        (wr_data_in),
        .data_out          (data_out[i]),
        .clr_occ           (clr_occ[i]),
        .occ               (occ[i])
      );
    end

  endgenerate

endmodule

`endif
