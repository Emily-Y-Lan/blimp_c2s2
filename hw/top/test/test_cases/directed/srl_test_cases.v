//========================================================================
// srl_test_cases
//========================================================================

//------------------------------------------------------------------------
// test_case_directed_srl_1_basic
//------------------------------------------------------------------------

task test_case_directed_srl_1_basic();
  t.test_case_begin( "test_case_directed_srl_1_basic" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1, x0, 7"  );
  asm( 'h204, "addi x2, x0, 1"  );
  asm( 'h208, "srl  x3, x1, x2" );

  // Check each executed instruction

  check_trace( 'h200, 1, 'h0000_0007, 1 ); // addi x1, x0, 7
  check_trace( 'h204, 2, 'h0000_0001, 1 ); // addi x2, x0, 1
  check_trace( 'h208, 3, 'h0000_0003, 1 ); // srl  x3, x1, x2

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_srl_2_x0
//------------------------------------------------------------------------

task test_case_directed_srl_2_x0();
  t.test_case_begin( "test_case_directed_srl_2_x0" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1, x0, 1"  );
  asm( 'h204, "addi x2, x0, 2"  );
  asm( 'h208, "srl  x0, x0, x0" );
  asm( 'h20c, "srl  x0, x0, x1" );
  asm( 'h210, "srl  x0, x2, x0" );
  asm( 'h214, "srl  x3, x0, x1" );
  asm( 'h218, "srl  x4, x2, x0" );

  // Check each executed instruction

  check_trace( 'h200,  1, 'h01, 1 ); // addi x1, x0, 1
  check_trace( 'h204,  2, 'h02, 1 ); // addi x2, x0, 2
  check_trace( 'h208, 'x, 'x,   0 ); // srl  x0, x0, x0
  check_trace( 'h20c, 'x, 'x,   0 ); // srl  x0, x0, x1
  check_trace( 'h210, 'x, 'x,   0 ); // srl  x0, x2, x0
  check_trace( 'h214,  3, 'h00, 1 ); // srl  x3, x0, x1
  check_trace( 'h218,  4, 'h02, 1 ); // srl  x4, x2, x0


  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_srl_3_upper
//------------------------------------------------------------------------

task test_case_directed_srl_3_upper();
  t.test_case_begin( "test_case_directed_srl_3_upper" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0,  0xfff" );
  asm( 'h204, "addi x2,  x0,  0xae0" );
  asm( 'h208, "addi x3,  x0,  0x00a" );
  asm( 'h20c, "addi x4,  x0,  0x002" );

  asm( 'h210, "srl  x5,  x3,  x1"   );
  asm( 'h214, "srl  x6,  x3,  x2"   );
  asm( 'h218, "srl  x7,  x3,  x3"   );
  asm( 'h21c, "srl  x8,  x1,  x1"   );
  asm( 'h220, "srl  x9,  x3,  x4"   );
  asm( 'h224, "srl  x10, x2,  x4"   );

  // Check each executed instruction

  check_trace( 'h200, 1, 'hffff_ffff, 1 ); // addi x1,  x0,  0xfff
  check_trace( 'h204, 2, 'hffff_fae0, 1 ); // addi x2,  x0,  0xae0
  check_trace( 'h208, 3, 'h0000_000a, 1 ); // addi x3,  x0,  0x00a
  check_trace( 'h20c, 4, 'h0000_0002, 1 ); // addi x4,  x0,  2

  check_trace( 'h210, 5,  'h0000_0000, 1 ); // srl  x5,  x3,  x1
  check_trace( 'h214, 6,  'h0000_000a, 1 ); // srl  x6,  x3,  x2
  check_trace( 'h218, 7,  'h0000_0000, 1 ); // srl  x7,  x3,  x3
  check_trace( 'h21c, 8,  'h0000_0001, 1 ); // srl  x8,  x1,  x1
  check_trace( 'h220, 9,  'h0000_0002, 1 ); // srl  x9,  x3,  x4
  check_trace( 'h224, 10, 'h3fff_feb8, 1 ); // srl  x10, x2,  x4

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// run_directed_srl_tests
//------------------------------------------------------------------------

task run_directed_srl_tests();
  test_case_directed_srl_1_basic();
  test_case_directed_srl_2_x0();
  test_case_directed_srl_3_upper();
endtask
