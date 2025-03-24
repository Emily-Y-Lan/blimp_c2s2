//========================================================================
// auipc_test_cases
//========================================================================
// Adapted from Cornell's ECE 2300

//------------------------------------------------------------------------
// test_case_directed_auipc_1_basic
//------------------------------------------------------------------------

task test_case_directed_auipc_1_basic();
  t.test_case_begin( "test_case_directed_auipc_1_basic" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "auipc x1, 0x001"  );

  // Check each executed instruction

  check_trace( 'h200, 1, 'h0000_1200, 1 ); // auipc  x1, 0x001

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_auipc_extreme
//------------------------------------------------------------------------

task test_case_directed_auipc_2_extreme();
  t.test_case_begin( "test_case_directed_auipc_2_extreme" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "auipc  x0, 0x12345" );

  asm( 'h204, "auipc  x1, 0x00000" );
  asm( 'h208, "auipc  x2, 0xfffff" );
  asm( 'h20c, "auipc  x3, 0x7ffff" );
  asm( 'h210, "auipc  x4, 0x80000" );

  // Check each executed instruction

  check_trace( 'h200, 'x, 'x,   0 ); // auipc  x0, 0x12345
  
  check_trace( 'h204, 1, 'h0000_0204, 1 ); // auipc  x1, 0x00000
  check_trace( 'h208, 2, 'hffff_f208, 1 ); // auipc  x2, 0xfffff
  check_trace( 'h20c, 3, 'h7fff_f20c, 1 ); // auipc  x3, 0x7ffff
  check_trace( 'h210, 4, 'h8000_0210, 1 ); // auipc  x4, 0x80000

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// run_directed_auipc_tests
//------------------------------------------------------------------------

task run_directed_auipc_tests();
  test_case_directed_auipc_1_basic();
  test_case_directed_auipc_2_extreme();
endtask
