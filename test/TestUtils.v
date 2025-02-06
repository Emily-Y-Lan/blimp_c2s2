//========================================================================
// TestUtils.v
//========================================================================
// Testing utilities, to be used in testbenches
// Adapted from ECE2300, Cornell University

`ifndef TEST_TEST_UTILS_V
`define TEST_TEST_UTILS_V

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
// TestStatus
//------------------------------------------------------------------------
// A class to statically track the number of failed tests, acting as a
// way to hold a global variable of failed tests

class TestStatus;
  static int num_failed = 0;

  static task test_fail();
    num_failed += 1;
  endtask
endclass

function int num_failed_tests();
  return TestStatus::num_failed;
endfunction

export "DPI-C" function num_failed_tests;

//------------------------------------------------------------------------
// TestEnv
//------------------------------------------------------------------------

package TestEnv;

  //----------------------------------------------------------------------
  // get_test_suite
  //----------------------------------------------------------------------

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
    if ( $value$plusargs( "dump-vcd=%s", filename ) ) begin
      $dumpfile(filename);
      $dumpvars();
    end
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

  // verilator lint_off UNUSEDSIGNAL
  logic failed = 0;
  //verilator lint_on UNUSEDSIGNAL

  // This variable holds the +test-case command line argument indicating
  // which test cases to run.

  int n = 0;
  initial begin

    if ( !$value$plusargs( "test-case=%d", n ) )
      n = 0;

  end

  // Seed random test cases
  int seed = 32'hdeadbeef;
  initial $urandom(seed);

  // Cycle counter with timeout check

  int cycles;

  always @( posedge clk ) begin

    if ( rst )
      cycles <= 0;
    else
      cycles <= cycles + 1;

    if ( cycles > 10000 ) begin
      $display( "\nERROR (cycles=%0d): timeout!", cycles );
      TestStatus::test_fail();
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
    $write("\n    %s%s%s ", `BLUE, taskname, `RESET);
    if ( t.n != 0 )
      $write("\n");

    seed = 32'hdeadbeef;
    failed = 0;

    rst = 1;
    @( posedge clk );
    @( posedge clk );
    @( posedge clk );
    #1;
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
    TestStatus::test_fail();                                            \
  end                                                                   \
  else begin                                                            \
    if ( t.n == 0 )                                                     \
      $write( "%s.%s", `GREEN, `RESET );                                \
  end                                                                   \
  if (1)

`endif // TEST_TEST_UTILS_V
