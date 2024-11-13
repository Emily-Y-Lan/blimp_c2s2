//========================================================================
// inst.h
//========================================================================
// The instructions that are supported by the assembler

#ifndef INST_H
#define INST_H

#include <cstdint>
#include <string>

typedef struct {
  std::string assembly;
  uint32_t    match;
  uint32_t    mask;
} inst_spec;

static const inst_spec insts[] = {
    { "addi rd, rs1, imm_i", 0x00000013, 0x0000707F },
};

#endif  // INST_H