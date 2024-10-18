//========================================================================
// Mux.v
//========================================================================
// A parametrized Mux

`ifndef HW_COMMON_MUX_V
`define HW_COMMON_MUX_V

module Mux
#(
  parameter type t_data = logic [31:0],
  parameter p_num_ports  = 4,

  // Internal parameter
  parameter p_sel_bits = $clog2(p_num_ports)
)(
  input  t_data                 in  [p_num_ports-1:0],
  input  logic [p_sel_bits-1:0] sel,
  output t_data                 out
);

  assign out = in[sel];

endmodule

`endif // HW_COMMON_MUX_V
