//========================================================================
// CtrlUnit.v
//========================================================================
// Controller for the ROB

`ifndef HW_WRITEBACKCOMMIT_ROB_CTRL_UNIT_V
`define HW_WRITEBACKCOMMIT_ROB_CTRL_UNIT_V

`include "intf/OpDeqFrontIntf.v"
`include "intf/OpInsIntf.v"

module rob_CtrlUnit
#(
  parameter type t_entry     = logic [31:0],
  parameter p_depth          = 4,
  parameter type t_depth_arr = logic [p_depth-1:0],
  parameter type t_addr      = logic [$clog2(p_depth)-1:0]
)(
  input logic clk,
  input logic rst,

  //----------------------------------------------------------------------
  // Deq_front interface
  //----------------------------------------------------------------------

  OpDeqFrontIntf.send_intf deq_front_intf,

  //----------------------------------------------------------------------
  // Insert interface
  //----------------------------------------------------------------------

  OpInsIntf.recv_intf      ins_intf,

  //----------------------------------------------------------------------
  // Data Interface
  //----------------------------------------------------------------------

  output logic       wr_data     [p_depth],
  output t_entry     wr_data_in,
  input  t_entry     data_out    [p_depth],
  output logic       clr_occ     [p_depth],
  input  t_depth_arr occ
);

  t_addr deq_ptr;
  logic  ins_and_deq;
  assign ins_and_deq = deq_ptr == ins_intf.ins_tag && ins_intf.ins_en;

  //----------------------------------------------------------------------
  // Dequeue pointer update sequential logic
  //----------------------------------------------------------------------

  always_ff @(posedge clk) begin
    if (rst) begin
      deq_ptr <= '{default: '0};
    end else if (occ[deq_ptr] || ins_and_deq) deq_ptr <= deq_ptr + t_addr'(1);
  end

  //----------------------------------------------------------------------
  // Data out combinational logic
  //----------------------------------------------------------------------

  always_comb begin
    if (rst) begin
      deq_front_intf.deq_front_data = '{default: '0};
    end else begin
      if (occ[deq_ptr])     deq_front_intf.deq_front_data = data_out[deq_ptr];
      else if (ins_and_deq) deq_front_intf.deq_front_data = ins_intf.ins_data;
      else                  deq_front_intf.deq_front_data = '{default: '0};
    end
  end

  //----------------------------------------------------------------------
  // Operation completion combinational logic
  //----------------------------------------------------------------------

  always_comb begin
    if (rst) begin
      ins_intf.ins_cpl = 1'b0;
      deq_front_intf.deq_front_cpl = 1'b0;
    end else begin
      ins_intf.ins_cpl = ins_intf.ins_en;
      deq_front_intf.deq_front_cpl = (occ[deq_ptr] || ins_and_deq);
    end
  end

  //----------------------------------------------------------------------
  // Register control combinational logic
  //----------------------------------------------------------------------

  always_comb begin
    if (rst) begin
      for (int i = 0; i < p_depth; i++) begin
        wr_data[i]    = 1'b0;
        clr_occ[i]    = 1'b0;
      end
      wr_data_in = '{default: '0};
    end else begin
      for (int i = 0; i < p_depth; i++) begin
        wr_data[i]    = (t_addr'(i) == ins_intf.ins_tag && t_addr'(i) != deq_ptr && ins_intf.ins_en);
        clr_occ[i]    = (t_addr'(i) == deq_ptr);
      end
      wr_data_in = ins_intf.ins_data;
    end
  end

endmodule

`endif
