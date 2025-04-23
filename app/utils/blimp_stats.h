//========================================================================
// blimp_stats.h
//========================================================================
// Utilities for reporting processor statistics

#ifndef BLIMP_STATS_H
#define BLIMP_STATS_H

// -----------------------------------------------------------------------
// RISCV
// -----------------------------------------------------------------------

#ifdef _RISCV

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
uint32_t blimp_cycle_count();

#ifdef __cplusplus
}
#endif

// -----------------------------------------------------------------------
// Native
// -----------------------------------------------------------------------

#else

// No strict notion of cycles
#define blimp_cycle_count() 0

#endif

#endif  // BLIMP_STATS_H