//========================================================================
// SimUtils.v
//========================================================================
// Simulation utilities, to be used in processor simulations

`ifndef HW_TOP_SIM_SIM_UTILS_V
`define HW_TOP_SIM_SIM_UTILS_V

module SimUtils
(
  output logic clk
);

  // ---------------------------------------------------------------------
  // Clocking
  // ---------------------------------------------------------------------
  
  // verilator lint_off BLKSEQ
  initial clk = 1'b1;
  always #5 clk = ~clk;
  // verilator lint_on BLKSEQ

  // ---------------------------------------------------------------------
  // Filtering Utilities
  // ---------------------------------------------------------------------

  // verilator lint_off UNUSEDSIGNAL
  logic verbose;
  // verilator lint_on UNUSEDSIGNAL

  initial begin
    if ( $test$plusargs ("verbose") )
      verbose = 1'b1;
    else if ( $test$plusargs ("v") )
      verbose = 1'b1;
    else
      verbose = 1'b0;
  end

  // ---------------------------------------------------------------------
  // Waveform Dumping
  // ---------------------------------------------------------------------

  string filename;
  initial begin
    if ( $value$plusargs( "dump-vcd=%s", filename ) ) begin
      $dumpfile(filename);
      $dumpvars();
    end
  end

  // ---------------------------------------------------------------------
  // Random Seeding
  // ---------------------------------------------------------------------

  // Seed random test cases
  int seed = 32'hdeadbeef;
  initial $urandom(seed);

  //----------------------------------------------------------------------
  // trace
  //----------------------------------------------------------------------

  task trace( string msg_to_trace );
    if( verbose )
      $display( msg_to_trace );
  endtask

endmodule

`endif // HW_TOP_SIM_SIM_UTILS_V
