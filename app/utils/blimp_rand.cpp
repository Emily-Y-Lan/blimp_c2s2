//========================================================================
// blimp_rand.cpp
//========================================================================
// A software-defined RNG
//
// Sourced from Cornell's ECE 6745, which was adapted from the 16-bit LFSR
// on Wikipedia:
//
//     https://en.wikipedia.org/wiki/Linear-feedback_shift_register

#include "utils/blimp_rand.h"

#ifdef _RISCV

static unsigned int blimp_lfsr = 0x0000cafe;

int blimp_rand( void )  // RAND_MAX assumed to be 32767
{
  int x      = blimp_lfsr;
  int bit    = ( x ^ ( x >> 1 ) ^ ( x >> 3 ) ^ ( x >> 12 ) ) & 0x00000001;
  blimp_lfsr = ( blimp_lfsr >> 1 ) | ( bit << 15 );

  return blimp_lfsr;
}

void blimp_srand( unsigned int seed )
{
  blimp_lfsr = 0x0000ffff & seed;
}

#endif  // _RISCV