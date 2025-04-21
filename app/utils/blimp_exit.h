//========================================================================
// blimp_exit.h
//========================================================================
// A mechanism for Blimp to signal to exit

#ifndef BLIMP_EXIT_H
#define BLIMP_EXIT_H

// -----------------------------------------------------------------------
// RISCV
// -----------------------------------------------------------------------

#ifdef _RISCV

#ifdef __cplusplus
extern "C" {
#endif

void blimp_exit( int exit_code );

#ifdef __cplusplus
}
#endif

// -----------------------------------------------------------------------
// Native
// -----------------------------------------------------------------------

#else

#include <stdlib.h>
#define blimp_exit exit
#endif

#endif  // BLIMP_EXIT_H