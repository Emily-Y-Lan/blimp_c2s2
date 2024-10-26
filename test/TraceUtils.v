//========================================================================
// TraceUtils.v
//========================================================================
// Tracing utilities, to be used to trace signals in testbenches

`ifndef TEST_TRACE_UTILS_V
`define TEST_TRACE_UTILS_V

//------------------------------------------------------------------------
// Tracer
//------------------------------------------------------------------------
// A testbench-level tracer, meant to trace many Trace instances. This
// should be overriden to define the `trace` function

module Tracer (
  input logic clk,
  input string trace_strs []
);

  logic enabled;
  initial enabled = 0;

  task enable_trace;
    enabled = 1;
  endtask

  task disable_trace;
    enabled = 0;
  endtask

  always_ff @( posedge clk ) begin
    #2;
    if( enabled ) begin
      $write("      ");
      foreach( trace_strs[i] )
        $write(trace_strs[i]);
      $display("");
    end
  end
endmodule

`endif // TEST_TRACE_UTILS_V
