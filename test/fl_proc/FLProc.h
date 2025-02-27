//========================================================================
// FLProc.h
//========================================================================
// Declarations for our functional-level processor

#ifndef FL_PROC_H
#define FL_PROC_H

#include "test/fl_proc/FLInst.h"
#include "test/fl_proc/FLMem.h"
#include "test/fl_proc/FLRegfile.h"
#include "test/fl_proc/FLTrace.h"
#include <cstdint>

class FLProc {
  //----------------------------------------------------------------------
  // Public accessor functions
  //----------------------------------------------------------------------
 public:
  FLProc();

  // Initialize memory
  void init( uint32_t addr, uint32_t inst );
  void init( uint32_t addr, std::string assembly );

  // Step one instruction in execution
  FLTrace step();

  //----------------------------------------------------------------------
  // Protected attrributes
  //----------------------------------------------------------------------
 protected:
  uint32_t  pc;
  FLRegfile regs;
  FLMem     mem;
};

#endif  // FL_PROC_H