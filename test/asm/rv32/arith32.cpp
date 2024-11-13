//========================================================================
// arith32.h
//========================================================================
// Definitions of our arithmetic-instruction assemblers

#ifndef ARITH32_CPP
#define ARITH32_CPP

#include "arith32.h"
#include "utils32.h"
#include <stdexcept>

//------------------------------------------------------------------------
// addi
//------------------------------------------------------------------------

uint32_t asm32_addi( std::vector<std::string> tokens )
{
  if ( tokens.size() != 3 ) {
    throw std::invalid_argument( "'addi' expects 3 arguments" );
  }

  std::string rd  = tokens[0];
  std::string rs1 = tokens[1];
  int         imm = std::stoi( tokens[2] );

  uint32_t encoding = 0b0010011;
  encoding |= rs1_mask( rs1 );
  encoding |= rd_mask( rd );
  encoding |= imm_i_mask( imm );
  return encoding;
}

#endif  // ARITH32_CPP