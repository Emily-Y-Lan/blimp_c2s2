//========================================================================
// sltiu_test_cases
//========================================================================

//------------------------------------------------------------------------
// test_case_directed_sltiu_1_basic
//------------------------------------------------------------------------

task test_case_directed_sltiu_1_basic();
  t.test_case_begin( "test_case_directed_sltiu_1_basic" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi  x1, x0, 4"  );
  asm( 'h204, "sltiu x2, x1, 5" );

  // Check each executed instruction

  check_trace( 'h200, 1, 'h0000_0004, 1 ); // addi  x1, x0, 4
  check_trace( 'h204, 2, 'h0000_0001, 1 ); // sltiu x3, x1, 5

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_sltiu_2_x0
//------------------------------------------------------------------------

task test_case_directed_sltiu_2_x0();
  t.test_case_begin( "test_case_directed_sltiu_2_x0" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi  x2, x0, 2"  );
  asm( 'h204, "sltiu x0, x0, 0" );
  asm( 'h208, "sltiu x0, x0, 1" );
  asm( 'h20c, "sltiu x0, x2, 0" );
  asm( 'h210, "sltiu x3, x0, 1" );
  asm( 'h214, "sltiu x4, x2, 0" );

  // Check each executed instruction

  check_trace( 'h200,  2, 'h02, 1 ); // addi  x2, x0, 2
  check_trace( 'h204, 'x, 'x,   0 ); // sltiu x0, x0, 0
  check_trace( 'h208, 'x, 'x,   0 ); // sltiu x0, x0, 1
  check_trace( 'h20c, 'x, 'x,   0 ); // sltiu x0, x2, 0
  check_trace( 'h210,  3, 'h01, 1 ); // sltiu x3, x0, 1
  check_trace( 'h214,  4, 'h00, 1 ); // sltiu x4, x2, 0


  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_sltiu_3_neg
//------------------------------------------------------------------------

task test_case_directed_sltiu_3_sign();
  t.test_case_begin( "test_case_directed_sltiu_3_sign" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi  x1,  x0,  -1"    );
  asm( 'h204, "addi  x2,  x0,  1"     );
  asm( 'h208, "addi  x3,  x0,  0x800" );

  asm( 'h20c, "sltiu x4,  x1,  1"     );
  asm( 'h210, "sltiu x5,  x2,  0x800" );
  asm( 'h214, "sltiu x6,  x3,  -1"    );
  asm( 'h218, "sltiu x7,  x1,  0"     );
  asm( 'h21c, "sltiu x8,  x1,  -1"    );
  asm( 'h220, "sltiu x9,  x0,  0"     );

  // Check each executed instruction

  check_trace( 'h200, 1, 'hffff_ffff,    1 ); // addi x1,  x0,  -1
  check_trace( 'h204, 2, 'h0000_0001,    1 ); // addi x2,  x0,  1
  check_trace( 'h208, 3, 'hffff_f800,    1 ); // addi x3,  x0,  0x800

  check_trace( 'h20c, 4, 'h0000_0000,    1 ); // sltiu x4,  x1,  1
  check_trace( 'h210, 5, 'h0000_0001,    1 ); // sltiu x5,  x2,  0x800
  check_trace( 'h214, 6, 'h0000_0001,    1 ); // sltiu x6,  x3,  -1
  check_trace( 'h218, 7, 'h0000_0000,    1 ); // sltiu x7,  x1,  0
  check_trace( 'h21c, 8, 'h0000_0000,    1 ); // sltiu x8,  x1,  -1
  check_trace( 'h220, 9, 'h0000_0000,    1 ); // sltiu x9,  x0,  0

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// run_directed_sltiu_tests
//------------------------------------------------------------------------

task run_directed_sltiu_tests();
  test_case_directed_sltiu_1_basic();
  test_case_directed_sltiu_2_x0();
  test_case_directed_sltiu_3_sign();
endtask
