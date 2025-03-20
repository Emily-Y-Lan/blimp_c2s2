//========================================================================
// FLTerminal.cpp
//========================================================================
// A memory-mapped peripheral for getting user input

#include "fl/peripherals/FLTerminal.h"
#include <iostream>

//------------------------------------------------------------------------
// read
//------------------------------------------------------------------------

void FLTerminal::read( uint32_t, uint32_t* )
{
  // Never called
}

//------------------------------------------------------------------------
// write
//------------------------------------------------------------------------

#define WPRINTF_INT_ADDR 0xF0000000
#define WPRINTF_CHAR_ADDR 0xF0000004

void FLTerminal::write( uint32_t addr, uint32_t data )
{
  if ( addr == WPRINTF_INT_ADDR ) {
    std::cout << (int) data;
  }
  else {
    std::cout << (char) data;
    if ( (char) data == '\n' ) {
      std::cout.flush();
    }
  }
}
