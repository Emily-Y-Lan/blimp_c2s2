// =======================================================================
// sim.cpp
// =======================================================================
// A basic simulator for running testbenches

// Include common routines
#include <verilated.h>

// Include model header, generated from Verilating "top.v"
#include VERILATOR_INCL_HEADER

int main( int argc, char** argv )
{
  // Construct a VerilatedContext to hold simulation time, etc.
  VerilatedContext* const contextp = new VerilatedContext;

  // Verilator must compute traced signals
  contextp->traceEverOn( true );

  // Pass arguments so Verilated code can see them, e.g. $value$plusargs
  // This needs to be called before you create any model
  contextp->commandArgs( argc, argv );

  // Construct the Verilated model, from Vtop.h generated from Verilating
  // "top.v"
  VERILATOR_TOP_MODULE* top = new VERILATOR_TOP_MODULE{ contextp };

  // Simulate until $finish
  while ( !contextp->gotFinish() ) {
    // Increment time
    contextp->timeInc( 1 );
    // Evaluate model
    top->eval();
  }

  // Final model cleanup
  top->final();

  // Destroy model
  delete top;

  // Return good completion status
  return 0;
}