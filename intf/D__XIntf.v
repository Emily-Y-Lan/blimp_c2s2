//========================================================================
// D__XIntf.v
//========================================================================
// The interface definition going between D and X

`ifndef INTF_D__X_INTF_V
`define INTF_D__X_INTF_V

interface D__XIntf
#(
  parameter p_num_pipes = 1,
  parameter p_addr_bits = 32,
  parameter p_data_bits = 32
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic [p_addr_bits-1:0] pc       [p_num_pipes-1:0];
  logic [p_data_bits-1:0] op1      [p_num_pipes-1:0];
  logic [p_data_bits-1:0] op2      [p_num_pipes-1:0];
  // Do union-y stuff for metadata
  logic                   val      [p_num_pipes-1:0];
  logic                   rdy      [p_num_pipes-1:0];

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

endinterface

`endif // INTF_F__D_INTF_V
