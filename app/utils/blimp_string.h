//========================================================================
// blimp_string.h
//========================================================================
// Common string operations

#ifndef BLIMP_STRING_H
#define BLIMP_STRING_H

// -----------------------------------------------------------------------
// RISCV
// -----------------------------------------------------------------------

#ifdef _RISCV

#include <stdbool.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

void*  blimp_memset( void* dest, int val, size_t len );
size_t blimp_strlen( const char* str );
void   blimp_strcpy( char* dest, const char* src );
int    blimp_strcmp( const char* s1, const char* s2 );
char*  blimp_strrchr( const char* str, int c );
bool   blimp_isdigit( char c );
bool   blimp_isspace( char c );

#ifdef __cplusplus
}
#endif

// -----------------------------------------------------------------------
// Native
// -----------------------------------------------------------------------

#else

#include <ctype.h>
#include <string.h>
#define blimp_memset memset
#define blimp_strlen strlen
#define blimp_strcpy strcpy
#define blimp_strcmp strcmp
#define blimp_strrchr strrchr
#define blimp_isdigit isdigit
#define blimp_isspace isspace
#endif

#endif  // BLIMP_EXIT_H