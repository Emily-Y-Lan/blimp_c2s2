//========================================================================
// blimp_misc.cpp
//========================================================================
// Other miscellaneous operations

#include "utils/blimp_misc.h"
#include "utils/blimp_string.h"

#ifdef _RISCV

//------------------------------------------------------------------------
// blimp_atol
//------------------------------------------------------------------------
// Inspired by Gemini

long blimp_atol( const char* str )
{
  long result  = 0;
  int  sign    = 1;
  bool started = false;

  if ( str == NULL ) {
    return 0;
  }

  while ( *str != '\0' ) {
    if ( blimp_isspace( (unsigned char) *str ) ) {
      if ( started ) {
        break;
      }
    }
    else if ( *str == '-' ) {
      if ( started ) {
        break;
      }
      sign    = -1;
      started = true;
    }
    else if ( *str == '+' ) {
      if ( started ) {
        break;
      }
      sign    = 1;
      started = true;
    }
    else if ( blimp_isdigit( (unsigned char) *str ) ) {
      result  = result * 10 + ( *str - '0' );
      started = true;
    }
    else {
      break;
    }
    str++;
  }

  return result * sign;
}

#endif  // _RISCV