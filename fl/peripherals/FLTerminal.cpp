//========================================================================
// FLTerminal.cpp
//========================================================================
// A memory-mapped peripheral for getting user input

#include "fl/peripherals/FLTerminal.h"
#include <iostream>

//------------------------------------------------------------------------
// read
//------------------------------------------------------------------------

void FLTerminal::read( uint32_t, uint32_t* data )
{
  // Address is always 0xF0000000 for reading
  *data = std::cin.get();
}

//------------------------------------------------------------------------
// write
//------------------------------------------------------------------------

void FLTerminal::write( uint32_t, uint32_t data )
{
  // Address is always 0xF0000004 for writing
  char output = (char) data;
  std::cout << output;
  if ( data == '\n' ) {
    std::cout.flush();
  }
}
