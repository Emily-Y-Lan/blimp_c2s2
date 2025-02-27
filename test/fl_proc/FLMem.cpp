//========================================================================
// FLMem.cpp
//========================================================================
// Definitions of our functional-level memory utilities

#include "test/asm/assemble.h"
#include "test/fl_proc/FLMem.h"
#include <format>
#include <stdexcept>
#include <type_traits>

//------------------------------------------------------------------------
// FLMem::init
//------------------------------------------------------------------------

void FLMem::init( uint32_t addr, uint32_t data )
{
  mem[addr] = data;
}

void FLMem::init( uint32_t addr, std::string assembly )
{
  mem[addr] = assemble( assembly.c_str(), addr );
}

//------------------------------------------------------------------------
// FLMem::load
//------------------------------------------------------------------------

uint32_t FLMem::load( uint32_t addr ) const
{
  if ( !mem.contains( addr ) ) {
    std::string excp =
        std::format( "Memory address 0x{:X} never initialized", addr );
    throw std::invalid_argument( excp );
  }
  return mem.at( addr );
}

//------------------------------------------------------------------------
// FLMem::store
//------------------------------------------------------------------------

void FLMem::store( uint32_t addr, uint32_t data )
{
  mem[addr] = data;
}

//------------------------------------------------------------------------
// FLMem::operator[]
//------------------------------------------------------------------------

// Store - return uint32_t&
uint32_t& FLMem::operator[]( uint32_t addr )
{
  return mem[addr];
}

// Load - return uint32_t
uint32_t FLMem::operator[]( uint32_t addr ) const
{
  return load( addr );
}
