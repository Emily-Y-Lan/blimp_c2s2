//========================================================================
// ROB.v
//========================================================================
// A basic reorder buffer to ensure in-order commit

`ifndef HW_WRITEBACK_ROB_V
`define HW_WRITEBACK_ROB_V

module ROB #(
  parameter p_depth    = 32,
  parameter type t_msg = logic [31:0],

  parameter p_entry_bits = $clog2( p_depth )
)(
  input  logic clk,
  input  logic rst,

  //----------------------------------------------------------------------
  // Insert
  //----------------------------------------------------------------------

  input  logic [p_entry_bits-1:0] ins_idx,
  input  t_msg                    ins_msg,
  input  logic                    ins_en,

  //----------------------------------------------------------------------
  // Dequeue
  //----------------------------------------------------------------------

  output logic [p_entry_bits-1:0] deq_idx,
  output t_msg                    deq_msg,
  input  logic                    deq_en,
  output logic                    deq_rdy
);

  //----------------------------------------------------------------------
  // Entries
  //----------------------------------------------------------------------

  typedef struct {
    t_msg msg;
    logic val;
  } t_entry;

  t_entry entries [p_depth];

  //----------------------------------------------------------------------
  // Update Logic
  //----------------------------------------------------------------------

  logic [p_entry_bits-1:0] deq_ptr;
  logic                    bypass;

  always_ff @( posedge clk ) begin
    if( rst )
      entries <= '{default: '{msg: 'x, val: 1'b0}};
    else begin
      if( ins_en & !bypass ) begin
        entries[ins_idx] <= '{
          msg: ins_msg,
          val: 1'b1
        };
      end
      if( deq_en & deq_rdy ) begin
        entries[deq_ptr] <= '{msg: 'x, val: 1'b0};
      end
    end
  end

  //----------------------------------------------------------------------
  // Bypass
  //----------------------------------------------------------------------

  logic can_bypass;
  assign can_bypass = ( ins_idx == deq_ptr );

  assign bypass = ins_en & deq_en & can_bypass;

  //----------------------------------------------------------------------
  // Dequeue
  //----------------------------------------------------------------------

  logic [p_entry_bits-1:0] deq_ptr_next;

  always_ff @( posedge clk ) begin
    if( rst )
      deq_ptr <= '0;
    else if( deq_en & deq_rdy )
      deq_ptr <= deq_ptr_next;
  end

  always_comb begin
    if( deq_ptr == p_entry_bits'(p_depth - 1) )
      deq_ptr_next = '0;
    else 
      deq_ptr_next = deq_ptr + 1;
  end

  assign deq_rdy = entries[deq_ptr].val | ( can_bypass & ins_en );
  assign deq_msg = ( bypass ) ? ins_msg : entries[deq_ptr].msg;
  assign deq_idx = ( bypass ) ? ins_idx : deq_ptr;

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

`ifndef SYNTHESIS
  string test_trace;
  int    msg_len;

  initial begin
    test_trace = $sformatf("%x:%x", ins_idx, ins_msg);
    msg_len = test_trace.len();
  end

  function string trace();
    if( ins_en )
      trace = $sformatf("%x:%x", ins_idx, ins_msg);
    else 
      trace = {(msg_len){" "}};

    trace = {trace, " > "};

    if( deq_en & deq_rdy )
      trace = $sformatf("%x:%x", deq_idx, deq_msg);
    else 
      trace = {(msg_len){" "}};
  endfunction
`endif

endmodule

`endif // HW_WRITEBACK_ROB_V
