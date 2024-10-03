//========================================================================
// Mem.v
//========================================================================
// Paremetrized interfaces for communicating with memory

`ifndef INTF_MEM_INTF_V
`define INTF_MEM_INTF_V

//------------------------------------------------------------------------
// MemReq Interface
//------------------------------------------------------------------------

interface MemReq
#(
  parameter DATA_BITS = 32,
  parameter ADDR_BITS = 32,
  parameter OPAQ_BITS = 8
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  localparam LEN_BITS = DATA_BITS / 8;

  typedef enum logic {
    READ  = 1'b0,
    WRITE = 1'b1
  } op_type;

  op_type               op;
  logic [OPAQ_BITS-1:0] opaque;
  logic [ADDR_BITS-1:0] addr;
  logic [ LEN_BITS-1:0] len;
  logic [DATA_BITS-1:0] data;
  logic                 val;
  logic                 rdy;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  modport cpu_intf (
    output op,
    output opaque,
    output addr,
    output len,
    output data,
    output val,
    input  rdy
  );

  modport mem_intf (
    input  op,
    input  opaque,
    input  addr,
    input  len,
    input  data,
    input  val,
    output rdy
  );

endinterface

//------------------------------------------------------------------------
// MemResp Interface
//------------------------------------------------------------------------

interface MemResp
#(
  parameter DATA_BITS = 32,
  parameter OPAQ_BITS = 8
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  localparam LEN_BITS = DATA_BITS / 8;

  typedef enum logic {
    READ  = 1'b0,
    WRITE = 1'b1
  } op_type;

  op_type               op;
  logic [OPAQ_BITS-1:0] opaque;
  logic [ LEN_BITS-1:0] len;
  logic [DATA_BITS-1:0] data;
  logic                 val;
  logic                 rdy;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Module-facing Ports
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  modport cpu_intf (
    input  op,
    input  opaque,
    input  len,
    input  data,
    input  val,
    output rdy
  );

  modport mem_intf (
    output op,
    output opaque,
    output len,
    output data,
    output val,
    input  rdy
  );

endinterface

`endif // INTF_MEM_INTF_V
