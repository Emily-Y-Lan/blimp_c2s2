//========================================================================
// bne_test_cases.v
//========================================================================
// Adapted from Cornell's ECE 2300

//------------------------------------------------------------------------
// test_case_golden_bne_1_mix
//------------------------------------------------------------------------

task test_case_golden_bne_1_mix();
  t.test_case_begin( "test_case_golden_bne_1_mix" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1, x0, 0x100" );
  asm( 'h204, "addi x2, x0, 0x110" );
  asm( 'h208, "addi x3, x0, 0x120" );
  asm( 'h20c, "addi x4, x0, 0"     );
  asm( 'h210, "addi x5, x0, 3"     );

  asm( 'h214, "lw   x6, 0(x1)"     );
  asm( 'h218, "lw   x7, 0(x2)"     );
  asm( 'h21c, "mul  x8, x6, x7"    );
  asm( 'h220, "add  x4, x4, x8"    );
  asm( 'h224, "sw   x4, 0(x3)"     );
  asm( 'h228, "addi x1, x1, 4"     );
  asm( 'h22c, "addi x2, x2, 4"     );
  asm( 'h230, "addi x3, x3, 4"     );
  asm( 'h234, "addi x5, x5, -1"    );
  asm( 'h238, "bne  x5, x0, 0x014" );

  asm( 'h23c, "addi x1, x0, 0x120" );
  asm( 'h240, "lw   x2, 0(x1)"     );
  asm( 'h244, "lw   x3, 4(x1)"     );
  asm( 'h248, "lw   x4, 8(x1)"     );

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
// test_case_golden_bne_before_jump
//------------------------------------------------------------------------

task test_case_golden_bne_before_jump();
  t.test_case_begin( "test_case_golden_bne_before_jump" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1, x0, 1"     );
  asm( 'h204, "bne  x1, x0, 0x214" );
  asm( 'h208, "jal  x0, 0x210"     );
  asm( 'h20c, "addi x2, x0, 2"     );
  asm( 'h210, "addi x3, x0, 3"     );

  asm( 'h214, "bne  x0, x0, 0x21c" );
  asm( 'h218, "jal  x0, 0x220"     );
  asm( 'h21c, "addi x4, x0, 4"     );
  asm( 'h220, "addi x5, x0, 5"     );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// run_golden_bne_tests
//------------------------------------------------------------------------

task run_golden_bne_tests();
  test_case_golden_bne_1_mix();
  test_case_golden_bne_before_jump();
endtask
