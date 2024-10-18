//========================================================================
// DecodeTestInft.v
//========================================================================
// A FL model of the Decode interface, to use in testing

`include "intf/F__DIntf.v"

module DecodeTestIntf #(
  parameter p_init_delay = 0,
  parameter p_intv_delay = 0,

  parameter p_addr_bits = 32,
  parameter p_inst_bits = 32,
  parameter p_opaq_bits = 8
)(
  F__DIntf.D_intf F
);

  //----------------------------------------------------------------------
  // Store expected results in memory
  //----------------------------------------------------------------------

  typedef struct {
    logic [p_inst_bits-1:0] exp_inst;
    logic [p_addr_bits-1:0] exp_pc;
    logic                   dut_squash;
    logic [p_addr_bits-1:0] dut_branch_target;
    logic                   dut_branch_val;
  } transaction;

endmodule