//========================================================================
// FLExit.cpp
//========================================================================
// A memory-mapped peripheral for terminating the simulation

#include "fl/peripherals/FLExit.h"
#include <cstdlib>
#include <iostream>

//------------------------------------------------------------------------
// read
//------------------------------------------------------------------------

void FLExit::read( uint32_t, uint32_t* )
{
  // Never called
}

//------------------------------------------------------------------------
// write
//------------------------------------------------------------------------

void FLExit::write( uint32_t, uint32_t data )
{
  // Address is always 0xFFFFFFFC for writing
  std::cout << "Simulation finished with exit code " << (int) data
            << std::endl;
  exit( data );
}
