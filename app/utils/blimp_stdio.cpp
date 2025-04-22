//========================================================================
// blimp_stdio.cpp
//========================================================================
// Implementations of Blimp's IO functions

#include "utils/blimp_stdio.h"
#include "utils/blimp_string.h"

#ifdef _RISCV
#include <cctype>
#include <stdarg.h>

// -----------------------------------------------------------------------
// Basic IO functions (inlined)
// -----------------------------------------------------------------------
// Use assembly to avoid doing non-32b memory operations

inline void blimp_print_char( char c )
{
  int char_to_store = (int) c;
  __asm__(
      "lui  t0, 0xf0000 \n"
      "sw   %0, 0(t0)" ::"r"( char_to_store )
      : "t0" );
}

inline char blimp_get_char()
{
  int char_to_load;
  __asm__ volatile(
      "lui  t0, 0xf0000 \n"
      "lw   %0, 4(t0)"
      : "=r"( char_to_load )::"t0" );
  return (char) char_to_load;
}

// -----------------------------------------------------------------------
// Basic character manipulation
// -----------------------------------------------------------------------

void blimp_putchar( char c )
{
  blimp_print_char( c );
}

char blimp_getchar()
{
  return blimp_get_char();
}

// -----------------------------------------------------------------------
// Formatted IO Manipulation
// -----------------------------------------------------------------------
// Note: I used Gemini for help with variable arguments and integer
// conversion

void blimp_printf( const char* format, ... )
{
  va_list args;
  va_start( args, format );

  while ( *format != '\0' ) {
    if ( *format == '%' ) {
      format++;
      int width = 0;
      while ( *format >= '0' && *format <= '9' ) {
        width = ( width * 10 ) + ( *format - '0' );
        format++;
      }
      switch ( *format ) {
        case 'c': {
          char c = va_arg( args, int );
          blimp_print_char( c );
          break;
        }
        case 's': {
          char* s = va_arg( args, char* );
          for ( int i = blimp_strlen( s ); i < width; i++ ) {
            blimp_print_char( ' ' );
          }
          while ( *s != '\0' ) {
            blimp_print_char( *s );
            s++;
          }
          break;
        }
        case 'd': {
          int  num = va_arg( args, int );
          char buffer[20];
          int  i = 0;
          if ( num < 0 ) {
            blimp_print_char( '-' );
            num = -num;
          }
          do {
            buffer[i++] = num % 10 + '0';
            num /= 10;
          } while ( num > 0 );
          for ( int j = i; j < width; j++ ) {
            blimp_print_char( ' ' );
          }
          while ( i > 0 ) {
            blimp_print_char( buffer[--i] );
          }
          break;
        }
        case '%': {
          blimp_print_char( '%' );
        }
        default:
          blimp_print_char( '%' );
          blimp_print_char( *format );
          break;
      }
    }
    else {
      blimp_print_char( *format );
    }
    format++;
  }
  va_end( args );
}

// -----------------------------------------------------------------------
// String putting and getting
// -----------------------------------------------------------------------

int blimp_fputs( const char* str )
{
  while ( *str ) {
    blimp_print_char( *str );
    str++;
  }
  return 0;
}

char* blimp_fgets( char* str, int num )
{
  if ( num < 2 )
    return str;

  int  idx = 0;
  char c;
  do {
    c = blimp_get_char();
    if ( c != EOF ) {
      str[idx++] = c;
    }
    else {
      if ( idx == 0 ) {
        return nullptr;
      }
    }
  } while ( ( c != EOF ) & ( c != '\n' ) & ( idx < num - 1 ) );
  str[idx] = '\0';
  return str;
}

int blimp_fflush()
{
  // Do nothing for now
  return 0;
}

// -----------------------------------------------------------------------
// String formatting
// -----------------------------------------------------------------------
// Note: I used Gemini to help me figure out the overall
// structure/workflow

int blimp_sscanf( const char* input, const char* format, ... )
{
  va_list args;
  va_start( args, format );
  int matches = 0;

  while ( *format ) {
    if ( *format == '%' ) {
      format++;
      if ( *format == 'c' ) {
        char* ptr = va_arg( args, char* );
        if ( *input ) {
          *ptr = *input;
          input++;
          matches++;
        }
        else {
          va_end( args );
          return matches ? matches : -1;
        }
      }
      if ( *format == 'd' ) {
        int* ptr    = va_arg( args, int* );
        int  result = 0;
        int  sign   = 1;
        while ( *input && blimp_isspace( *input ) ) {
          input++;
        }
        if ( *input && *input == '-' ) {
          sign = -1;
          input++;
        }
        else if ( *input && *input == '+' ) {
          input++;
        }
        if ( *input & !blimp_isdigit( *input ) ) {
          va_end( args );
          return matches ? matches : -1;
        }
        bool done = false;
        while ( !done ) {
          if ( *input ) {
            if ( blimp_isdigit( *input ) ) {
              result = result * 10 + ( *input - '0' );
              input++;
            }
            else {
              done = true;
            }
          }
          else {
            va_end( args );
            return matches ? matches : -1;
          }
        }
        *ptr = result * sign;
        matches++;
      }
      else if ( *format == 's' ) {
        char* ptr = va_arg( args, char* );
        while ( *input && blimp_isspace( *input ) ) {
          input++;
        }
        if ( *input ) {
          matches++;
        }
        while ( *input && !blimp_isspace( *input ) ) {
          *ptr++ = *input++;
        }
        *ptr = '\0';
      }
      else if ( *format == '%' ) {
        if ( *input == '%' ) {
          input++;
        }
        else {
          va_end( args );
          return matches ? matches : -1;
        }
      }
      else {
        va_end( args );
        return matches ? matches : -1;
      }
    }
    else if ( *format == *input ) {
      input++;
    }
    else {
      va_end( args );
      return matches ? matches : -1;
    }
    format++;
  }
  va_end( args );
  return matches;
}

char blimp_tolower( char c )
{
  if ( c >= 'A' && c <= 'Z' ) {
    return c - 'A' + 'a';
  }
  else {
    return c;
  }
}

#endif  // _RISCV