//========================================================================
// utils.h
//========================================================================
// Utility function declarations for our assembler

#ifndef UTILS_H
#define UTILS_H

#include <cstdint>
#include <string>

//------------------------------------------------------------------------
// Register Specifiers
//------------------------------------------------------------------------

uint32_t rs1_mask( std::string reg_name );
uint32_t rs2_mask( std::string reg_name );
uint32_t rd_mask( std::string reg_name );

//------------------------------------------------------------------------
// Immediate Specifiers
//------------------------------------------------------------------------

uint32_t imm_i_mask( int imm );

#endif  // UTILS_H