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

uint32_t rs1_mask(std::string reg_name);
uint32_t rs2_mask(std::string reg_name);
uint32_t rd_mask(std::string reg_name);

std::string get_rs1(uint32_t binary);
std::string get_rs2(uint32_t binary);
std::string get_rd(uint32_t binary);

//------------------------------------------------------------------------
// Immediate Specifiers
//------------------------------------------------------------------------

uint32_t imm_i_mask(std::string imm);
uint32_t imm_s_mask(std::string imm);
uint32_t imm_b_mask(std::string imm);
uint32_t imm_u_mask(std::string imm);
uint32_t imm_j_mask(std::string imm);

std::string get_imm_i(uint32_t binary);
std::string get_imm_s(uint32_t binary);
std::string get_imm_b(uint32_t binary);
std::string get_imm_u(uint32_t binary);
std::string get_imm_j(uint32_t binary);

#endif  // INST32_UTILS_H