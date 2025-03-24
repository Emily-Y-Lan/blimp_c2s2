//========================================================================
// lui_test_cases
//========================================================================
// Adapted from Cornell's ECE 2300

//------------------------------------------------------------------------
// test_case_directed_lui_1_basic
//------------------------------------------------------------------------

task test_case_directed_lui_1_basic();
  t.test_case_begin( "test_case_directed_lui_1_basic" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "lui  x1, 0x001"  );

  // Check each executed instruction

  check_trace( 'h200, 1, 'h0000_1000, 1 ); // lui  x1, 0x001

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_lui_extreme
//------------------------------------------------------------------------

task test_case_directed_lui_2_extreme();
  t.test_case_begin( "test_case_directed_lui_2_extreme" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "lui  x0, 0x12345" );

  asm( 'h204, "lui  x1, 0x00000" );
  asm( 'h208, "lui  x2, 0xfffff" );
  asm( 'h20c, "lui  x3, 0x7ffff" );
  asm( 'h210, "lui  x4, 0x80000" );

  // Check each executed instruction

  check_trace( 'h200, 'x, 'x,   0 ); // lui  x0, 0x12345
  
  check_trace( 'h204, 1, 'h0000_0000, 1 ); // lui  x1, 0x00000
  check_trace( 'h208, 2, 'hffff_f000, 1 ); // lui  x2, 0xfffff
  check_trace( 'h20c, 3, 'h7fff_f000, 1 ); // lui  x3, 0x7ffff
  check_trace( 'h210, 4, 'h8000_0000, 1 ); // lui  x4, 0x80000

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// run_directed_lui_tests
//------------------------------------------------------------------------

task run_directed_lui_tests();
  test_case_directed_lui_1_basic();
  test_case_directed_lui_2_extreme();
endtask
