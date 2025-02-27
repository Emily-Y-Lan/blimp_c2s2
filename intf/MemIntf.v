//========================================================================
// MemIntf.v
//========================================================================
// A paremetrized interface for communicating with memory

`ifndef INTF_MEM_IFC_V
`define INTF_MEM_IFC_V

`include "types/MemMsg.v"

interface MemIntf
#(
  parameter type t_req_msg  = `MEM_REQ ( 8 ),
  parameter type t_resp_msg = `MEM_RESP( 8 )
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic      req_val;
  logic      req_rdy;
  t_req_msg  req_msg;

  logic      resp_val;
  logic      resp_rdy;
  t_resp_msg resp_msg;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Modports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  modport client (
    output req_val,
    input  req_rdy,
    output req_msg,

    input  resp_val,
    output resp_rdy,
    input  resp_msg
  );

  modport server (
    input  req_val,
    output req_rdy,
    input  req_msg,

    output resp_val,
    input  resp_rdy,
    output resp_msg
  );

endinterface

`endif // INTF_MEM_INTF_V
