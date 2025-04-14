//========================================================================
// addi_test_cases.v
//========================================================================
// Adapted from Cornell's ECE 2300

//------------------------------------------------------------------------
// test_case_directed_addi_1_basic
//------------------------------------------------------------------------

task test_case_directed_addi_1_basic();
  h.t.test_case_begin( "test_case_directed_addi_1_basic" );
  if( !h.t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  h.asm( 'h200, "addi x1, x0, 2"   );
  h.asm( 'h204, "addi x2, x1, 2"   );

  // Check each executed instruction

  h.check_trace( 'h200, 1, 'h0000_0002, 1 ); // addi x1, x0, 2
  h.check_trace( 'h204, 2, 'h0000_0004, 1 ); // addi x2, x1, 2

  h.t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_addi_2_x0
//------------------------------------------------------------------------

task test_case_directed_addi_2_x0();
  h.t.test_case_begin( "test_case_directed_addi_2_x0" );
  if( !h.t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  h.asm( 'h200, "addi x1, x0, 2"   );
  h.asm( 'h204, "addi x0, x1, 3"   );
  h.asm( 'h208, "addi x2, x0, 4"   );
  h.asm( 'h20c, "addi x0, x0, 5"   );
  h.asm( 'h210, "addi x3, x0, 6"   );

  // Check each executed instruction

  h.check_trace( 'h200, 1,  'h0000_0002, 1 ); // addi x1, x0, 2
  h.check_trace( 'h204, 'x, 'x,          0 ); // addi x0, x1, 3
  h.check_trace( 'h208, 2,  'h0000_0004, 1 ); // addi x2, x0, 4
  h.check_trace( 'h20c, 'x, 'x,          0 ); // addi x0, x0, 5
  h.check_trace( 'h210, 3,  'h0000_0006, 1 ); // addi x3, x0, 6

  h.t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_addi_3_pos
//------------------------------------------------------------------------

task test_case_directed_addi_3_pos();
  h.t.test_case_begin( "test_case_directed_addi_3_pos" );
  if( !h.t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  h.asm( 'h200, "addi x1,  x0,  1"    );
  h.asm( 'h204, "addi x2,  x1,  3"    );
  h.asm( 'h208, "addi x2,  x1,  4"    );
  h.asm( 'h20c, "addi x2,  x1,  5"    );

  h.asm( 'h210, "addi x1,  x0,  1"    );
  h.asm( 'h214, "addi x2,  x1,  2001" );
  h.asm( 'h218, "addi x2,  x1,  2002" );
  h.asm( 'h21c, "addi x2,  x1,  2003" );

  // Check each executed instruction

  h.check_trace( 'h200, 1, 1,    1 ); // addi x1,  x0,  1
  h.check_trace( 'h204, 2, 4,    1 ); // addi x2,  x1,  3
  h.check_trace( 'h208, 2, 5,    1 ); // addi x2,  x1,  4
  h.check_trace( 'h20c, 2, 6,    1 ); // addi x2,  x1,  5

  h.check_trace( 'h210, 1, 1,    1 ); // addi x1,  x0,  1
  h.check_trace( 'h214, 2, 2002, 1 ); // addi x2,  x1,  2001
  h.check_trace( 'h218, 2, 2003, 1 ); // addi x2,  x1,  2002
  h.check_trace( 'h21c, 2, 2004, 1 ); // addi x2,  x1,  2003

  h.t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_addi_4_neg
//------------------------------------------------------------------------

task test_case_directed_addi_4_neg();
  h.t.test_case_begin( "test_case_directed_addi_4_neg" );
  if( !h.t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  h.asm( 'h200, "addi x1,  x0,  1"     );
  h.asm( 'h204, "addi x2,  x1,  -3"    );
  h.asm( 'h208, "addi x2,  x1,  -4"    );
  h.asm( 'h20c, "addi x2,  x1,  -5"    );

  h.asm( 'h210, "addi x1,  x0,  1"     );
  h.asm( 'h214, "addi x2,  x1,  -2001" );
  h.asm( 'h218, "addi x2,  x1,  -2002" );
  h.asm( 'h21c, "addi x2,  x1,  -2003" );

  // Check each executed instruction

  h.check_trace( 'h200, 1, 1,     1 ); // addi x1,  x0,  1
  h.check_trace( 'h204, 2, -2,    1 ); // addi x2,  x1,  -3
  h.check_trace( 'h208, 2, -3,    1 ); // addi x2,  x1,  -4
  h.check_trace( 'h20c, 2, -4,    1 ); // addi x2,  x1,  -5

  h.check_trace( 'h210, 1, 1,     1 ); // addi x1,  x0,  1
  h.check_trace( 'h214, 2, -2000, 1 ); // addi x2,  x1,  -2001
  h.check_trace( 'h218, 2, -2001, 1 ); // addi x2,  x1,  -2002
  h.check_trace( 'h21c, 2, -2002, 1 ); // addi x2,  x1,  -2003

  h.t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_addi_5_overflow
//------------------------------------------------------------------------

task test_case_directed_addi_5_overflow();
  h.t.test_case_begin( "test_case_directed_addi_5_overflow" );
  if( !h.t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  h.asm( 'h200, "addi x1,  x0,  0xfff" );
  h.asm( 'h204, "addi x2,  x1,  0xfff" );

  // Check each executed instruction

  h.check_trace( 'h200, 1, 'hffff_ffff, 1 ); // addi x1,  x0,  0xfff
  h.check_trace( 'h204, 2, 'hffff_fffe, 1 ); // addi x2,  x1,  0xfff

  h.t.test_case_end();
endtask

//------------------------------------------------------------------------
// run_directed_addi_tests
//------------------------------------------------------------------------

task run_directed_addi_tests();
  test_case_directed_addi_1_basic();
  test_case_directed_addi_2_x0();
  test_case_directed_addi_3_pos();
  test_case_directed_addi_4_neg();
  test_case_directed_addi_5_overflow();
endtask
