//========================================================================
// bne_test_cases.v
//========================================================================
// Adapted from Cornell's ECE 2300

//------------------------------------------------------------------------
// test_case_golden_bne_1_mix
//------------------------------------------------------------------------

task test_case_golden_bne_1_mix();
  h.t.test_case_begin( "test_case_golden_bne_1_mix" );
  if( !h.t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  h.asm( 'h200, "addi x1, x0, 0x100" );
  h.asm( 'h204, "addi x2, x0, 0x110" );
  h.asm( 'h208, "addi x3, x0, 0x120" );
  h.asm( 'h20c, "addi x4, x0, 0"     );
  h.asm( 'h210, "addi x5, x0, 3"     );

  h.asm( 'h214, "lw   x6, 0(x1)"     );
  h.asm( 'h218, "lw   x7, 0(x2)"     );
  h.asm( 'h21c, "mul  x8, x6, x7"    );
  h.asm( 'h220, "add  x4, x4, x8"    );
  h.asm( 'h224, "sw   x4, 0(x3)"     );
  h.asm( 'h228, "addi x1, x1, 4"     );
  h.asm( 'h22c, "addi x2, x2, 4"     );
  h.asm( 'h230, "addi x3, x3, 4"     );
  h.asm( 'h234, "addi x5, x5, -1"    );
  h.asm( 'h238, "bne  x5, x0, 0x014" );

  h.asm( 'h23c, "addi x1, x0, 0x120" );
  h.asm( 'h240, "lw   x2, 0(x1)"     );
  h.asm( 'h244, "lw   x3, 4(x1)"     );
  h.asm( 'h248, "lw   x4, 8(x1)"     );

  // Write h.data into memory

  h.data( 'h100, 1 );
  h.data( 'h104, 2 );
  h.data( 'h108, 3 );

  h.data( 'h110, 5 );
  h.data( 'h114, 6 );
  h.data( 'h118, 7 );

  h.data( 'h120, 0 );
  h.data( 'h124, 0 );
  h.data( 'h128, 0 );

  h.check_traces();

  h.t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_golden_bne_before_jump
//------------------------------------------------------------------------

task test_case_golden_bne_before_jump();
  h.t.test_case_begin( "test_case_golden_bne_before_jump" );
  if( !h.t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  h.asm( 'h200, "addi x1, x0, 1"     );
  h.asm( 'h204, "bne  x1, x0, 0x214" );
  h.asm( 'h208, "jal  x0, 0x210"     );
  h.asm( 'h20c, "addi x2, x0, 2"     );
  h.asm( 'h210, "addi x3, x0, 3"     );

  h.asm( 'h214, "bne  x0, x0, 0x21c" );
  h.asm( 'h218, "jal  x0, 0x220"     );
  h.asm( 'h21c, "addi x4, x0, 4"     );
  h.asm( 'h220, "addi x5, x0, 5"     );

  h.check_traces();

  h.t.test_case_end();
endtask

//------------------------------------------------------------------------
// run_golden_bne_tests
//------------------------------------------------------------------------

task run_golden_bne_tests();
  test_case_golden_bne_1_mix();
  test_case_golden_bne_before_jump();
endtask
