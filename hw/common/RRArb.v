//========================================================================
// RRArb.v
//========================================================================
// A round-robin arbiter implemented with thermo-coded vectors, initially
// preferring the least-significant input
//
// https://www.sciencedirect.com/science/article/pii/S0026269212000948
// (with minor modifications to make functionally correct)

`ifndef HW_COMMON_RRARB_V
`define HW_COMMON_RRARB_V

module RRArb #(
  parameter p_width = 2
)(
  input  logic               clk,
  input  logic               rst,

  input  logic [p_width-1:0] req,
  output logic [p_width-1:0] gnt
);

  //----------------------------------------------------------------------
  // Use the previous grant to store a high-priority filter
  //----------------------------------------------------------------------

  logic [p_width-1:0] thermo_gnt;
  logic [p_width-1:0] req_hph_filter;
  
  always_ff @( posedge clk ) begin
    if( rst ) req_hph_filter <= '0;
    else      req_hph_filter <= thermo_gnt << 1;
  end

  //----------------------------------------------------------------------
  // Thermo-code the high-priority and low-priority portions
  //----------------------------------------------------------------------
  
  logic [p_width-1:0] req_hph;
  logic [p_width-1:0] req_lph;

  assign req_hph = req_hph_filter & req;
  assign req_lph = req;

  logic [p_width-1:0] thermo_req_hph /* verilator split_var */;
  logic [p_width-1:0] thermo_req_lph /* verilator split_var */;

  genvar i;
  generate
    for( i = 0; i < p_width; i = i + 1 ) begin: detector
      if( i == 0 ) begin
        assign thermo_req_hph[i] = req_hph[i];
        assign thermo_req_lph[i] = req_lph[i];
      end else begin
        assign thermo_req_hph[i] = req_hph[i] | (|thermo_req_hph[i-1:0]);
        assign thermo_req_lph[i] = req_lph[i] | (|thermo_req_lph[i-1:0]);
      end
    end
  endgenerate

  //----------------------------------------------------------------------
  // Mux the two to get the thermo-encoded gnt
  //----------------------------------------------------------------------

  always_comb begin
    if( |req_hph )
      thermo_gnt = thermo_req_hph;
    else
      thermo_gnt = thermo_req_lph;
  end

  //----------------------------------------------------------------------
  // Edge-detect to get actual grant
  //----------------------------------------------------------------------

  assign gnt = thermo_gnt & {~thermo_gnt[p_width-2:0], 1'b1};
endmodule

`endif // HW_COMMON_RRARB_V
