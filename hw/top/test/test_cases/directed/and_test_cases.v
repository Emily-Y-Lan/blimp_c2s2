//========================================================================
// and_test_cases
//========================================================================

//------------------------------------------------------------------------
// test_case_directed_and_1_basic
//------------------------------------------------------------------------

task test_case_directed_and_1_basic();
  t.test_case_begin( "test_case_directed_and_1_basic" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1, x0, 5"  );
  asm( 'h204, "addi x2, x0, 3"  );
  asm( 'h208, "and  x3, x1, x2" );

  // Check each executed instruction

  check_trace( 'h200, 1, 'h0000_0005, 1 ); // addi x1, x0, 5
  check_trace( 'h204, 2, 'h0000_0003, 1 ); // addi x2, x0, 3
  check_trace( 'h208, 3, 'h0000_0001, 1 ); // and  x3, x1, x2

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_and_2_x0
//------------------------------------------------------------------------

task test_case_directed_and_2_x0();
  t.test_case_begin( "test_case_directed_and_2_x0" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1, x0, 1"  );
  asm( 'h204, "addi x2, x0, 2"  );
  asm( 'h208, "and  x0, x0, x0" );
  asm( 'h20c, "and  x0, x0, x1" );
  asm( 'h210, "and  x0, x2, x0" );
  asm( 'h214, "and  x3, x0, x1" );
  asm( 'h218, "and  x4, x2, x0" );

  // Check each executed instruction

  check_trace( 'h200,  1, 'h01, 1 ); // addi x1, x0, 1
  check_trace( 'h204,  2, 'h02, 1 ); // addi x2, x0, 2
  check_trace( 'h208, 'x, 'x,   0 ); // and  x0, x0, x0
  check_trace( 'h20c, 'x, 'x,   0 ); // and  x0, x0, x1
  check_trace( 'h210, 'x, 'x,   0 ); // and  x0, x2, x0
  check_trace( 'h214,  3, 'h00, 1 ); // and  x3, x0, x1
  check_trace( 'h218,  4, 'h00, 1 ); // and  x4, x2, x0


  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_and_3_extreme
//------------------------------------------------------------------------

task test_case_directed_and_3_extreme();
  t.test_case_begin( "test_case_directed_and_3_extreme" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0,  0xfff" );
  asm( 'h204, "addi x2,  x0,  0x7ff" );
  asm( 'h208, "addi x3,  x0,  1"     );

  asm( 'h20c, "and  x4,  x1,  x2"   );
  asm( 'h210, "and  x5,  x2,  x3"   );
  asm( 'h214, "and  x6,  x3,  x1"   );
  asm( 'h218, "and  x7,  x1,  x0"   );
  asm( 'h21c, "and  x8,  x1,  x1"   );
  asm( 'h220, "and  x9,  x0,  x0"   );

  // Check each executed instruction

  check_trace( 'h200, 1, 'hffff_ffff,    1 ); // addi x1,  x0,  0xfff
  check_trace( 'h204, 2, 'h0000_07ff,    1 ); // addi x2,  x0,  0x7ff
  check_trace( 'h208, 3, 'h0000_0001,    1 ); // addi x3,  x0,  1

  check_trace( 'h20c, 4, 'h0000_07ff,    1 ); // and  x4,  x1,  x2
  check_trace( 'h210, 5, 'h0000_0001,    1 ); // and  x5,  x2,  x3
  check_trace( 'h214, 6, 'h0000_0001,    1 ); // and  x6,  x3,  x1
  check_trace( 'h218, 7, 'h0000_0000,    1 ); // and  x7,  x1,  x0
  check_trace( 'h21c, 8, 'hffff_ffff,    1 ); // and  x8,  x1,  x1
  check_trace( 'h220, 9, 'h0000_0000,    1 ); // and  x9,  x0,  x0

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// run_directed_and_tests
//------------------------------------------------------------------------

task run_directed_and_tests();
  test_case_directed_and_1_basic();
  test_case_directed_and_2_x0();
  test_case_directed_and_3_extreme();
endtask
