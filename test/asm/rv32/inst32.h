//========================================================================
// inst32.h
//========================================================================
// The instructions that are supported by the assembler, as well as
// functions to operate on the specifications

#ifndef INST32_H
#define INST32_H

#include <cstdint>
#include <string>
#include <vector>

typedef struct {
  std::string assembly;
  uint32_t match;
  uint32_t mask;
} inst_spec;

//------------------------------------------------------------------------
// Instruction Specifications
//------------------------------------------------------------------------

const inst_spec inst_specs[] = {

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Register-Register Arithmetic
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    {"add  rd, rs1, rs2", 0x00000033, 0xFE00707F},
    {"mul  rd, rs1, rs2", 0x02000033, 0xFE00707F},

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Register-Immediate Arithmetic
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    {"addi rd, rs1, imm_i", 0x00000013, 0x0000707F},

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Memory
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    {"lw   rd, imm_i(rs1)", 0x00002003, 0x0000707F},
    {"sw   rs2, imm_s(rs1)", 0x00002023, 0x0000707F},
};

//------------------------------------------------------------------------
// Parse a given assembly into tokens
//------------------------------------------------------------------------

std::vector<std::string> tokenize(std::string assembly);

//------------------------------------------------------------------------
// Find the appropriate specification
//------------------------------------------------------------------------

inst_spec get_inst_spec(std::string inst_name);
inst_spec get_inst_spec(uint32_t inst_bin);

#endif  // INST32_H