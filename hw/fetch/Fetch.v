//========================================================================
// Fetch.v
//========================================================================
// A modular fetch unit for fetching instructions

`ifndef HW_FETCH_FETCH_V
`define HW_FETCH_FETCH_V

`include "intf/F__DIntf.v"
`include "intf/MemIntf.v"

module Fetch
#(
  parameter p_rst_addr = 32'b0,

  //----------------------------------------------------------------------
  // Interface Parameters
  //----------------------------------------------------------------------

  parameter p_addr_bits = 32,
  parameter p_inst_bits = 32,
  parameter p_opaq_bits = 8
)
(
  input  logic    clk,
  input  logic    rst,

  //----------------------------------------------------------------------
  // Memory Interface
  //----------------------------------------------------------------------

  MemIntf.client  mem,

  //----------------------------------------------------------------------
  // F <-> D Interface
  //----------------------------------------------------------------------

  F__DIntf.F_intf D
);

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Local Parameters
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  localparam MAX_IN_FLIGHT  = 2 ** p_opaq_bits;
  localparam type t_req_msg = type(mem.req_msg);

  //----------------------------------------------------------------------
  // Request
  //----------------------------------------------------------------------

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Keep track of the number of in-flight requests
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic               memreq_xfer;
  logic               memresp_xfer;

  always_comb begin
    memreq_xfer  = mem.req_val  & mem.req_rdy;
    memresp_xfer = mem.resp_val & mem.resp_rdy;
  end

  logic [p_opaq_bits:0] num_in_flight;
  logic [p_opaq_bits:0] num_in_flight_next;

  always_ff @( posedge clk ) begin
    if ( rst )
      num_in_flight <= '0;
    else
      num_in_flight <= num_in_flight_next;
  end

  always_comb begin
    num_in_flight_next = num_in_flight;

    if ( memreq_xfer & !memresp_xfer )
      num_in_flight_next = num_in_flight + 1;
    if ( memresp_xfer & !memreq_xfer )
      num_in_flight_next = num_in_flight - 1;
  end

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Keep track of the current request address
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic [p_addr_bits-1:0] curr_addr;
  logic [p_addr_bits-1:0] curr_addr_next;

  always_ff @( posedge clk ) begin
    if ( rst )
      curr_addr <= p_rst_addr;
    else if ( D.squash & !memreq_xfer )
      curr_addr <= D.branch_target;
    else if ( memreq_xfer )
      curr_addr <= curr_addr_next;
  end

  always_comb begin
    curr_addr_next = mem.req_msg.addr + 4;
  end

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Determine the correct address to send out
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  always_comb begin
    if ( D.squash )
      mem.req_msg.addr = D.branch_target;
    else
      mem.req_msg.addr = curr_addr;
  end

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Other request signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic [p_opaq_bits-1:0] req_opaque_next;
  logic [p_opaq_bits-1:0] req_opaque;

  always_comb
    req_opaque_next = req_opaque + 1;

  always_ff @( posedge clk ) begin
    if ( rst )
      req_opaque <= '0;
    else if ( D.squash )
      req_opaque <= req_opaque_next;
  end

  always_comb begin
    mem.req_val        = (num_in_flight < MAX_IN_FLIGHT);
    mem.req_msg.op     = MEM_MSG_READ;
    mem.req_msg.opaque = ( D.squash ) ? req_opaque_next : req_opaque;
    mem.req_msg.len    = '0;
    mem.req_msg.data   = 'x;
  end

  //----------------------------------------------------------------------
  // Response
  //----------------------------------------------------------------------

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Dropped squashed messages
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic should_drop;
  assign should_drop = (mem.resp_msg.opaque != mem.req_msg.opaque)
                     | D.squash;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Other response signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  always_comb begin
    mem.resp_rdy = D.rdy | should_drop;
    D.val        = mem.resp_val & !should_drop;
    D.inst       = mem.resp_msg.data;
    D.pc         = mem.resp_msg.addr;
  end

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Unused signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  parameter p_len_bits = p_inst_bits / 8;

  logic                  unused_resp_op;
  logic [p_len_bits-1:0] unused_resp_len;

  always_comb begin
    unused_resp_op  = mem.resp_msg.op;
    unused_resp_len = mem.resp_msg.len;
  end

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

`ifndef SYNTHESIS
  string trace;
  always_comb
    trace = $sformatf("(%h)", req_opaque);
`endif

endmodule

`endif // HW_FETCH_FETCH_V
