//========================================================================
// blimp_stdio.h
//========================================================================
// Common functions for I/O manipulation using Blimp's memory-mapped
// peripherals
//
// Assumes RV32I support

#ifndef BLIMP_STDIO_H
#define BLIMP_STDIO_H

#include <stdio.h>

// -----------------------------------------------------------------------
// RISCV
// -----------------------------------------------------------------------

#ifdef _RISCV

#ifdef __cplusplus
extern "C" {
#endif

void blimp_putchar( char c );
char blimp_getchar();

// Supported format specifiers: %c, %d, %s
//
// printf also supports basic width specifiers for %d and %s,
// using space padding
void blimp_printf( const char *format, ... );
int  blimp_sscanf( const char *input, const char *format, ... );

// Note that these differ from usual signatures, as file streams are
// not supported
int   blimp_fputs( const char *str );
char *blimp_fgets( char *str, int num );
int   blimp_fflush();

char blimp_tolower( char c );

#ifdef __cplusplus
}
#endif

// -----------------------------------------------------------------------
// Native
// -----------------------------------------------------------------------

#else

#include <ctype.h>

#define blimp_putchar putchar
#define blimp_getchar getchar

#define blimp_printf printf
#define blimp_sscanf sscanf

#define blimp_fputs( str ) fputs( str, stdout )
#define blimp_fgets( str, num ) fgets( str, num, stdin )
#define blimp_fflush() fflush( stdout )

#define blimp_tolower tolower

#endif

#endif  // BLIMP_STDIO_H