//========================================================================
// inst32_utils.h
//========================================================================
// Utility function declarations for our assembler

#ifndef INST32_UTILS_H
#define INST32_UTILS_H

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

uint32_t imm_i_mask( std::string imm );
uint32_t imm_s_mask( std::string imm );
uint32_t imm_b_mask( std::string imm );
uint32_t imm_u_mask( std::string imm );
uint32_t imm_j_mask( std::string imm );

#endif  // INST32_UTILS_H