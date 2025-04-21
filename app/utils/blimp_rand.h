//========================================================================
// blimp_rand.h
//========================================================================
// A software-defined RNG (not secure, but works well)

#ifndef BLIMP_RAND_H
#define BLIMP_RAND_H

// -----------------------------------------------------------------------
// RISCV
// -----------------------------------------------------------------------

#ifdef _RISCV

#ifdef __cplusplus
extern "C" {
#endif

int  blimp_rand();
void blimp_srand( unsigned int seed );

#ifdef __cplusplus
}
#endif

// -----------------------------------------------------------------------
// Native
// -----------------------------------------------------------------------

#else

#include <stdlib.h>
#define blimp_rand rand
#define blimp_srand srand
#endif

#endif  // BLIMP_EXIT_H