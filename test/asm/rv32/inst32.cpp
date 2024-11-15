//========================================================================
// inst32.cpp
//========================================================================
// Functions that operate on instruction specifications

#ifndef INST32_CPP
#define INST32_CPP

#include "inst32.h"
#include <algorithm>
#include <cstdio>
#include <inttypes.h>
#include <iostream>
#include <stdexcept>
#include <vector>

//------------------------------------------------------------------------
// Parse a given assembly into tokens
//------------------------------------------------------------------------

const std::vector<char> delimeters = { ' ', ',', '(', ')' };

std::vector<std::string> tokenize( std::string assembly )
{
  std::vector<std::string> tokens;
  std::string              curr_token = "";

  for ( char c : assembly ) {
    if ( std::find( delimeters.begin(), delimeters.end(), c ) !=
         delimeters.end() ) {
      if ( curr_token.length() > 0 ) {
        tokens.push_back( curr_token );
      }
      curr_token = "";
    }
    else {
      curr_token += c;
    }
  }

  if ( curr_token.length() > 0 )
    tokens.push_back( curr_token );
  return tokens;
}

//------------------------------------------------------------------------
// Find the appropriate specification
//------------------------------------------------------------------------

std::string get_inst_name( std::string inst_asm )
{
  return inst_asm.substr( 0, inst_asm.find( " " ) );
}

inst_spec get_inst_spec( std::string inst_name )
{
  for ( const inst_spec spec : inst_specs ) {
    if ( get_inst_name( spec.assembly ) == inst_name ) {
      return spec;
    }
  }

  // Didn't find instruction spec
  std::cout << "Couldn't find specification for instruction '"
            << inst_name << "'" << std::endl;
  throw std::invalid_argument(
      "Couldn't find specification for instruction '" + inst_name + "'" );
}

inst_spec get_inst_spec( uint32_t inst_bin )
{
  for ( const inst_spec spec : inst_specs ) {
    if ( ( inst_bin & spec.mask ) == spec.match ) {
      return spec;
    }
  }

  // Didn't find instruction spec (don't print, in case running test in
  // background)
  char excp[100];
  sprintf( excp,
           "Couldn't find specification for instruction '0x%08" PRIx32
           "'",
           inst_bin );
  throw std::invalid_argument( excp );
}

#endif  // INST32_CPP