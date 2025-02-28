//========================================================================
// F__DIntf.v
//========================================================================
// The interface definition going between F and D

`ifndef INTF_F__D_INTF_V
`define INTF_F__D_INTF_V

interface F__DIntf
#(
  parameter p_seq_num_bits = 5
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic               [31:0] inst;
  logic [p_seq_num_bits-1:0] seq_num;
  logic               [31:0] pc;
  logic                      val;
  logic                      rdy;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  modport F_intf (
    output inst,
    output seq_num,
    output pc,
    output val,
    input  rdy
  );

  modport D_intf (
    input  inst,
    output seq_num,
    input  pc,
    input  val,
    output rdy
  );

endinterface

`endif // INTF_F__D_INTF_V
