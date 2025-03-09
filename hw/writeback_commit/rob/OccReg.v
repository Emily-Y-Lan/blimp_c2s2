//========================================================================
// OccReg.v
//========================================================================
// Storage element for the ROB with an occupied bit

`ifndef HW_WRITEBACKCOMMIT_ROB_OCC_REG_V
`define HW_WRITEBACKCOMMIT_ROB_OCC_REG_V

module rob_OccReg
#(
  parameter type t_entry = logic [31:0]
)(
  input logic clk,
  input logic rst,

  //----------------------------------------------------------------------
  // Data interface
  //----------------------------------------------------------------------

  input  logic   wr_data,
  input  t_entry wr_data_in, 
  output t_entry data_out,
  input  logic   clr_occ,
  output logic   occ
);

  //----------------------------------------------------------------------
  // Data logic
  //----------------------------------------------------------------------

  always @(posedge clk) begin
    if (rst) begin
      data_out <= '{default: '0};
      occ      <= 1'b0;
    end else begin
      if (wr_data) begin
        data_out <= wr_data_in;
        occ <= 1'b1;
      end else if (clr_occ) occ <= 1'b0;
    end
  end

endmodule

`endif
