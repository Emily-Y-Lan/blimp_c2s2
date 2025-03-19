//========================================================================
// sub_test_cases
//========================================================================

//------------------------------------------------------------------------
// test_case_directed_sub_1_basic
//------------------------------------------------------------------------

task test_case_directed_sub_1_basic();
  t.test_case_begin( "test_case_directed_sub_1_basic" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1, x0, 2"  );
  asm( 'h204, "addi x2, x0, 3"  );
  asm( 'h208, "sub  x3, x2, x1" );

  // Check each executed instruction

  check_trace( 'h200, 1, 'h0000_0002, 1 ); // addi x1, x0, 2
  check_trace( 'h204, 2, 'h0000_0003, 1 ); // addi x2, x0, 3
  check_trace( 'h208, 3, 'h0000_0001, 1 ); // sub  x3, x2, x1

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_sub_2_x0
//------------------------------------------------------------------------

task test_case_directed_sub_2_x0();
  t.test_case_begin( "test_case_directed_sub_2_x0" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1, x0, 1"  );
  asm( 'h204, "addi x2, x0, 2"  );
  asm( 'h208, "sub  x0, x0, x0" );
  asm( 'h20c, "sub  x0, x0, x1" );
  asm( 'h210, "sub  x0, x2, x0" );
  asm( 'h214, "sub  x3, x0, x1" );
  asm( 'h218, "sub  x4, x2, x0" );

  // Check each executed instruction

  check_trace( 'h200,  1, 'h01,        1 ); // addi x1, x0, 1
  check_trace( 'h204,  2, 'h02,        1 ); // addi x2, x0, 2
  check_trace( 'h208, 'x, 'x,          0 ); // sub  x0, x0, x0
  check_trace( 'h20c, 'x, 'x,          0 ); // sub  x0, x0, x1
  check_trace( 'h210, 'x, 'x,          0 ); // sub  x0, x2, x0
  check_trace( 'h214,  3, 'hffff_ffff, 1 ); // sub  x3, x0, x1
  check_trace( 'h218,  4, 'h02,        1 ); // sub  x4, x2, x0


  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_sub_3_pos
//------------------------------------------------------------------------

task test_case_directed_sub_3_pos();
  t.test_case_begin( "test_case_directed_sub_3_pos" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0,  1"    );
  asm( 'h204, "addi x2,  x0,  2"    );
  asm( 'h208, "addi x3,  x0,  3"    );
  asm( 'h20c, "addi x4,  x0,  4"    );

  asm( 'h210, "sub  x5,  x2,  x1"   );
  asm( 'h214, "sub  x6,  x2,  x3"   );
  asm( 'h218, "sub  x7,  x4,  x1"   );

  asm( 'h21c, "addi x1,  x0,  2001" );
  asm( 'h220, "addi x2,  x0,  2002" );
  asm( 'h224, "addi x3,  x0,  2003" );
  asm( 'h228, "addi x4,  x0,  2004" );

  asm( 'h22c, "sub  x5,  x2,  x1"   );
  asm( 'h230, "sub  x6,  x2,  x3"   );
  asm( 'h234, "sub  x7,  x4,  x1"   );

  // Check each executed instruction

  check_trace( 'h200, 1,  1,   1 ); // addi x1,  x0,  1
  check_trace( 'h204, 2,  2,   1 ); // addi x2,  x0,  2
  check_trace( 'h208, 3,  3,   1 ); // addi x3,  x0,  3
  check_trace( 'h20c, 4,  4,   1 ); // addi x4,  x0,  4

  check_trace( 'h210, 5,  1,   1 ); // sub  x5,  x2,  x1
  check_trace( 'h214, 6, -1,   1 ); // sub  x6,  x2,  x3
  check_trace( 'h218, 7,  3,   1 ); // sub  x7,  x4,  x1

  check_trace( 'h21c, 1, 2001, 1 ); // addi x1,  x0,  2001
  check_trace( 'h220, 2, 2002, 1 ); // addi x2,  x0,  2002
  check_trace( 'h224, 3, 2003, 1 ); // addi x3,  x0,  2003
  check_trace( 'h228, 4, 2004, 1 ); // addi x4,  x0,  2004

  check_trace( 'h22c, 5,  1,   1 ); // sub  x5,  x2,  x1
  check_trace( 'h230, 6, -1,   1 ); // sub  x6,  x2,  x3
  check_trace( 'h234, 7,  3,   1 ); // sub  x7,  x4,  x1

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_sub_4_neg
//------------------------------------------------------------------------

task test_case_directed_sub_4_neg();
  t.test_case_begin( "test_case_directed_sub_4_neg" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0,  -1"    );
  asm( 'h204, "addi x2,  x0,  -2"    );
  asm( 'h208, "addi x3,  x0,  -3"    );
  asm( 'h20c, "addi x4,  x0,  -4"    );

  asm( 'h210, "sub  x5,  x1,  x2"    );
  asm( 'h214, "sub  x6,  x3,  x2"    );
  asm( 'h218, "sub  x7,  x4,  x1"    );

  asm( 'h21c, "addi x1,  x0,  -2001" );
  asm( 'h220, "addi x2,  x0,  -2002" );
  asm( 'h224, "addi x3,  x0,  -2003" );
  asm( 'h228, "addi x4,  x0,  -2004" );

  asm( 'h22c, "sub  x5,  x1,  x2"    );
  asm( 'h230, "sub  x6,  x3,  x2"    );
  asm( 'h234, "sub  x7,  x4,  x1"    );

  // Check each executed instruction

  check_trace( 'h200, 1, -1,    1 ); // addi x1,  x0,  -1
  check_trace( 'h204, 2, -2,    1 ); // addi x2,  x0,  -2
  check_trace( 'h208, 3, -3,    1 ); // addi x3,  x0,  -3
  check_trace( 'h20c, 4, -4,    1 ); // addi x4,  x0,  -4

  check_trace( 'h210, 5,  1,    1 ); // sub  x5,  x1,  x2
  check_trace( 'h214, 6, -1,    1 ); // sub  x6,  x3,  x2
  check_trace( 'h218, 7, -3,    1 ); // sub  x7,  x4,  x1

  check_trace( 'h21c, 1, -2001, 1 ); // addi x1,  x0,  -2001
  check_trace( 'h220, 2, -2002, 1 ); // addi x2,  x0,  -2002
  check_trace( 'h224, 3, -2003, 1 ); // addi x3,  x0,  -2003
  check_trace( 'h228, 4, -2004, 1 ); // addi x4,  x0,  -2004

  check_trace( 'h22c, 5,  1,    1 ); // sub  x5,  x1,  x2
  check_trace( 'h230, 6, -1,    1 ); // sub  x6,  x3,  x2
  check_trace( 'h234, 7, -3,    1 ); // sub  x7,  x4,  x1

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_sub_5_overflow
//------------------------------------------------------------------------

task test_case_directed_sub_5_overflow();
  t.test_case_begin( "test_case_directed_sub_5_overflow" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0,  1"  );
  asm( 'h204, "sub  x2,  x0,  x1" );

  // Check each executed instruction

  check_trace( 'h200, 1, 'h0000_0001, 1 ); // addi x1,  x0,  1
  check_trace( 'h204, 2, 'hffff_ffff, 1 ); // sub  x2,  x0,  x1

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// run_directed_add_tests
//------------------------------------------------------------------------

task run_directed_sub_tests();
  test_case_directed_sub_1_basic();
  test_case_directed_sub_2_x0();
  test_case_directed_sub_3_pos();
  test_case_directed_sub_4_neg();
  test_case_directed_sub_5_overflow();
endtask
