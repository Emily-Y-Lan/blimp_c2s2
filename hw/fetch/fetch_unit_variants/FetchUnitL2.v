//========================================================================
// FetchUnitL2.v
//========================================================================
// A modular fetch unit for fetching instructions with sequence numbers

`ifndef HW_FETCH_FETCHUNITVARIANTS_FETCHUNITL2_V
`define HW_FETCH_FETCHUNITVARIANTS_FETCHUNITL2_V

`include "hw/fetch/SeqNumGenL2.v"
`include "intf/CommitNotif.v"
`include "intf/F__DIntf.v"
`include "intf/MemIntf.v"

module FetchUnitL2
#(
  parameter p_opaq_bits     = 8,
  parameter p_reclaim_width = 2
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

  F__DIntf.F_intf D,

  //----------------------------------------------------------------------
  // Commit Interface
  //----------------------------------------------------------------------

  CommitNotif.sub commit
);
  
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Local Parameters
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  localparam p_rst_addr     = 32'h200;
  localparam p_seq_num_bits = D.p_seq_num_bits;
  
  localparam logic [p_opaq_bits:0] p_max_in_flight = 2 ** p_opaq_bits;
  localparam type t_req_msg  = type(mem.req_msg);

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

  logic [31:0] curr_addr;
  logic [31:0] curr_addr_next;

  always_ff @( posedge clk ) begin
    if ( rst )
      curr_addr <= 32'(p_rst_addr);
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
    mem.req_msg.addr = curr_addr;
  end

  always_comb begin
    mem.req_val        = (num_in_flight < p_max_in_flight);
    mem.req_msg.op     = MEM_MSG_READ;
    mem.req_msg.opaque = '0;
    mem.req_msg.len    = '0;
    mem.req_msg.data   = 'x;
  end

  //----------------------------------------------------------------------
  // Response
  //----------------------------------------------------------------------

  logic                      alloc_val;
  logic [p_seq_num_bits-1:0] alloc_seq_num;

  always_comb begin
    mem.resp_rdy = D.rdy & alloc_val;
    D.val        = mem.resp_val & alloc_val;
    D.inst       = mem.resp_msg.data;
    D.pc         = mem.resp_msg.addr;
    D.seq_num    = alloc_seq_num;
  end

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Allocate sequence numbers
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic alloc_rdy;
  assign alloc_rdy = D.rdy & mem.resp_val;

  SeqNumGenL2 #(
    .p_seq_num_bits  (p_seq_num_bits),
    .p_reclaim_width (p_reclaim_width)
  ) seq_num_gen (
    .*
  );

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Unused signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic       unused_resp_op;
  logic [3:0] unused_resp_len;

  always_comb begin
    unused_resp_op  = mem.resp_msg.op;
    unused_resp_len = mem.resp_msg.len;
  end

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

`ifndef SYNTHESIS
  function int ceil_div_4( int val );
    return (val / 4) + ((val % 4) > 0 ? 1 : 0);
  endfunction

  function string trace();
    if( memreq_xfer )
      trace = $sformatf("%h", mem.req_msg.addr);
    else
      trace = {8{" "}};

    trace = {trace, " > "};

    if( memresp_xfer )
      trace = {trace, $sformatf("%h (%h)", mem.resp_msg.addr, D.seq_num)};
    else
      trace = {trace, {(11 + ceil_div_4(p_seq_num_bits)){" "}}};
  endfunction
`endif

endmodule

`endif // HW_FETCH_FETCHUNITVARIANTS_FETCHUNITL2_V
