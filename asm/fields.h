//========================================================================
// inst32_utils.h
//========================================================================
// Utility functions for our assembler to get instruction fields

#ifndef FIELDS_H
#define FIELDS_H

#include <cstdint>
#include <string>

//------------------------------------------------------------------------
// Register Specifiers
//------------------------------------------------------------------------

uint32_t rs1_mask( const std::string& reg_name );
uint32_t rs2_mask( const std::string& reg_name );
uint32_t rd_mask( const std::string& reg_name );

uint32_t get_rs1( uint32_t binary );
uint32_t get_rs2( uint32_t binary );
uint32_t get_rd( uint32_t binary );

std::string get_rs1_id( uint32_t binary );
std::string get_rs2_id( uint32_t binary );
std::string get_rd_id( uint32_t binary );

//------------------------------------------------------------------------
// Immediate Specifiers
//------------------------------------------------------------------------

uint32_t imm_i_mask( const std::string& imm );
uint32_t imm_s_mask( const std::string& imm );
uint32_t imm_b_mask( const std::string& imm );
uint32_t imm_u_mask( const std::string& imm );
uint32_t imm_j_mask( const std::string& imm );

uint32_t get_imm_i( uint32_t binary );
uint32_t get_imm_s( uint32_t binary );
uint32_t get_imm_b( uint32_t binary );
uint32_t get_imm_u( uint32_t binary );
uint32_t get_imm_j( uint32_t binary );

std::string get_imm_i_id( uint32_t binary );
std::string get_imm_s_id( uint32_t binary );
std::string get_imm_b_id( uint32_t binary );
std::string get_imm_u_id( uint32_t binary );
std::string get_imm_j_id( uint32_t binary );

//------------------------------------------------------------------------
// Address Specifiers
//------------------------------------------------------------------------

uint32_t addr_b_mask( const std::string& addr, uint32_t pc );
uint32_t addr_u_mask( const std::string& addr, uint32_t pc );

uint32_t get_addr_b( uint32_t binary, uint32_t pc );
uint32_t get_addr_u( uint32_t binary, uint32_t pc );

std::string get_addr_b_id( uint32_t binary, uint32_t pc );
std::string get_addr_u_id( uint32_t binary, uint32_t pc );

#endif  // FIELDSS_H