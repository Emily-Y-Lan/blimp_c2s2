//========================================================================
// blimp_exit.cpp
//========================================================================
// A mechanism for Blimp to signal to exit

#include "utils/blimp_exit.h"

#ifdef _RISCV

void blimp_exit( int exit_code )
{
  int* exit_code_peripheral = (int*) 0xFFFFFFFC;
  *exit_code_peripheral     = exit_code;
}

#endif  // _RISCV