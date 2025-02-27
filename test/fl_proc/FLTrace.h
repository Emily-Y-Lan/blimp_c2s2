//========================================================================
// FLTrace.h
//========================================================================
// Declarations for our processor trace

#ifndef FL_TRACE_H
#define FL_TRACE_H

#include <cstdint>

class FLTrace {
  //----------------------------------------------------------------------
  // Public accessor functions
  //----------------------------------------------------------------------
 public:
  // Constructors
  FLTrace( uint32_t pc, uint32_t waddr, uint32_t wdata, bool wen );

  //----------------------------------------------------------------------
  // Protected attrributes
  //----------------------------------------------------------------------
 protected:
  uint32_t pc;
  uint32_t waddr;
  uint32_t wdata;
  bool     wen;
};

#endif  // FL_TRACE_H