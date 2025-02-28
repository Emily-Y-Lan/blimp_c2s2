//========================================================================
// FLTrace.h
//========================================================================
// Declarations for our processor trace

#ifndef FL_TRACE_H
#define FL_TRACE_H

#include <cstdint>
#include <iostream>

class FLTrace {
  //----------------------------------------------------------------------
  // Public accessor functions
  //----------------------------------------------------------------------
 public:
  // Constructors
  FLTrace( uint32_t pc, uint32_t waddr, uint32_t wdata, bool wen );

  // String representation for stream output
  friend std::ostream &operator<<( std::ostream  &out,
                                   const FLTrace &trace );

  // Verilog Representation
  void vrep( uint32_t *vstruct );

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