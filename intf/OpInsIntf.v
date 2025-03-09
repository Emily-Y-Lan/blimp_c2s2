//========================================================================
// OpInsIntf.v
//========================================================================
// The interface definition for operation-centric insert

`ifndef INTF_OP_INS_INTF_V
`define INTF_OP_INS_INTF_V

//------------------------------------------------------------------------
// OpDeqFrontIntf
//------------------------------------------------------------------------

interface OpInsIntf
#(
  parameter type t_entry = logic [31:0],
  parameter type t_addr  = logic [3:0]
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic   ins_en;
  logic   ins_cpl;
  t_addr  ins_tag;
  t_entry ins_data;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  modport recv_intf (
    input  ins_en,
    output ins_cpl,
    input  ins_tag,
    input  ins_data
  );

  modport send_intf (
    output ins_en,
    input  ins_cpl,
    output ins_tag,
    output ins_data
  );

endinterface

`endif // INTF_OP_INS_INTF_V
