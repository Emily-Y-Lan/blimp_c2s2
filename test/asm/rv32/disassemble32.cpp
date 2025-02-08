//========================================================================
// disassemble32.cpp
//========================================================================
// A function to disassemble instructions directly from binary, for use
// from test cases

#ifndef DISASSEMBLE32_CPP
#define DISASSEMBLE32_CPP

#include "inst32.h"
#include "inst32_utils.h"
#include <cstdint>
#include <functional>
#include <map>
#include <stdexcept>
#include <string>
#include <vector>

//------------------------------------------------------------------------
// Field Table
//------------------------------------------------------------------------
// Map fields to instructions to call for the corresponding token

std::map<std::string, std::function<std::string( uint32_t )>>
    disasm_field_map = {
        { "rs1", get_rs1 },     { "rs2", get_rs2 },
        { "rd", get_rd },       { "imm_i", get_imm_i },
        { "imm_s", get_imm_s }, { "imm_b", get_imm_b },
        { "imm_u", get_imm_u }, { "imm_j", get_imm_j },
};

//------------------------------------------------------------------------
// disassemble32
//------------------------------------------------------------------------
// Find the matching instruction for the binary, then assemble tokens
// from it

std::string instruction;

extern "C" const char* disassemble32( const uint32_t* vbinary );

const char* disassemble32( const uint32_t* vbinary )
{
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Get the appropriate instruction specification
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  uint32_t  binary = *vbinary;
  inst_spec spec;
  try {
    spec = get_inst_spec( binary );
  } catch ( std::exception& e ) {
    return "????????";
  }
  std::vector<std::string> spec_tokens = tokenize( spec.assembly );

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Use tokens to form instruction
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  instruction = spec.assembly;

  for ( int i = 0; i < spec_tokens.size(); i++ ) {
    // Skip instruction token
    if ( i == 0 ) {
      continue;
    }

    std::string spec_token  = spec_tokens[i];
    std::string replacement = disasm_field_map[spec_token]( binary );

    instruction.replace( instruction.find( spec_token ),
                         spec_token.length(), replacement );
  }

  return instruction.c_str();
}

#endif  // DISASSEMBLE32_CPP
