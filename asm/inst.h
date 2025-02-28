//========================================================================
// inst.h
//========================================================================
// The instructions that are supported by the assembler, as well as
// functions to operate on the specifications

#ifndef INST_H
#define INST_H

#include <cstdint>
#include <string>
#include <vector>

enum inst_name_t { ADD, ADDI, MUL, LW, SW };

typedef struct {
  inst_name_t name;
  std::string assembly;
  uint32_t    match;
  uint32_t    mask;
} inst_spec_t;

//------------------------------------------------------------------------
// Instruction Specifications
//------------------------------------------------------------------------

const inst_spec_t inst_specs[] = {

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Register-Register Arithmetic
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    { ADD, "add  rd, rs1, rs2", 0x00000033, 0xFE00707F },
    { MUL, "mul  rd, rs1, rs2", 0x02000033, 0xFE00707F },

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Register-Immediate Arithmetic
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    { ADDI, "addi rd, rs1, imm_i", 0x00000013, 0x0000707F },

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Memory
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    { LW, "lw   rd, imm_i(rs1)", 0x00002003, 0x0000707F },
    { SW, "sw   rs2, imm_s(rs1)", 0x00002023, 0x0000707F },
};

//------------------------------------------------------------------------
// Parse a given assembly into tokens
//------------------------------------------------------------------------

std::vector<std::string> tokenize( const std::string& assembly );

//------------------------------------------------------------------------
// Find the appropriate specification
//------------------------------------------------------------------------

const inst_spec_t* get_inst_spec( const std::string& inst_name );
const inst_spec_t* get_inst_spec( uint32_t inst_bin );

//------------------------------------------------------------------------
// Operate on specifications
//------------------------------------------------------------------------

std::string inst_spec_name( const inst_spec_t* spec );

#endif  // INST_H