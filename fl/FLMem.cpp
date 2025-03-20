//========================================================================
// FLMem.cpp
//========================================================================
// Definitions of our functional-level memory utilities

#include "asm/assemble.h"
#include "fl/FLMem.h"
#include <stdexcept>

//------------------------------------------------------------------------
// FLMem::init
//------------------------------------------------------------------------

void FLMem::init( uint32_t addr, uint32_t data )
{
  mem[addr] = data;
}

void FLMem::init( uint32_t addr, std::string assembly )
{
  mem[addr] = assemble( assembly.c_str(), &addr );
}

//------------------------------------------------------------------------
// FLMem::clear
//------------------------------------------------------------------------

void FLMem::clear()
{
  mem.clear();
}

//------------------------------------------------------------------------
// FLMem::add_peripheral
//------------------------------------------------------------------------

void FLMem::add_peripheral( FLPeripheral* peripheral )
{
  peripherals.push_back( peripheral );
}

//------------------------------------------------------------------------
// FLMem::load
//------------------------------------------------------------------------
// No initialization of empty location currently (use operator[] if
// desired)

uint32_t FLMem::load( uint32_t addr )
{
  uint32_t peripheral_data;
  for ( FLPeripheral* peripheral : peripherals ) {
    if ( peripheral->try_read( addr, &peripheral_data ) ) {
      return peripheral_data;
    }
  }

  // Otherwise, get from memory
  return mem[addr];  // 0 if not already mapped
}

//------------------------------------------------------------------------
// FLMem::store
//------------------------------------------------------------------------

void FLMem::store( uint32_t addr, uint32_t data )
{
  for ( FLPeripheral* peripheral : peripherals ) {
    if ( peripheral->try_write( addr, data ) ) {
      return;
    }
  }

  // Otherwise, store to memory
  mem[addr] = data;
}

//------------------------------------------------------------------------
// FLMem::operator[]
//------------------------------------------------------------------------
// Doesn't check peripherals

// Store - return uint32_t&
uint32_t& FLMem::operator[]( uint32_t addr )
{
  return mem[addr];
}