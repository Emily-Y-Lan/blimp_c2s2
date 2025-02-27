//========================================================================
// FLInst.h
//========================================================================
// A wrapper around a binary instruction for functional-level operations

#ifndef FL_INST_H
#define FL_INST_H

#include <cstdint>
#include <string>

class FLInst {
  //----------------------------------------------------------------------
  // Public accessor functions
  //----------------------------------------------------------------------
 public:
  // Constructors
  FLInst( uint32_t inst );
  FLInst( std::string assembly );

  // Metadata
  std::string name() const;

  // Fields
  uint32_t rs1() const;
  uint32_t rs2() const;
  uint32_t rd() const;

  uint32_t imm_i() const;
  uint32_t imm_s() const;
  uint32_t imm_b() const;
  uint32_t imm_u() const;
  uint32_t imm_j() const;

  //----------------------------------------------------------------------
  // Protected attrributes
  //----------------------------------------------------------------------
 protected:
  uint32_t binary;
};

#endif  // FL_INST_H