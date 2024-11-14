//========================================================================
// inst32_utils.cpp
//========================================================================
// Utility function definitions for our assembler

#ifndef INST32_UTILS_CPP
#define INST32_UTILS_CPP

#include "inst32_utils.h"
#include <map>
#include <stdexcept>

//------------------------------------------------------------------------
// Register Specifiers
//------------------------------------------------------------------------

const std::map<std::string, uint32_t> reg_masks = {
    { "x0", 0 },   { "x1", 1 },   { "x2", 2 },   { "x3", 3 },
    { "x4", 4 },   { "x5", 5 },   { "x6", 6 },   { "x7", 7 },
    { "x8", 8 },   { "x9", 9 },   { "x10", 10 }, { "x11", 11 },
    { "x12", 12 }, { "x13", 13 }, { "x14", 14 }, { "x15", 15 },
    { "x16", 16 }, { "x17", 17 }, { "x18", 18 }, { "x19", 19 },
    { "x20", 20 }, { "x21", 21 }, { "x22", 22 }, { "x23", 23 },
    { "x24", 24 }, { "x25", 25 }, { "x26", 26 }, { "x27", 27 },
    { "x28", 28 }, { "x29", 29 }, { "x30", 30 }, { "x31", 31 } };

uint32_t rs1_mask( std::string reg_name )
{
  return reg_masks.at( reg_name ) << 15;
}

uint32_t rs2_mask( std::string reg_name )
{
  return reg_masks.at( reg_name ) << 20;
}

uint32_t rd_mask( std::string reg_name )
{
  return reg_masks.at( reg_name ) << 7;
}

//------------------------------------------------------------------------
// Immediate Specifiers
//------------------------------------------------------------------------

uint32_t bitslice( int imm, int end, int start )
{
  int      len  = end - start + 1;
  uint32_t mask = ( 1 << len ) - 1;

  return (uint32_t) ( imm >> start ) & mask;
}

uint32_t repl_upper( uint32_t bit, int start_idx )
{
  bit = bit & 0x1;

  uint32_t mask = 0;
  for ( int i = start_idx; i < 32; i++ ) {
    mask |= ( 1 << i );
  }
  return mask;
}

uint32_t imm_i_mask( std::string imm )
{
  int imm_val = std::stoi( imm );

  if ( ( imm_val > 2047 ) || ( imm_val < -2048 ) ) {
    throw std::invalid_argument( "Invalid I-immediate: " +
                                 std::to_string( imm_val ) );
  }

  uint32_t imm_encoding = 0;
  imm_encoding |= ( bitslice( imm_val, 11, 0 ) << 20 );

  return imm_encoding;
}

uint32_t imm_s_mask( std::string imm )
{
  int imm_val = std::stoi( imm );

  if ( ( imm_val > 2047 ) || ( imm_val < -2048 ) ) {
    throw std::invalid_argument( "Invalid S-immediate: " +
                                 std::to_string( imm_val ) );
  }

  uint32_t imm_encoding = 0;
  imm_encoding |= ( bitslice( imm_val, 4, 0 ) << 7 );
  imm_encoding |= ( bitslice( imm_val, 11, 5 ) << 25 );

  return imm_encoding;
}

uint32_t imm_b_mask( std::string imm )
{
  int imm_val = std::stoi( imm );

  if ( ( imm_val > 4095 ) || ( imm_val < -4096 ) ) {
    throw std::invalid_argument( "Invalid B-immediate: " +
                                 std::to_string( imm_val ) );
  }

  if ( imm_val % 2 ) {
    throw std::invalid_argument( "Invalid B-immediate: " +
                                 std::to_string( imm_val ) );
  }

  uint32_t imm_encoding = 0;
  imm_encoding |= ( bitslice( imm_val, 4, 1 ) << 8 );
  imm_encoding |= ( bitslice( imm_val, 10, 5 ) << 25 );
  imm_encoding |= ( bitslice( imm_val, 11, 11 ) << 7 );
  imm_encoding |= ( bitslice( imm_val, 12, 12 ) << 31 );

  return imm_encoding;
}

uint32_t imm_u_mask( std::string imm )
{
  int imm_val = std::stoi( imm );

  if ( ( imm_val < 0 ) || ( imm_val > 0xFFFFF ) ) {
    throw std::invalid_argument( "Invalid U-immediate: " +
                                 std::to_string( imm_val ) );
  }

  uint32_t imm_encoding = (uint32_t) ( imm_val << 12 );

  return imm_encoding;
}

uint32_t imm_j_mask( std::string imm )
{
  int imm_val = std::stoi( imm );

  if ( ( imm_val < 524288 ) || ( imm_val > -524288 ) ) {
    throw std::invalid_argument( "Invalid J-immediate: " +
                                 std::to_string( imm_val ) );
  }

  if ( imm_val % 2 ) {
    throw std::invalid_argument( "Invalid J-immediate: " +
                                 std::to_string( imm_val ) );
  }

  uint32_t imm_encoding = 0;
  imm_encoding |= ( bitslice( imm_val, 10, 1 ) << 21 );
  imm_encoding |= ( bitslice( imm_val, 11, 11 ) << 20 );
  imm_encoding |= ( bitslice( imm_val, 19, 12 ) << 12 );
  imm_encoding |= ( bitslice( imm_val, 20, 20 ) << 31 );

  return imm_encoding;
}

#endif  // INST32_UTILS_CPP