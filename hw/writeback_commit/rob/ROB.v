//========================================================================
// ROB.v
//========================================================================
// ROB toplevel

`ifndef HW_WRITEBACKCOMMIT_ROB_ROB_V
`define HW_WRITEBACKCOMMIT_ROB_ROB_V

`include "intf/OpDeqFrontIntf.v"
`include "intf/OpInsIntf.v"
`include "hw/writeback_commit/rob/CtrlUnit.v"
`include "hw/writeback_commit/rob/Dpath.v"

module rob_ROB # (
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

  OpInsIntf.recv_intf      ins_intf
);

  logic       wr_data    [p_depth];
  t_entry     wr_data_in;
  t_entry     data_out   [p_depth];
  logic       clr_occ    [p_depth];
  t_depth_arr occ;

  //----------------------------------------------------------------------
  // Control unit
  //----------------------------------------------------------------------

  rob_CtrlUnit #(
    .t_entry     (t_entry),
    .p_depth     (p_depth),
    .t_depth_arr (t_depth_arr),
    .t_addr      (t_addr)
  ) ctrl_unit (
    .*
  );

  //----------------------------------------------------------------------
  // Datapath register collection
  //----------------------------------------------------------------------

  rob_Dpath #(
    .t_entry     (t_entry),
    .p_depth     (p_depth),
    .t_depth_arr (t_depth_arr)
  ) dpath (
    .*
  );

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

`ifndef SYNTHESIS
  function string trace();
    string trace_str;
    trace_str = "";
    for (int i = 0; i < p_depth; i++) begin
      if (i == 0) trace_str = {trace_str, $sformatf("%x", data_out[i])};
      else        trace_str = {trace_str, $sformatf(":%x", data_out[i])};
    end
    trace = trace_str;
  endfunction
`endif

endmodule

`endif
