//========================================================================
// jal_test_cases.v
//========================================================================
// Adapted from Cornell's ECE 2300

//------------------------------------------------------------------------
// test_case_golden_jal_1_regs
//------------------------------------------------------------------------

task test_case_golden_jal_1_regs();
  t.test_case_begin( "test_case_golden_jal_1_regs" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "jal  x1, 0x208"   );
  asm( 'h204, "addi x2, x0, 1"   );
  asm( 'h208, "addi x3, x0, 2"   );

  asm( 'h20c, "jal  x2, 0x214"   );
  asm( 'h210, "addi x3, x0, 3"   );
  asm( 'h214, "addi x4, x0, 4"   );

  asm( 'h218, "jal  x3, 0x220"   );
  asm( 'h21c, "addi x4, x0, 5"   );
  asm( 'h220, "addi x5, x0, 6"   );

  asm( 'h224, "jal  x4, 0x22c"   );
  asm( 'h228, "addi x5, x0, 7"   );
  asm( 'h22c, "addi x6, x0, 8"   );

  asm( 'h230, "jal  x31, 0x238"   );
  asm( 'h234, "addi x30, x0, 9"   );
  asm( 'h238, "addi x29, x0, 10"  );

  asm( 'h23c, "jal  x30, 0x244"   );
  asm( 'h240, "addi x29, x0, 11"  );
  asm( 'h244, "addi x28, x0, 12"  );

  asm( 'h248, "jal  x29, 0x250"   );
  asm( 'h24c, "addi x28, x0, 13"  );
  asm( 'h250, "addi x27, x0, 14"  );

  asm( 'h254, "jal  x28, 0x25c"   );
  asm( 'h258, "addi x27, x0, 15"  );
  asm( 'h25c, "addi x26, x0, 16"  );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_golden_jal_2_deps
//------------------------------------------------------------------------

task test_case_golden_jal_2_deps();
  t.test_case_begin( "test_case_golden_jal_2_deps" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "jal  x2, 0x208" );
  asm( 'h204, "addi x1, x0, 2" );
  asm( 'h208, "addi x1, x2, 3" );

  asm( 'h20c, "jal  x3, 0x214" );
  asm( 'h210, "addi x1, x0, 2" );
  asm( 'h214, "addi x1, x3, 7" );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_golden_jal_3_mix
//------------------------------------------------------------------------

task test_case_10_mix();
  t.test_case_begin( "test_case_golden_jal_3_mix" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0, 0x100" );
  asm( 'h204, "addi x2,  x0, 0x110" );
  asm( 'h208, "addi x3,  x0, 0x120" );
  asm( 'h20c, "addi x4,  x0, 0"     );

  asm( 'h210, "lw   x5,  0(x1)"     );
  asm( 'h214, "lw   x6,  0(x2)"     );
  asm( 'h218, "mul  x7,  x5, x6"    );
  asm( 'h21c, "add  x4,  x4, x7"    );
  asm( 'h220, "sw   x4,  0(x3)"     );
  asm( 'h224, "addi x1,  x1, 4"     );
  asm( 'h228, "addi x2,  x2, 4"     );
  asm( 'h22c, "addi x3,  x3, 4"     );
  asm( 'h230, "jal  x0,  0x210"     );

  // Write data into memory

  data( 'h100, 1 );
  data( 'h104, 2 );
  data( 'h108, 3 );

  data( 'h110, 5 );
  data( 'h114, 6 );
  data( 'h118, 7 );

  data( 'h120, 0 );
  data( 'h124, 0 );
  data( 'h128, 0 );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// run_golden_jal_tests
//------------------------------------------------------------------------

task run_golden_jal_tests();
  test_case_golden_jal_1_regs();
  test_case_golden_jal_2_deps();
  test_case_golden_jal_3_mix();
endtask
