//========================================================================
// fl_vtrace.cpp
//========================================================================
// A standalone functional-level tracer for SystemVerilog testbenches

#include "fl/FLProc.h"
#include "fl/FLTrace.h"
#include "fl/fl_vtrace.h"

FLProc proc;

//------------------------------------------------------------------------
// Reset State
//------------------------------------------------------------------------

void fl_reset()
{
  proc.reset();
}

//------------------------------------------------------------------------
// Initialize Memory
//------------------------------------------------------------------------

void fl_init( uint32_t* addr, uint32_t* binary )
{
  proc.init( *addr, *binary );
}

//------------------------------------------------------------------------
// Execution Step
//------------------------------------------------------------------------

bool fl_trace( uint32_t* trace )
{
  try {
    FLTrace inst_trace = proc.step();
    inst_trace.vrep( trace );
    return 1;
  } catch ( ... ) {
    return 0;
  }
}