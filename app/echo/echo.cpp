//========================================================================
// echo.cpp
//========================================================================
// Echo back user input to test our IO functions

#include "utils/blimp_stdio.h"
#include <stdio.h>

int main()
{
  blimp_fputs( "Enter a string: " );

  char buffer[20];
  blimp_fgets( buffer, 20 );
  blimp_printf( "Received string: %s", buffer );

  blimp_printf( "Enter an integer (such as %d), then a string: ", 20 );

  blimp_fgets( buffer, 20 );
  int num;
  int conversions = blimp_sscanf( buffer, "%d %s", &num, buffer );
  blimp_printf( "Received integer: %d\n", num );
  blimp_printf( "Received string: %s\n", buffer );
  blimp_printf( "Number of conversions: %d\n", conversions );
  return 0;
}