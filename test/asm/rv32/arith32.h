//========================================================================
// arith32.h
//========================================================================
// Declarations of our arithmetic-instruction assemblers

#ifndef ARITH32_H
#define ARITH32_H

#include <cstdint>
#include <string>
#include <vector>

uint32_t asm32_addi( std::vector<std::string> tokens );

#endif  // ARITH32_H