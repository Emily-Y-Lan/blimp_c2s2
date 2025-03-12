//========================================================================
// sw_test_cases.v
//========================================================================
// Adapted from Cornell's ECE 2300

//------------------------------------------------------------------------
// test_case_golden_sw_1_regs
//------------------------------------------------------------------------

task test_case_golden_sw_1_regs();
  t.test_case_begin( "test_case_golden_sw_1_regs" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0, 0x100" );
  asm( 'h204, "addi x2,  x0, 0x104" );
  asm( 'h208, "addi x3,  x0, 0x108" );
  asm( 'h20c, "addi x4,  x0, 0x10c" );

  asm( 'h210, "addi x5,  x0, 10" );
  asm( 'h214, "addi x6,  x0, 11" );
  asm( 'h218, "addi x7,  x0, 12" );
  asm( 'h21c, "addi x8,  x0, 13" );

  asm( 'h220, "sw   x5, 0(x1)"     );
  asm( 'h224, "sw   x6, 0(x2)"     );
  asm( 'h228, "sw   x7, 0(x3)"     );
  asm( 'h22c, "sw   x8, 0(x4)"     );

  asm( 'h230, "lw   x5, 0(x1)"     );
  asm( 'h234, "lw   x6, 0(x2)"     );
  asm( 'h238, "lw   x7, 0(x3)"     );
  asm( 'h23c, "lw   x8, 0(x4)"     );

  asm( 'h240, "addi x28, x0, 0x110" );
  asm( 'h244, "addi x29, x0, 0x114" );
  asm( 'h248, "addi x30, x0, 0x118" );
  asm( 'h24c, "addi x31, x0, 0x11c" );

  asm( 'h250, "addi x5,  x0, 14" );
  asm( 'h254, "addi x6,  x0, 15" );
  asm( 'h258, "addi x7,  x0, 16" );
  asm( 'h25c, "addi x8,  x0, 17" );

  asm( 'h260, "sw   x5, 0(x28)"    );
  asm( 'h264, "sw   x6, 0(x29)"    );
  asm( 'h268, "sw   x7, 0(x30)"    );
  asm( 'h26c, "sw   x8, 0(x31)"    );

  asm( 'h270, "lw   x5, 0(x28)"    );
  asm( 'h274, "lw   x6, 0(x29)"    );
  asm( 'h278, "lw   x7, 0(x30)"    );
  asm( 'h27c, "lw   x8, 0(x31)"    );

  // Write data into memory

  data( 'h100, 'h0101_0101 );
  data( 'h104, 'h0202_0202 );
  data( 'h108, 'h0303_0303 );
  data( 'h10c, 'h0404_0404 );

  data( 'h110, 'h0505_0505 );
  data( 'h114, 'h0606_0606 );
  data( 'h118, 'h0707_0707 );
  data( 'h11c, 'h0808_0808 );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_golden_sw_2_mix
//------------------------------------------------------------------------

task test_case_golden_sw_2_mix();
  t.test_case_begin( "test_case_golden_sw_2_mix" );
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

  asm( 'h230, "lw   x5,  0(x1)"     );
  asm( 'h234, "lw   x6,  0(x2)"     );
  asm( 'h238, "mul  x7,  x5, x6"    );
  asm( 'h23c, "add  x4,  x4, x7"    );
  asm( 'h240, "sw   x4,  0(x3)"     );
  asm( 'h244, "addi x1,  x1, 4"     );
  asm( 'h248, "addi x2,  x2, 4"     );
  asm( 'h24c, "addi x3,  x3, 4"     );

  asm( 'h250, "lw   x5,  0(x1)"     );
  asm( 'h254, "lw   x6,  0(x2)"     );
  asm( 'h258, "mul  x7,  x5, x6"    );
  asm( 'h25c, "add  x4,  x4, x7"    );
  asm( 'h260, "sw   x4,  0(x3)"     );
  asm( 'h264, "addi x1,  x1, 4"     );
  asm( 'h268, "addi x2,  x2, 4"     );
  asm( 'h26c, "addi x3,  x3, 4"     );

  asm( 'h270, "addi x1,  x0, 0x120" );
  asm( 'h274, "lw   x2,  0(x1)"     );
  asm( 'h278, "lw   x3,  4(x1)"     );
  asm( 'h27c, "lw   x4,  8(x1)"     );

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
// run_golden_sw_tests
//------------------------------------------------------------------------

task run_golden_sw_tests();
  test_case_golden_sw_1_regs();
  test_case_golden_sw_2_mix();
endtask
