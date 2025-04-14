//========================================================================
// srli_test_cases
//========================================================================

//------------------------------------------------------------------------
// test_case_directed_srli_1_basic
//------------------------------------------------------------------------

task test_case_directed_srli_1_basic();
  h.t.test_case_begin( "test_case_directed_srli_1_basic" );
  if( !h.t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  h.asm( 'h200, "addi x1, x0, 7"  );
  h.asm( 'h204, "srli x2, x1, 1" );

  // Check each executed instruction

  h.check_trace( 'h200, 1, 'h0000_0007, 1 ); // addi x1, x0, 7
  h.check_trace( 'h204, 2, 'h0000_0003, 1 ); // srli x2, x1, 1

  h.t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_srli_2_x0
//------------------------------------------------------------------------

task test_case_directed_srli_2_x0();
  h.t.test_case_begin( "test_case_directed_srli_2_x0" );
  if( !h.t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  h.asm( 'h200, "addi x2, x0, 2" );
  h.asm( 'h204, "srli x0, x0, 0" );
  h.asm( 'h208, "srli x0, x0, 1" );
  h.asm( 'h20c, "srli x0, x2, 0" );
  h.asm( 'h210, "srli x3, x0, 1" );
  h.asm( 'h214, "srli x4, x2, 0" );

  // Check each executed instruction

  h.check_trace( 'h200,  2, 'h02, 1 ); // addi x2, x0, 2
  h.check_trace( 'h204, 'x, 'x,   0 ); // srli x0, x0, 0
  h.check_trace( 'h208, 'x, 'x,   0 ); // srli x0, x0, 1
  h.check_trace( 'h20c, 'x, 'x,   0 ); // srli x0, x2, 0
  h.check_trace( 'h210,  3, 'h00, 1 ); // srli x3, x0, 1
  h.check_trace( 'h214,  4, 'h02, 1 ); // srli x4, x2, 0


  h.t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_srli_3_upper
//------------------------------------------------------------------------

task test_case_directed_srli_3_upper();
  h.t.test_case_begin( "test_case_directed_srli_3_upper" );
  if( !h.t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  h.asm( 'h200, "addi x1,  x0,  0xfff" );
  h.asm( 'h204, "addi x2,  x0,  0xae0" );
  h.asm( 'h208, "addi x3,  x0,  0x00a" );

  h.asm( 'h20c, "srli  x5,  x3,  0x1f" );
  h.asm( 'h210, "srli  x6,  x3,  0x00" );
  h.asm( 'h214, "srli  x7,  x3,  0x0a" );
  h.asm( 'h218, "srli  x8,  x1,  0x1f" );
  h.asm( 'h21c, "srli  x9,  x3,  0x02" );
  h.asm( 'h220, "srli  x10, x2,  0x02" );

  // Check each executed instruction

  h.check_trace( 'h200, 1, 'hffff_ffff, 1 ); // addi x1,  x0,  0xfff
  h.check_trace( 'h204, 2, 'hffff_fae0, 1 ); // addi x2,  x0,  0xae0
  h.check_trace( 'h208, 3, 'h0000_000a, 1 ); // addi x3,  x0,  0x00a

  h.check_trace( 'h20c, 5,  'h0000_0000, 1 ); // srli  x5,  x3,  0x1f
  h.check_trace( 'h210, 6,  'h0000_000a, 1 ); // srli  x6,  x3,  0x00
  h.check_trace( 'h214, 7,  'h0000_0000, 1 ); // srli  x7,  x3,  0x0a
  h.check_trace( 'h218, 8,  'h0000_0001, 1 ); // srli  x8,  x1,  0x1f
  h.check_trace( 'h21c, 9,  'h0000_0002, 1 ); // srli  x9,  x3,  0x02
  h.check_trace( 'h220, 10, 'h3fff_feb8, 1 ); // srli  x10, x2,  0x02

  h.t.test_case_end();
endtask

//------------------------------------------------------------------------
// run_directed_srli_tests
//------------------------------------------------------------------------

task run_directed_srli_tests();
  test_case_directed_srli_1_basic();
  test_case_directed_srli_2_x0();
  test_case_directed_srli_3_upper();
endtask
