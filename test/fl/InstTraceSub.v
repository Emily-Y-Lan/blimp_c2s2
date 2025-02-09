//========================================================================
// InstTraceSub.v
//========================================================================
// A FL module for checking instruction traces
//
// A new module is used instead of TestSub to conditionally check waddr
// and wdata, based on wen

`ifndef TEST_FL_INSTTRACESUB_V
`define TEST_FL_INSTTRACESUB_V

`include "test/FLTestUtils.v"

module InstTraceSub #(
  parameter p_addr_bits = 32,
  parameter p_data_bits = 32
)(
  input logic                   clk,
  
  input logic [p_addr_bits-1:0] pc,
  input logic             [4:0] waddr,
  input logic [p_data_bits-1:0] wdata,
  input logic                   wen,
  input logic                   val
);
  
  FLTestUtils t( .rst( 1'b0), .* );

  //----------------------------------------------------------------------
  // check_trace
  //----------------------------------------------------------------------
  // A function to check an instruction trace

  logic [p_addr_bits-1:0] dut_pc;
  logic             [4:0] dut_waddr;
  logic [p_data_bits-1:0] dut_wdata;
  logic                   dut_wen;
  logic                   dut_val;
  logic                   waiting;

  initial waiting = 1'b0;

  task check_trace (
    input logic [p_addr_bits-1:0] exp_pc,
    input logic             [4:0] exp_waddr,
    input logic [p_data_bits-1:0] exp_wdata,
    input logic                   exp_wen
  );

    waiting = 1'b1;

    do begin
      #2
      dut_pc    = pc;
      dut_waddr = waddr;
      dut_wdata = wdata;
      dut_wen   = wen;
      dut_val   = val;
      @( posedge clk );
      #1;
    end while( !dut_val );
    
    `CHECK_EQ( dut_pc,  exp_pc );
    `CHECK_EQ( dut_wen, exp_wen );

    if( exp_wen ) begin
      `CHECK_EQ( dut_waddr, exp_waddr );
      `CHECK_EQ( dut_wdata, exp_wdata );
    end

    waiting = 1'b0;

  endtask

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

  // verilator lint_off UNUSEDSIGNAL
  string trace;
  // verilator lint_on UNUSEDSIGNAL

  function int ceil_div_4( int val );
    return (val / 4) + (val % 4);
  endfunction

  // verilator lint_off BLKSEQ
  always_comb begin
    int str_len;
    str_len = ceil_div_4(p_addr_bits) + 1 + // pc
              1                       + 1 + // wen
              ceil_div_4(5)           + 1 + // waddr
              ceil_div_4(p_data_bits);      // wdata

    if( val & waiting ) begin
      if( wen )
        trace = $sformatf("%h:%b:%h:%h", pc, wen, waddr, wdata);
      else
        trace = $sformatf("%h:%b:%s:%s", pc, wen, 
                          {ceil_div_4(5){"x"}},
                          {ceil_div_4(p_data_bits){"x"}});
    end
    else if( val )
      trace = {{(str_len-1){" "}}, "X"};
    else if( waiting )
      trace = {(str_len){" "}};
    else
      trace = {{(str_len-1){" "}}, "."};
  end
  // verilator lint_on BLKSEQ

endmodule

`endif // TEST_FL_INSTTRACESUB_V
