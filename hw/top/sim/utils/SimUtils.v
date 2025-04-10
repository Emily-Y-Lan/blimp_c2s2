//========================================================================
// SimUtils.v
//========================================================================
// Simulation utilities, to be used in processor simulations

`ifndef HW_TOP_SIM_SIM_UTILS_V
`define HW_TOP_SIM_SIM_UTILS_V

//------------------------------------------------------------------------
// Colors
//------------------------------------------------------------------------

`define RED    "\033[31m"
`define YELLOW "\033[33m"
`define GREEN  "\033[32m"
`define BLUE   "\033[34m"
`define PURPLE "\033[35m"
`define RESET  "\033[0m"

//------------------------------------------------------------------------
// SimUtils
//------------------------------------------------------------------------

module SimUtils
(
  output logic clk,
  output logic rst
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

  string elf_file;
  initial begin
    if( !$value$plusargs( "elf=%s", elf_file ) )
      $fatal(0, "No ELF file specified with +elf=/path/to/elf" );
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

  task sim_begin( string taskname );
    $write("\n  %s%s%s", `PURPLE, taskname, `RESET);
    rst = 1'b1;
    for( int i = 0; i < 3; i = i + 1 ) begin
      @(posedge clk);
    end
    rst = 1'b0;
  endtask

  //----------------------------------------------------------------------
  // trace
  //----------------------------------------------------------------------

  task trace( string msg_to_trace );
    if( verbose )
      $display( msg_to_trace );
  endtask

endmodule

`endif // HW_TOP_SIM_SIM_UTILS_V
