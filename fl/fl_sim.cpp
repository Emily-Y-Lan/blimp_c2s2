//========================================================================
// fl_sim.cpp
//========================================================================
// A top-level program for simulating a RISCV binary with the FLProc

#include "fl/FLProc.h"
#include "fl/parse_elf.h"
#include <iomanip>
#include <iostream>

// -----------------------------------------------------------------------
// Instantiate processor
// -----------------------------------------------------------------------

FLProc proc;

void init_mem( uint32_t addr, uint32_t data )
{
  proc.init( addr, data );
}

// -----------------------------------------------------------------------
// main
// -----------------------------------------------------------------------

int main( int argc, char* argv[] )
{
  if ( argc != 2 ) {
    std::cout << "Usage: " << argv[0] << " elf_file" << std::endl;
    exit( 1 );
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Add the data from the ELF file
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  parse_elf( argv[1], init_mem );

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Simulate the design
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  while ( 1 ) {
    proc.step();
  }
}