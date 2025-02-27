//========================================================================
// FLTrace.cpp
//========================================================================
// Definitions for our processor trace

#include "test/fl_proc/FLTrace.h"
#include <format>
#include <string>

//------------------------------------------------------------------------
// Constructor
//------------------------------------------------------------------------

FLTrace::FLTrace( uint32_t pc, uint32_t waddr, uint32_t wdata, bool wen )
    : pc( pc ), waddr( waddr ), wdata( wdata ), wen( wen ) {};

//------------------------------------------------------------------------
// Stream representation
//------------------------------------------------------------------------

std::ostream &operator<<( std::ostream &out, const FLTrace &trace )
{
  std::string str_rep = std::format( "0x{:X}: ", trace.pc );
  if ( trace.wen ) {
    str_rep += std::format( "0x{:X} -> R[{}]", trace.wdata, trace.waddr );
  }
  out << str_rep;
  return out;
}
