//========================================================================
// vvadd.cpp
//========================================================================
// A simple test for vector-vector add

#include "utils/blimp_wprintf.h"
#include <cstdint>

// -----------------------------------------------------------------------
// vvadd
// -----------------------------------------------------------------------

void vvadd( uint8_t* a, uint8_t* b, uint8_t* dest, int len )
{
  for ( int i = 0; i < len; i++ ) {
    dest[i] = a[i] + b[i];
  }
}

// -----------------------------------------------------------------------
// main
// -----------------------------------------------------------------------

uint8_t a[5] = { 1, 2, 3, 4, 5 };
uint8_t b[5] = { 7, 8, 9, 10, 11 };
uint8_t c[5];

int main()
{
  vvadd( a, b, c, 5 );

  blimp_wprintf( L"A: {" );
  for ( int i = 0; i < 5; i++ ) {
    if ( i > 0 )
      blimp_wprintf( L", " );
    blimp_wprintf( L"%d", a[i] );
  }
  blimp_wprintf( L"}\n" );

  blimp_wprintf( L"B: {" );
  for ( int i = 0; i < 5; i++ ) {
    if ( i > 0 )
      blimp_wprintf( L", " );
    blimp_wprintf( L"%d", b[i] );
  }
  blimp_wprintf( L"}\n" );

  blimp_wprintf( L"C: {" );
  for ( int i = 0; i < 5; i++ ) {
    if ( i > 0 )
      blimp_wprintf( L", " );
    blimp_wprintf( L"%d", c[i] );
  }
  blimp_wprintf( L"}\n" );
}