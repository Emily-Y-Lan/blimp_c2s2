//========================================================================
// srai_test_cases
//========================================================================

//------------------------------------------------------------------------
// test_case_directed_srai_1_basic
//------------------------------------------------------------------------

task test_case_directed_srai_1_basic();
  t.test_case_begin( "test_case_directed_srai_1_basic" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1, x0, 7"  );
  asm( 'h204, "srai x2, x1, 1" );

  // Check each executed instruction

  check_trace( 'h200, 1, 'h0000_0007, 1 ); // addi x1, x0, 7
  check_trace( 'h204, 2, 'h0000_0003, 1 ); // srai x2, x1, 1

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_srai_2_x0
//------------------------------------------------------------------------

task test_case_directed_srai_2_x0();
  t.test_case_begin( "test_case_directed_srai_2_x0" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x2, x0, 2" );
  asm( 'h204, "srai x0, x0, 0" );
  asm( 'h208, "srai x0, x0, 1" );
  asm( 'h20c, "srai x0, x2, 0" );
  asm( 'h210, "srai x3, x0, 1" );
  asm( 'h214, "srai x4, x2, 0" );

  // Check each executed instruction

  check_trace( 'h200,  2, 'h02, 1 ); // addi x2, x0, 2
  check_trace( 'h204, 'x, 'x,   0 ); // srai x0, x0, 0
  check_trace( 'h208, 'x, 'x,   0 ); // srai x0, x0, 1
  check_trace( 'h20c, 'x, 'x,   0 ); // srai x0, x2, 0
  check_trace( 'h210,  3, 'h00, 1 ); // srai x3, x0, 1
  check_trace( 'h214,  4, 'h02, 1 ); // srai x4, x2, 0


  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_srai_3_upper
//------------------------------------------------------------------------

task test_case_directed_srai_3_upper();
  t.test_case_begin( "test_case_directed_srai_3_upper" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0,  0xfff" );
  asm( 'h204, "addi x2,  x0,  0xae0" );
  asm( 'h208, "addi x3,  x0,  0x00a" );

  asm( 'h20c, "srai  x5,  x3,  0x1f" );
  asm( 'h210, "srai  x6,  x3,  0x00" );
  asm( 'h214, "srai  x7,  x3,  0x0a" );
  asm( 'h218, "srai  x8,  x1,  0x1f" );
  asm( 'h21c, "srai  x9,  x3,  0x02" );
  asm( 'h220, "srai  x10, x2,  0x02" );

  // Check each executed instruction

  check_trace( 'h200, 1, 'hffff_ffff, 1 ); // addi x1,  x0,  0xfff
  check_trace( 'h204, 2, 'hffff_fae0, 1 ); // addi x2,  x0,  0xae0
  check_trace( 'h208, 3, 'h0000_000a, 1 ); // addi x3,  x0,  0x00a

  check_trace( 'h20c, 5,  'h0000_0000, 1 ); // srai  x5,  x3,  0x1f
  check_trace( 'h210, 6,  'h0000_000a, 1 ); // srai  x6,  x3,  0x00
  check_trace( 'h214, 7,  'h0000_0000, 1 ); // srai  x7,  x3,  0x0a
  check_trace( 'h218, 8,  'hffff_ffff, 1 ); // srai  x8,  x1,  0x1f
  check_trace( 'h21c, 9,  'h0000_0002, 1 ); // srai  x9,  x3,  0x02
  check_trace( 'h220, 10, 'hffff_feb8, 1 ); // srai  x10, x2,  0x02

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// run_directed_srai_tests
//------------------------------------------------------------------------

task run_directed_srai_tests();
  test_case_directed_srai_1_basic();
  test_case_directed_srai_2_x0();
  test_case_directed_srai_3_upper();
endtask
