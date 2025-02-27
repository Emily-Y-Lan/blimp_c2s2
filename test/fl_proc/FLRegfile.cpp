//========================================================================
// FLRegfile.cpp
//========================================================================
// Definitions for our functional-level register file

#include "test/fl_proc/FLRegfile.h"

//------------------------------------------------------------------------
// Accessors
//------------------------------------------------------------------------

// Write
uint32_t& FLRegfile::operator[]( uint32_t idx )
{
  return regs[idx];
}

// Read
uint32_t FLRegfile::operator[]( uint32_t idx ) const
{
  if ( idx == 0 ) {
    return 0;
  }
  return regs[idx];
}