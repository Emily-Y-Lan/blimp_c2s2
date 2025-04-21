//========================================================================
// blimp_string.cpp
//========================================================================
// Common string operations
//
// Note: I used Gemini to help understand the semantics of these functions

#include "utils/blimp_string.h"

#ifdef _RISCV

//------------------------------------------------------------------------
// blimp_memset
//------------------------------------------------------------------------

void* blimp_memset( void* dest, int val, size_t len )
{
  unsigned char* ptr = (unsigned char*) dest;
  while ( len-- > 0 ) {
    *ptr++ = (unsigned char) val;
  }
  return dest;
}

//------------------------------------------------------------------------
// blimp_strlen
//------------------------------------------------------------------------

size_t blimp_strlen( const char* str )
{
  if ( !str ) {
    return 0;
  }
  const char* end = str;
  while ( *end != '\0' ) {
    ++end;
  }
  return end - str;
}

//------------------------------------------------------------------------
// blimp_strcpy
//------------------------------------------------------------------------

void blimp_strcpy( char* dest, const char* src )
{
  int i = 0;
  while ( ( dest[i] = src[i] ) != '\0' ) {
    i++;
  }
}

//------------------------------------------------------------------------
// blimp_strcmp
//------------------------------------------------------------------------

int blimp_strcmp( const char* s1, const char* s2 )
{
  while ( *s1 != '\0' && *s2 != '\0' && *s1 == *s2 ) {
    s1++;
    s2++;
  }
  return (unsigned char) *s1 - (unsigned char) *s2;
}

//------------------------------------------------------------------------
// blimp_strrchr
//------------------------------------------------------------------------

char* blimp_strrchr( const char* str, int c )
{
  const char* p = NULL;

  while ( 1 ) {
    if ( *str == (char) c )
      p = str;
    if ( *str++ == '\0' )
      return (char*) p;
  }
}

//------------------------------------------------------------------------
// blimp_isdigit
//------------------------------------------------------------------------

bool blimp_isdigit( char c )
{
  return ( ( c >= '0' ) && ( c <= '9' ) );
}

//------------------------------------------------------------------------
// blimp_isspace
//------------------------------------------------------------------------

bool blimp_isspace( char c )
{
  return ( c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '\v' ||
           c == '\f' );
}

#endif  // _RISCV