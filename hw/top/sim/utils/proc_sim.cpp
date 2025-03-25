// =======================================================================
// proc_sim.cpp
// =======================================================================
// A basic simulator for running processor simulations

// Include common routines
#include <format>
#include <iostream>
#include <string>
#include <verilated.h>

// Include DPI functions
#include "svdpi.h"

// Include model header (ex. Vtop.h)
#include VERILATOR_INCL_HEADER

// Include model's DPI header (ex. Vtop__Dpi.h)
#include VERILATOR_DPI_HEADER

// FL Utilities
#include "fl/parse_elf.h"

#define STRINGIFY( x ) #x
#define STRINGIFY_MACRO( x ) STRINGIFY( x )

// -----------------------------------------------------------------------
// init_proc_mem
// -----------------------------------------------------------------------
// Used to initialize memory

VERILATOR_TOP_MODULE* curr_top;

void init_proc_mem( uint32_t addr, uint32_t data )
{
  if ( curr_top ) {
    curr_top->init_mem( &addr, &data );
  }
}

// -----------------------------------------------------------------------
// main
// -----------------------------------------------------------------------

int main( int argc, char** argv )
{
  if ( argc < 2 ) {
    std::cout << "Usage: " << argv[0] << " elf_file" << std::endl;
    exit( 1 );
  }

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
  curr_top                  = top;

  // Set the scope, for access to DPI functions
  std::string scope_name =
      std::format( "TOP.{}", STRINGIFY_MACRO( VERILATOR_MODULE_NAME ) );
  const svScope scope = svGetScopeFromName( scope_name.c_str() );
  assert( scope );  // Check for nullptr if scope not found
  svSetScope( scope );

  // Reset the design
  top->rst = 1;
  for ( int i = 0; i < 3; i++ ) {
    while ( !top->clk ) {
      contextp->timeInc( 1 );
      top->eval();
    }
    while ( top->clk ) {
      contextp->timeInc( 1 );
      top->eval();
    }
  }

  top->rst = 0;

  // Load the ELF file
  parse_elf( argv[1], init_proc_mem );

  // Simulate until $finish
  while ( !contextp->gotFinish() ) {
    // Increment time
    contextp->timeInc( 1 );
    // Evaluate model
    top->eval();
  }

  // Final model cleanup
  top->final();

#if VM_COVERAGE
  Verilated::mkdir( "logs" );
  contextp->coveragep()->write( "logs/coverage.dat" );
#endif

  // Destroy model
  delete top;

  // Return good completion status
  return 0;
}