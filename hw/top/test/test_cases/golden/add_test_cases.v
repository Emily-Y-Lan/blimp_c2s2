//========================================================================
// add_test_cases
//========================================================================
// Adapted from Cornell's ECE 2300

//------------------------------------------------------------------------
// test_case_golden_add_1_regs
//------------------------------------------------------------------------

task test_case_golden_add_1_regs();
  t.test_case_begin( "test_case_golden_add_1_regs" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0,  0x01" );
  asm( 'h204, "addi x2,  x0,  0x02" );
  asm( 'h208, "addi x3,  x0,  0x03" );
  asm( 'h20c, "addi x4,  x0,  0x04" );

  asm( 'h210, "add  x1,  x2,  x3"   );
  asm( 'h214, "add  x2,  x3,  x4"   );
  asm( 'h218, "add  x3,  x4,  x1"   );
  asm( 'h21c, "add  x4,  x1,  x2"   );

  asm( 'h220, "addi x28, x0,  0x24" );
  asm( 'h224, "addi x29, x0,  0x25" );
  asm( 'h228, "addi x30, x0,  0x26" );
  asm( 'h22c, "addi x31, x0,  0x27" );

  asm( 'h230, "add  x28, x29, x30"  );
  asm( 'h234, "add  x29, x30, x31"  );
  asm( 'h238, "add  x30, x31, x28"  );
  asm( 'h23c, "add  x31, x28, x29"  );

  asm( 'h240, "add  x1,  x2,  x2"   );
  asm( 'h244, "add  x2,  x2,  x3"   );
  asm( 'h248, "add  x3,  x3,  x3"   );

  asm( 'h24c, "addi x1,  x1,  0"    );
  asm( 'h250, "addi x2,  x2,  0"    );
  asm( 'h254, "addi x3,  x3,  0"    );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_golden_add_2_deps
//------------------------------------------------------------------------

task test_case_golden_add_2_deps();
  t.test_case_begin( "test_case_golden_add_2_deps" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0,  0x01"   );
  asm( 'h204, "addi x2,  x0,  0x02"   );
  asm( 'h208, "add  x3,  x1,  x2"     );
  asm( 'h20c, "add  x4,  x3,  x1"     );
  asm( 'h210, "add  x5,  x4,  x1"     );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// run_add_tests
//------------------------------------------------------------------------

task run_golden_add_tests();
  test_case_golden_add_1_regs();
  test_case_golden_add_2_deps();
endtask
