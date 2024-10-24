//========================================================================
// MemMsg.v
//========================================================================
// The type of default message to use when communicating with memory

`ifndef TYPES_MEMMSG_V
`define TYPES_MEMMSG_V

typedef enum logic {
  MEM_MSG_READ  = 1'b0,
  MEM_MSG_WRITE = 1'b1,
  MEM_MSG_X     = 1'bx
} t_op;

virtual class MemMsg;
  localparam p_data_bits = 32;
  localparam p_addr_bits = 32;
  localparam p_opaq_bits = 8;

  localparam p_len_bits  = p_data_bits / 8;

  typedef logic [p_opaq_bits-1:0] t_opaque;
  typedef logic [p_addr_bits-1:0] t_addr;
  typedef logic [ p_len_bits-1:0] t_len;
  typedef logic [p_data_bits-1:0] t_data;

  typedef struct packed {
    t_op     op;
    t_opaque opaque;
    t_addr   addr;
    t_len    len;
    t_data   data;
  } t_req_msg;

  typedef struct packed {
    t_op     op;
    t_opaque opaque;
    t_addr   addr;
    t_len    len;
    t_data   data;
  } t_resp_msg;
endclass

typedef MemMsg::t_req_msg  t_mem_req_msg_32_32_8;
typedef MemMsg::t_resp_msg t_mem_resp_msg_32_32_8;

`endif // TYPES_MEMMSG_V
