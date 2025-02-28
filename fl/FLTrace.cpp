//========================================================================
// FLTrace.cpp
//========================================================================
// Definitions for our processor trace

#include "fl/FLTrace.h"
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

//------------------------------------------------------------------------
// Verilog Representation
//------------------------------------------------------------------------
// Assume a struct of the following format:
//
// typedef struct packed {
//   bit        wen;
//   bit  [4:0] waddr;
//   bit [31:0] wdata;
//   bit [31:0] pc;
// } inst_trace;
//
// Pack the bits accordingly (pc is least-significant word)

void FLTrace::vrep( uint32_t *vstruct )
{
  vstruct[0] = pc;
  vstruct[1] = wdata;
  vstruct[2] = waddr | ( (uint32_t) ( wen ) << 5 );
}
