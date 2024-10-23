//========================================================================
// TestUtils.v
//========================================================================
// Testing utilities, to be used in testbenches
// Adapted from ECE2300, Cornell University

`ifndef TEST_TEST_UTILS_V
`define TEST_TEST_UTILS_V

//------------------------------------------------------------------------
// Colors
//-----------------------------------------------------------------------

`define RED    "\033[31m"
`define GREEN  "\033[32m"
`define YELLOW "\033[33m"
`define PURPLE "\033[35m"
`define RESET  "\033[0m"

package TestEnv;

  //------------------------------------------------------------------------
  // get_test_suite
  //------------------------------------------------------------------------

  function int get_test_suite();
    if ( !$value$plusargs( "test-suite=%d", get_test_suite ) )
      get_test_suite = 0;
  endfunction

  //----------------------------------------------------------------------
  // test_bench_begin
  //----------------------------------------------------------------------
  // We start with a #1 delay so that all tasks will essentially start at
  // #1 after the rising edge of the clock.
  // test_bench_begin

  task test_bench_begin( string filename );
    $write("\nRunning %s", filename);
    #1;
  endtask

  //----------------------------------------------------------------------
  // test_bench_end
  //----------------------------------------------------------------------

  task test_bench_end();
    $write("\n\n");
    $finish;
  endtask
endpackage


//========================================================================
// TestUtils
//========================================================================

module TestUtils
(
  output logic clk,
  output logic rst
);

  // verilator lint_off BLKSEQ
  initial clk = 1'b1;
  always #5 clk = ~clk;
  // verilator lint_on BLKSEQ

  // Error count

  logic failed = 0;

  // This variable holds the +test-case command line argument indicating
  // which test cases to run.

  string vcd_filename;
  int n = 0;
  initial begin

    if ( !$value$plusargs( "test-case=%d", n ) )
      n = 0;

    if ( $value$plusargs( "dump-vcd=%s", vcd_filename ) ) begin
      $dumpfile(vcd_filename);
      $dumpvars();
    end

  end

  // Always call $urandom with this seed variable to ensure that random
  // test cases are both isolated and reproducible.

  // verilator lint_off UNUSEDSIGNAL
  int seed = 32'hdeadbeef;
  // verilator lint_on UNUSEDSIGNAL

  // Cycle counter with timeout check

  int cycles;

  always @( posedge clk ) begin

    if ( rst )
      cycles <= 0;
    else
      cycles <= cycles + 1;

    if ( cycles > 10000 ) begin
      $display( "\nERROR (cycles=%0d): timeout!", cycles );
      $finish;
    end

  end

  //----------------------------------------------------------------------
  // test_suite_begin
  //----------------------------------------------------------------------

  task test_suite_begin( string suitename );
    $write("\n  %s%s%s", `PURPLE, suitename, `RESET);
  endtask

  //----------------------------------------------------------------------
  // test_case_begin
  //----------------------------------------------------------------------

  task test_case_begin( string taskname );
    $write("\n    %s ", taskname);
    if ( t.n != 0 )
      $write("\n");

    seed = 32'hdeadbeef;
    failed = 0;

    rst = 1;
    #30;
    rst = 0;
  endtask

endmodule

//------------------------------------------------------------------------
// CHECK_EQ
//------------------------------------------------------------------------
// Compare two expressions which can be signals or constants. We use the
// XOR operator so that an X in __ref will match 0, 1, or X in __dut, but
// an X in __dut will only match an X in __ref.

`define CHECK_EQ( __dut, __ref )                                        \
  if ( __ref !== ( __ref ^ __dut ^ __ref ) ) begin                      \
    if ( t.n != 0 )                                                     \
      $display( "\n%sERROR%s (cycle=%0d): %s != %s (%b != %b)",         \
                `RED, `RESET, t.cycles, "__dut", "__ref",               \
                __dut, __ref );                                         \
    else                                                                \
      $write( "%sF%s", `RED, `RESET );                                  \
    t.failed = 1;                                                       \
  end                                                                   \
  else begin                                                            \
    if ( t.n == 0 )                                                     \
      $write( "%s.%s", `GREEN, `RESET );                                \
  end                                                                   \
  if (1)

`endif // TEST_TEST_UTILS_V
