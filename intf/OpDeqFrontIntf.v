//========================================================================
// OpDeqFrontIntf.v
//========================================================================
// The interface definition for operation-centric deq_front

`ifndef INTF_OP_DEQ_FRONT_INTF_V
`define INTF_OP_DEQ_FRONT_INTF_V

//------------------------------------------------------------------------
// OpDeqFrontIntf
//------------------------------------------------------------------------

interface OpDeqFrontIntf
#(
  parameter type t_entry = logic [31:0]
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic deq_front_cpl;
  t_entry deq_front_data;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  modport recv_intf (
    input deq_front_cpl,
    input deq_front_data
  );

  modport send_intf (
    output deq_front_cpl,
    output deq_front_data
  );

endinterface

`endif // INTF_OP_DEQ_FRONT_INTF_V
