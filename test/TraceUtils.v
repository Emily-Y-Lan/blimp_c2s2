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

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Keep track of whether we're enabled
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  logic enabled;
  initial enabled = 0;

  task enable_trace;
    enabled = 1;
  endtask

  task disable_trace;
    enabled = 0;
  endtask

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Keep track of the number of cycles in
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  int num_cycles;

  initial num_cycles = 0;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Output the trace
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  always_ff @( posedge clk ) begin
    #2;
    if( enabled ) begin
      $write("      %3d: ", num_cycles );
      foreach( trace_strs[i] )
        $write(trace_strs[i]);
      $display("");
      num_cycles <= num_cycles + 1;
    end else begin
      num_cycles <= 0;
    end
  end
endmodule

`endif // TEST_TRACE_UTILS_V
