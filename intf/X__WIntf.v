//========================================================================
// X__WIntf.v
//========================================================================
// The interface definition going between X and W

`ifndef INTF_X__W_INTF_V
`define INTF_X__W_INTF_V

//------------------------------------------------------------------------
// X__WIntf
//------------------------------------------------------------------------

interface X__WIntf
#(
  parameter p_seq_num_bits = 5
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic               [31:0] pc;
  logic [p_seq_num_bits-1:0] seq_num;
  logic                [4:0] waddr;
  logic               [31:0] wdata;
  logic                      wen;
  logic                      val;
  logic                      rdy;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  modport X_intf (
    output pc,
    output seq_num,
    output waddr,
    output wdata,
    output wen,
    output val,
    input  rdy
  );

  modport W_intf (
    input  pc,
    input  seq_num,
    input  waddr,
    input  wdata,
    input  wen,
    input  val,
    output rdy
  );

endinterface

`endif // INTF_X__W_INTF_V
