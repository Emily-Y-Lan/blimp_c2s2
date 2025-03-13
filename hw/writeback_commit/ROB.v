//========================================================================
// ROB.v
//========================================================================
// ROB implementation

`ifndef HW_WRITEBACKCOMMIT_ROB_ROB_V
`define HW_WRITEBACKCOMMIT_ROB_ROB_V

typedef struct packed {
  logic [1:0]  seq_num;
  logic [31:0] pc;
  logic [4:0]  waddr;
  logic [31:0] wdata;
  logic wen;
} t_rob_data;

module ROB # (
  parameter type t_entry     = t_rob_data,
  parameter p_depth          = 4
)(
  input logic clk,
  input logic rst,

  //----------------------------------------------------------------------
  // Deq_front interface
  //----------------------------------------------------------------------

  input  logic   deq_front_en,
  output logic   deq_front_rdy,
  output t_entry deq_front_data,

  //----------------------------------------------------------------------
  // Insert interface
  //----------------------------------------------------------------------

  input  logic   ins_en,
  output logic   ins_rdy,
  input  t_entry ins_data 
);

  logic               wr_data    [p_depth];
  t_entry             wr_data_in;
  t_entry             data_out   [p_depth];
  logic               clr_occ    [p_depth];
  logic [p_depth-1:0] occ;

  //----------------------------------------------------------------------
  // Control unit
  //----------------------------------------------------------------------

  logic [$clog2(p_depth)-1:0] deq_ptr;
  logic                       ins_and_deq;
  assign ins_and_deq = (deq_ptr == ins_data.seq_num && ins_en);

  //----------------------------------------------------------------------
  // Dequeue pointer update sequential logic
  //----------------------------------------------------------------------

  always_ff @(posedge clk) begin
    if (rst) begin
      deq_ptr <= '{default: '0};
    end else if ((occ[deq_ptr] || ins_and_deq) && deq_front_en) deq_ptr <= deq_ptr + $clog2(p_depth)'(1);
  end

  //----------------------------------------------------------------------
  // Data out combinational logic
  //----------------------------------------------------------------------

  always_comb begin
    if (rst) begin
      deq_front_data = '{default: '0};
    end else begin
      if (occ[deq_ptr])     deq_front_data = data_out[deq_ptr];
      else if (ins_and_deq) deq_front_data = ins_data;
      else                  deq_front_data = '{default: '0};
    end
  end

  //----------------------------------------------------------------------
  // Operation completion combinational logic
  //----------------------------------------------------------------------

  always_comb begin
    if (rst) begin
      ins_rdy = 1'b0;
      deq_front_rdy = 1'b0;
    end else begin
      ins_rdy       = 1'b1;
      deq_front_rdy = occ[deq_ptr] || ins_and_deq;
    end
  end

  //----------------------------------------------------------------------
  // Register control combinational logic
  //----------------------------------------------------------------------

  always_comb begin
    if (rst) begin
      for (int i = 0; i < p_depth; i++) begin
        wr_data[i]    = 1'b0;
        clr_occ[i]    = 1'b0;
      end
      wr_data_in = '{default: '0};
    end else begin
      for (int i = 0; i < p_depth; i++) begin
        wr_data[i]    = ($clog2(p_depth)'(i) == ins_data.seq_num && $clog2(p_depth)'(i) != deq_ptr && ins_en);
        clr_occ[i]    = ($clog2(p_depth)'(i) == deq_ptr);
      end
      wr_data_in = ins_data;
    end
  end

  //----------------------------------------------------------------------
  // Datapath register collection
  //----------------------------------------------------------------------

  genvar i;
  generate
    for(i = 0; i < p_depth; i++) begin : reg_gen
      always @(posedge clk) begin
        if (rst) begin
          data_out[i] <= '{default: '0};
          occ[i]      <= 1'b0;
        end else begin
          if (wr_data[i]) begin
            data_out[i] <= wr_data_in;
            occ[i] <= 1'b1;
          end else if (clr_occ[i]) occ[i] <= 1'b0;
        end
      end
    end
  endgenerate

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

`ifndef SYNTHESIS
  function string trace();
    string trace_str;
    trace_str = "";
    for (int i = 0; i < p_depth; i++) begin
      if (i == 0) trace_str = {trace_str, $sformatf("%x", data_out[i])};
      else        trace_str = {trace_str, $sformatf(":%x", data_out[i])};
    end
    trace = trace_str;
  endfunction
`endif

endmodule

`endif
