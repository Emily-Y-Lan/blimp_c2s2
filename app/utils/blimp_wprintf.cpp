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
// blimp_wprintf_char
// -----------------------------------------------------------------------

inline void blimp_wprint_char( wchar_t c )
{
  wchar_t* term = (wchar_t*) 0xF0000000;
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
      int     num = va_arg( args, int );
      wchar_t buffer[20];
      int     i = 0;
      if ( num < 0 ) {
        blimp_wprint_char( L'-' );
        num = -num;
      }
      do {
        buffer[i++] = num % 10 + L'0';
        num /= 10;
      } while ( num > 0 );
      while ( i > 0 ) {
        blimp_wprint_char( buffer[--i] );
      }
      flag = 0;
    }
    else if ( flag && ( *fmt == 'c' ) ) {
      // note automatic conversion to integral type
      blimp_wprint_char( (wchar_t) ( va_arg( args, int ) ) );
      flag = 0;
    }
    else if ( flag && ( *fmt == 's' ) ) {
      blimp_wprint_str( va_arg( args, wchar_t* ) );
      flag = 0;
    }
    else {
      blimp_wprint_char( *fmt );
      flag = 0;
    }
    ++fmt;
  }
  va_end( args );
}

#endif  // _RISCV