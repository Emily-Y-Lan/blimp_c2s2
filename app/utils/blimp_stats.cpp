//========================================================================
// blimp_stats.cpp
//========================================================================
// Utilities for reporting processor statistics

#include "utils/blimp_stats.h"

#ifdef _RISCV

uint32_t blimp_cycle_count()
{
  uint32_t* cycle_count_addr = (uint32_t*) 0xFFFFFF00;
  return *cycle_count_addr;
}

#endif  // _RISCV