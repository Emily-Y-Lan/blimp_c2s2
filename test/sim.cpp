// =======================================================================
// sim.cpp
// =======================================================================
// A basic simulator for running testbenches

// Include common routines
#include <stdio.h>
#include <verilated.h>

// Include DPI functions
#include "svdpi.h"

// Include model header (ex. Vtop.h)
#include VERILATOR_INCL_HEADER

// Include model's DPI header (ex. Vtop__Dpi.h)
#include VERILATOR_DPI_HEADER

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

  // Set the scope, for access to DPI functions
  const svScope scope = svGetScopeFromName( "TOP.$unit" );
  assert( scope );  // Check for nullptr if scope not found
  svSetScope( scope );

  // Simulate until $finish
  while ( !contextp->gotFinish() ) {
    // Increment time
    contextp->timeInc( 1 );
    // Evaluate model
    top->eval();
  }

  // Get the number of failed tests from the simulator over DPI
  int exit_code = top->num_failed_tests();

  // Final model cleanup
  top->final();

  // Destroy model
  delete top;

  // Return good completion status
  return exit_code;
}