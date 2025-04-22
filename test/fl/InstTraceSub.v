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

module InstTraceSub (
  input logic        clk,
  
  input logic [31:0] pc,
  input logic  [4:0] waddr,
  input logic [31:0] wdata,
  input logic        wen,
  input logic        val
);
  
  FLTestUtils t( .rst( 1'b0), .* );

  //----------------------------------------------------------------------
  // check_trace
  //----------------------------------------------------------------------
  // A function to check an instruction trace

  logic [31:0] dut_pc;
  logic  [4:0] dut_waddr;
  logic [31:0] dut_wdata;
  logic        dut_wen;
  logic        dut_val;
  logic        waiting;

  initial waiting = 1'b0;

  task check_trace (
    input logic [31:0] exp_pc,
    input logic  [4:0] exp_waddr,
    input logic [31:0] exp_wdata,
    input logic        exp_wen
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

  function int ceil_div_4( int val );
    return (val / 4) + ((val % 4) > 0 ? 1 : 0);
  endfunction

  function string trace(
    // verilator lint_off UNUSEDSIGNAL
    int trace_level
    // verilator lint_on UNUSEDSIGNAL
  );
    int str_len;
    str_len = 8 + 1 + // pc
              1 + 1 + // wen
              2 + 1 + // waddr
              8;      // wdata

    if( val & waiting ) begin
      if( wen )
        trace = $sformatf("%h:%b:%h:%h", pc, wen, waddr, wdata);
      else
        trace = $sformatf("%h:%b:%s:%s", pc, wen, 
                          {2{"x"}},
                          {8{"x"}});
    end
    else if( val )
      trace = {{(str_len-1){" "}}, "X"};
    else if( waiting )
      trace = {(str_len){" "}};
    else
      trace = {{(str_len-1){" "}}, "."};
  endfunction

endmodule

`endif // TEST_FL_INSTTRACESUB_V
