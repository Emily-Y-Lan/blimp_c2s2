//========================================================================
// blimp_misc.h
//========================================================================
// Other miscellaneous operations

#ifndef BLIMP_MISC_H
#define BLIMP_MISC_H

// -----------------------------------------------------------------------
// RISCV
// -----------------------------------------------------------------------

#ifdef _RISCV

#ifdef __cplusplus
extern "C" {
#endif

long blimp_atol( const char* str );

#ifdef __cplusplus
}
#endif

// -----------------------------------------------------------------------
// Native
// -----------------------------------------------------------------------

#else

#include <stdlib.h>
#define blimp_atol atol
#endif

#endif  // BLIMP_MISC_H