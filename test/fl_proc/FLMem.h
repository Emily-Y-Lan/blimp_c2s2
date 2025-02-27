//========================================================================
// FLMem.h
//========================================================================
// Declarations of our functional-level memory utilities

#ifndef FL_MEM_H
#define FL_MEM_H

#include <cstdint>
#include <map>
#include <string>

class FLMem {
  //----------------------------------------------------------------------
  // Public accessor functions
  //----------------------------------------------------------------------
 public:
  // Initialize memory
  void init( uint32_t addr, uint32_t inst );
  void init( uint32_t addr, std::string assembly );

  // Access memory
  uint32_t load( uint32_t addr ) const;
  void     store( uint32_t addr, uint32_t data );

  // Overload with bracket for easier syntax
  uint32_t& operator[]( uint32_t addr );        // store
  uint32_t  operator[]( uint32_t addr ) const;  // load

  //----------------------------------------------------------------------
  // Protected attrributes
  //----------------------------------------------------------------------
 protected:
  std::map<uint32_t, uint32_t> mem;
};

#endif  // FL_MEM_H