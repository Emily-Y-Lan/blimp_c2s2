//========================================================================
// FetchUnitL3.v
//========================================================================
// A basic modular fetch unit for fetching instructions with squashing

`ifndef HW_FETCH_FETCHUNITVARIANTS_FETCHUNITL3_V
`define HW_FETCH_FETCHUNITVARIANTS_FETCHUNITL3_V

`include "hw/fetch/SeqNumGenL3.v"
`include "intf/F__DIntf.v"
`include "intf/MemIntf.v"
`include "intf/CommitNotif.v"
`include "intf/SquashNotif.v"

module FetchUnitL3
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

  CommitNotif.sub commit,

  //----------------------------------------------------------------------
  // Squash Interface
  //----------------------------------------------------------------------

  SquashNotif.sub squash
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
    else if ( squash.val & memreq_xfer )
      curr_addr <= squash.target + 4;
    else if ( squash.val )
      curr_addr <= squash.target;
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
    if ( squash.val )
      mem.req_msg.addr = squash.target;
    else
      mem.req_msg.addr = curr_addr;
  end

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Other request signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic [p_opaq_bits-1:0] req_opaque_next;
  logic [p_opaq_bits-1:0] req_opaque;

  assign req_opaque_next = req_opaque + 1;

  always_ff @( posedge clk ) begin
    if ( rst )
      req_opaque <= '0;
    else if ( squash.val )
      req_opaque <= req_opaque_next;
  end

  always_comb begin
    // Easier than tracking whether our opaque bits will wrap around for
    // an outstanding request
    mem.req_val        = (num_in_flight < p_max_in_flight);

    mem.req_msg.op     = MEM_MSG_READ;
    mem.req_msg.opaque = ( squash.val ) ? req_opaque_next : req_opaque;
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
                     | squash.val;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Allocation
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic                      alloc_val;
  logic                      alloc_rdy;
  logic [p_seq_num_bits-1:0] alloc_seq_num;

  SeqNumGenL3 #(
    .p_seq_num_bits  (p_seq_num_bits),
    .p_reclaim_width (p_reclaim_width)
  ) seq_num_gen (
    .*
  );

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Other response signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  always_comb begin
    mem.resp_rdy = (D.rdy & alloc_val) | should_drop;
    alloc_rdy    = mem.resp_val & D.rdy     & !should_drop;
    D.val        = mem.resp_val & alloc_val & !should_drop;
    D.inst       = mem.resp_msg.data;
    D.pc         = mem.resp_msg.addr;
    D.seq_num    = alloc_seq_num;
  end

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Unused signals
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic                      unused_resp_op;
  logic                [3:0] unused_resp_len;
  logic [p_seq_num_bits-1:0] unused_squash_seq_num;

  always_comb begin
    unused_resp_op  = mem.resp_msg.op;
    unused_resp_len = mem.resp_msg.len;

    unused_squash_seq_num = squash.seq_num;
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

`endif // HW_FETCH_FETCHUNITVARIANTS_FETCHUNITL3_V
