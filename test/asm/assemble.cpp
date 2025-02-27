//========================================================================
// assemble.cpp
//========================================================================
// A function to assemble instructions directly into binary, for use from
// test cases

#include "fields.h"
#include "inst.h"
#include "test/asm/assemble.h"
#include <format>
#include <functional>
#include <iostream>
#include <map>
#include <stdexcept>
#include <string>
#include <vector>

//------------------------------------------------------------------------
// Field Table
//------------------------------------------------------------------------
// Map fields to instructions to call for the corresponding token

std::map<std::string, std::function<uint32_t( std::string )>>
    asm_field_map = { { "rs1", rs1_mask },     { "rs2", rs2_mask },
                      { "rd", rd_mask },       { "imm_i", imm_i_mask },
                      { "imm_s", imm_s_mask }, { "imm_b", imm_b_mask },
                      { "imm_u", imm_u_mask }, { "imm_j", imm_j_mask } };

//------------------------------------------------------------------------
// assemble
//------------------------------------------------------------------------
// Convert the assembly into tokens, then call the instruction-specific
// assembler

uint32_t assemble( const char* vassembly, uint32_t pc )
{
  std::string              assembly = vassembly;
  std::vector<std::string> tokens   = tokenize( assembly );

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Get the appropriate instruction specification
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  std::string inst;
  std::string excp;

  try {
    inst = tokens.at( 0 );
  } catch ( const std::out_of_range& e ) {
    excp = std::format( "Error: Empty assembly '{}'", assembly );
    throw std::invalid_argument( excp );
  }

  inst_spec                spec        = get_inst_spec( inst );
  std::vector<std::string> spec_tokens = tokenize( spec.assembly );

  if ( spec_tokens.size() != tokens.size() ) {
    excp = std::format( "Error: '{}' expects {} fields, but found {}",
                        assembly, spec_tokens.size(), tokens.size() );
    throw std::invalid_argument( excp );
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Use tokens to form instruction
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  uint32_t encoding = spec.match;

  for ( int i = 0; i < spec_tokens.size(); i++ ) {
    // Skip instruction token
    if ( i == 0 ) {
      continue;
    }

    std::string inst_token = tokens[i];
    std::string spec_token = spec_tokens[i];

    try {
      encoding |= asm_field_map[spec_token]( inst_token );
    } catch ( std::exception& e ) {
      std::cout << "Unrecognized spec token: " << spec_token << std::endl;
    }
  }

  return encoding;
}
