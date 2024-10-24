//========================================================================
// MemMsg.v
//========================================================================
// The type of default message to use when communicating with memory

`ifndef TYPES_MEMMSG_V
`define TYPES_MEMMSG_V

//------------------------------------------------------------------------
// Implement parametrized typed through macro functions
//------------------------------------------------------------------------

typedef enum logic {
  MEM_MSG_READ  = 1'b0,
  MEM_MSG_WRITE = 1'b1,
  MEM_MSG_X     = 1'bx
} t_op;

`define MEM_REQ( DATA_BITS, ADDR_BITS, OPAQ_BITS ) \
  t_mem_req_msg_``DATA_BITS``_``ADDR_BITS``_``OPAQ_BITS``

`define MEM_REQ_DEFINE( DATA_BITS, ADDR_BITS, OPAQ_BITS ) \
  typedef struct packed {                                 \
    t_op                      op;                         \
    logic [OPAQ_BITS-1:0]     opaque;                     \
    logic [ADDR_BITS-1:0]     addr;                       \
    logic [(DATA_BITS/8)-1:0] len;                        \
    logic [DATA_BITS-1:0]     data;                       \
  } `MEM_REQ( DATA_BITS, ADDR_BITS, OPAQ_BITS )

`define MEM_RESP( DATA_BITS, ADDR_BITS, OPAQ_BITS ) \
  t_mem_resp_msg_``DATA_BITS``_``ADDR_BITS``_``OPAQ_BITS``

`define MEM_RESP_DEFINE( DATA_BITS, ADDR_BITS, OPAQ_BITS ) \
  typedef struct packed {                                  \
    t_op                      op;                          \
    logic [OPAQ_BITS-1:0]     opaque;                      \
    logic [ADDR_BITS-1:0]     addr;                        \
    logic [(DATA_BITS/8)-1:0] len;                         \
    logic [DATA_BITS-1:0]     data;                        \
  } `MEM_RESP( DATA_BITS, ADDR_BITS, OPAQ_BITS )

//------------------------------------------------------------------------
// Define commonly-used parametrizations
//------------------------------------------------------------------------

`MEM_REQ_DEFINE ( 32, 32, 8 );
`MEM_RESP_DEFINE( 32, 32, 8 );

`endif // TYPES_MEMMSG_V
