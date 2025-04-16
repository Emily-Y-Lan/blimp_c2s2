//========================================================================
// lh_test_cases.v
//========================================================================

//------------------------------------------------------------------------
// test_case_directed_lh_1_basic
//------------------------------------------------------------------------

task test_case_directed_lh_1_basic();
  h.t.test_case_begin( "test_case_directed_lh_1_basic" );
  if( !h.t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  h.asm( 'h200, "addi x1, x0, 0x100" );
  h.asm( 'h204, "lh   x2, 0(x1)"     );
  h.asm( 'h208, "lh   x3, 2(x1)"     );

  // Write h.data into memory

  h.data( 'h100, 'hdead_beef );

  // Check each executed instruction

  h.check_trace( 'h200, 1, 'h0000_0100, 1 ); // addi x1, x0, 0x100
  h.check_trace( 'h204, 2, 'hffff_beef, 1 ); // lh   x2, 0(x1)
  h.check_trace( 'h208, 3, 'hffff_dead, 1 ); // lh   x3, 2(x1)

  h.t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_lh_2_x0
//------------------------------------------------------------------------

task test_case_directed_lh_2_x0();
  h.t.test_case_begin( "test_case_directed_lh_2_x0" );
  if( !h.t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  h.asm( 'h200, "addi x1, x0, 0x100" );
  h.asm( 'h204, "lh   x0, 0(x1)"     );
  h.asm( 'h208, "lh   x0, 0(x0)"     );

  // Write h.data into memory

  h.data( 'h100, 'hdead_beef );

  // Check each executed instruction

  h.check_trace( 'h200, 1,  'h0000_0100, 1 ); // addi x1, x0, 0x100
  h.check_trace( 'h204, 'x, 'x,          0 ); // lh   x0, 0(x1)
  h.check_trace( 'h208, 'x, 'x,          0 ); // lh   x0, 0(x0)

  h.t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_lh_3_offset_pos
//------------------------------------------------------------------------

task test_case_directed_lh_3_offset_pos();
  h.t.test_case_begin( "test_case_directed_lh_3_offset_pos" );
  if( !h.t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  h.asm( 'h200, "addi x1,  x0, 0x100" );
  h.asm( 'h204, "lh   x2,  0(x1)"     );
  h.asm( 'h208, "lh   x3,  4(x1)"     );
  h.asm( 'h20c, "lh   x4,  8(x1)"     );
  h.asm( 'h210, "lh   x5,  12(x1)"    );

  // Write h.data into memory

  h.data( 'h100, 'h0000_2000 );
  h.data( 'h104, 'hffff_2004 );
  h.data( 'h108, 'h0000_2008 );
  h.data( 'h10c, 'hffff_200c );

  // Check each executed instruction

  h.check_trace( 'h200, 1, 'h0000_0100, 1 ); // addi x1, x0, 0x100
  h.check_trace( 'h204, 2, 'h0000_2000, 1 ); // lh   x2, 0(x1)
  h.check_trace( 'h208, 3, 'h0000_2004, 1 ); // lh   x3, 4(x1)
  h.check_trace( 'h20c, 4, 'h0000_2008, 1 ); // lh   x4, 8(x1)
  h.check_trace( 'h210, 5, 'h0000_200c, 1 ); // lh   x5, 12(x1)

  h.t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_lh_4_offset_neg
//------------------------------------------------------------------------

task test_case_directed_lh_4_offset_neg();
  h.t.test_case_begin( "test_case_directed_lh_4_offset_neg" );
  if( !h.t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  h.asm( 'h200, "addi x1,  x0, 0x10c" );
  h.asm( 'h204, "lh   x2,  0(x1)"     );
  h.asm( 'h208, "lh   x3,  -4(x1)"    );
  h.asm( 'h20c, "lh   x4,  -8(x1)"    );
  h.asm( 'h210, "lh   x5,  -12(x1)"   );

  // Write h.data into memory

  h.data( 'h100, 'h1111_2000 );
  h.data( 'h104, 'h2222_2004 );
  h.data( 'h108, 'h3333_2008 );
  h.data( 'h10c, 'h4444_200c );

  // Check each executed instruction

  h.check_trace( 'h200, 1, 'h0000_010c, 1 ); // addi x1, x0, 0x100
  h.check_trace( 'h204, 2, 'h0000_200c, 1 ); // lh   x2, 0(x1)
  h.check_trace( 'h208, 3, 'h0000_2008, 1 ); // lh   x3, -4(x1)
  h.check_trace( 'h20c, 4, 'h0000_2004, 1 ); // lh   x4, -8(x1)
  h.check_trace( 'h210, 5, 'h0000_2000, 1 ); // lh   x5, -12(x1)

  h.t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_lh_5_sext
//------------------------------------------------------------------------

task test_case_directed_lh_5_sext();
  h.t.test_case_begin( "test_case_directed_lh_5_sext" );
  if( !h.t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  h.asm( 'h200, "addi x1,  x0, 0x10c" );
  h.asm( 'h204, "lh   x2,  -2(x1)"    );
  h.asm( 'h208, "lh   x3,  -4(x1)"    );

  // Write h.data into memory

  h.data( 'h108, 'h0fff_8000 );

  // Check each executed instruction

  h.check_trace( 'h200, 1, 'h0000_010c, 1 ); // addi x1, x0, 0x100
  h.check_trace( 'h204, 2, 'h0000_0fff, 1 ); // lh   x2, -2(x1)
  h.check_trace( 'h208, 3, 'hffff_8000, 1 ); // lh   x3, -4(x1)

  h.t.test_case_end();
endtask

//------------------------------------------------------------------------
// run_directed_lh_tests
//------------------------------------------------------------------------

task run_directed_lh_tests();
  test_case_directed_lh_1_basic();
  test_case_directed_lh_2_x0();
  test_case_directed_lh_3_offset_pos();
  test_case_directed_lh_4_offset_neg();
  test_case_directed_lh_5_sext();
endtask
