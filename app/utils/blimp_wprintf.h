//========================================================================
// blimp_wprintf.h
//========================================================================
// A simple printing mechanism for Blimp

#ifndef BLIMP_PRINT_H
#define BLIMP_PRINT_H

#include <wchar.h>

#ifdef _RISCV

#ifdef __cplusplus
extern "C" {
#endif
void blimp_wprintf( const wchar_t* fmt, ... );
#ifdef __cplusplus
}
#endif

#else

#define blimp_wprintf wprintf

#endif  // _RISCV

#endif  // BLIMP_PRINT_H