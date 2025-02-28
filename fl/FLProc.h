//========================================================================
// FLProc.h
//========================================================================
// Declarations for our functional-level processor

#ifndef FL_PROC_H
#define FL_PROC_H

#include "fl/FLInst.h"
#include "fl/FLRegfile.h"
#include "fl/FLTrace.h"
#include <cstdint>
#include <map>

class FLProc {
  //----------------------------------------------------------------------
  // Public accessor functions
  //----------------------------------------------------------------------
 public:
  FLProc();

  // Reset state
  void reset();

  // Initialize memory
  void init( uint32_t addr, uint32_t inst );
  void init( uint32_t addr, std::string assembly );

  // Step one instruction in execution
  FLTrace step();

  //----------------------------------------------------------------------
  // Protected attrributes
  //----------------------------------------------------------------------
 protected:
  uint32_t                     pc;
  FLRegfile                    regs;
  std::map<uint32_t, uint32_t> mem;
};

#endif  // FL_PROC_H