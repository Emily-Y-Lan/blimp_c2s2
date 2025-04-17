//========================================================================
// blimp_wprintf.cpp
//========================================================================
// A simple printing mechanism for Blimp
//
// Adapted from the printing utilities from Cornell's ECE 6745
// https://github.com/cornell-ece6745/ece6745-lab2-release/blob/main/app/ece6745/ece6745-wprint.c

#ifdef _RISCV

#include "utils/blimp_wprintf.h"
#include <stdarg.h>

// -----------------------------------------------------------------------
// blimp_wprintf_int
// -----------------------------------------------------------------------

inline void blimp_wprint_int( int i )
{
  wchar_t* term = (wchar_t*) 0xf0000000;
  *term         = i;
}

// -----------------------------------------------------------------------
// blimp_wprintf_char
// -----------------------------------------------------------------------

inline void blimp_wprint_char( wchar_t c )
{
  wchar_t* term = (wchar_t*) 0xf0000004;
  *term         = c;
}

// -----------------------------------------------------------------------
// blimp_wprintf_str
// -----------------------------------------------------------------------

inline void blimp_wprint_str( const wchar_t* p )
{
  while ( *p != 0 ) {
    blimp_wprint_char( *p );
    p++;
  }
}

// -----------------------------------------------------------------------
// blimp_wprintf
// -----------------------------------------------------------------------

void blimp_wprintf( const wchar_t* fmt, ... )
{
  va_list args;
  va_start( args, fmt );

  int flag = 0;
  while ( *fmt != '\0' ) {
    if ( *fmt == '%' ) {
      flag = 1;
    }
    else if ( flag && ( *fmt == 'd' ) ) {
      blimp_wprint_int( va_arg( args, int ) );
      flag = 0;
    }
    else if ( flag && ( *fmt == 'C' ) ) {
      // note automatic conversion to integral type
      blimp_wprint_char( (wchar_t) ( va_arg( args, int ) ) );
      flag = 0;
    }
    else if ( flag && ( *fmt == 'S' ) ) {
      blimp_wprint_str( va_arg( args, wchar_t* ) );
      flag = 0;
    }
    else {
      blimp_wprint_char( *fmt );
    }
    ++fmt;
  }
  va_end( args );
}

#else

// We always need at least something in an object file, otherwise
// the native build won't work. So we create a dummy function for native
// builds.

int blimp_( int arg )
{
  return arg;
}

#endif  // _RISCV