//========================================================================
// asm32.cpp
//========================================================================
// A function to assemble instructions directly into binary, for use from
// test cases

#ifndef ASM32_CPP
#define ASM32_CPP

#include "arith32.h"
#include <cstdint>
#include <stdexcept>
#include <string>
#include <vector>

//------------------------------------------------------------------------
// asm32
//------------------------------------------------------------------------
// Convert the assembly into tokens, then call the instruction-specific
// assembler

uint32_t asm32( std::string assembly )
{
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Tokenize the string
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  std::vector<std::string> tokens;
  std::string              curr_token = "";

  for ( char c : assembly ) {
    if ( ( c == ' ' ) | ( c == ',' ) ) {
      if ( curr_token.length() > 0 ) {
        tokens.push_back( curr_token );
      }
    }
    else {
      curr_token += c;
    }
  }

  if ( curr_token.length() > 0 )
    tokens.push_back( curr_token );

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Call the appropriate instruction assembler
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  std::string inst;

  try {
    inst = tokens.at( 0 );
  } catch ( const std::out_of_range& e ) {
    throw std::invalid_argument(
        "Error: No instruction found for assembly '" + assembly + "'" );
  }

  std::vector<std::string> args( tokens.begin() + 1, tokens.end() );

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Arithmetic
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if ( inst == "addi" ) {
    return asm32_addi( args );
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // No instruction found
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  throw std::invalid_argument( "Unrecognized instruction: '" + inst +
                               "'" );
}

#endif  // ASM32_CPP
