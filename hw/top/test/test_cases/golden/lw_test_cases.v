//========================================================================
// lw_test_cases.v
//========================================================================
// Adapted from Cornell's ECE 2300

//------------------------------------------------------------------------
// test_case_golden_lw_1_regs
//------------------------------------------------------------------------

task test_case_golden_lw_1_regs();
  t.test_case_begin( "test_case_golden_lw_1_regs" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0, 0x100" );
  asm( 'h004, "addi x2,  x0, 0x104" );
  asm( 'h008, "addi x3,  x0, 0x108" );
  asm( 'h00c, "addi x4,  x0, 0x10c" );

  asm( 'h010, "addi x28, x0, 0x110" );
  asm( 'h014, "addi x29, x0, 0x114" );
  asm( 'h018, "addi x30, x0, 0x118" );
  asm( 'h01c, "addi x31, x0, 0x11c" );

  asm( 'h020, "lw   x5, 0(x1)"     );
  asm( 'h024, "lw   x6, 0(x2)"     );
  asm( 'h028, "lw   x7, 0(x3)"     );
  asm( 'h02c, "lw   x8, 0(x4)"     );

  asm( 'h030, "lw   x5, 0(x28)"    );
  asm( 'h034, "lw   x6, 0(x29)"    );
  asm( 'h038, "lw   x7, 0(x30)"    );
  asm( 'h03c, "lw   x8, 0(x31)"    );

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
// test_case_golden_lw_2_deps
//------------------------------------------------------------------------

task test_case_golden_lw_2_deps();
  t.test_case_begin( "test_case_golden_lw_2_deps" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0, 0x100" );
  asm( 'h004, "lw   x2,  0(x1)"     );
  asm( 'h008, "addi x3,  x2, 1"     );

  asm( 'h00c, "addi x1,  x0, 0x104" );
  asm( 'h010, "lw   x2,  0(x1)"     );
  asm( 'h014, "lw   x3,  0(x2)"     );
  asm( 'h018, "lw   x4,  0(x3)"     );
  asm( 'h01c, "addi x5,  x4, 1"     );

  // Write data into memory

  data( 'h100, 'h0000_2000 );
  data( 'h104, 'h0000_0108 );
  data( 'h108, 'h0000_010c );
  data( 'h10c, 'h0000_3000 );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_golden_lw_3_mix
//------------------------------------------------------------------------

task test_case_golden_lw_3_mix();
  t.test_case_begin( "test_case_golden_lw_3_mix" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0, 0x100" );
  asm( 'h004, "addi x2,  x0, 0x110" );
  asm( 'h008, "addi x3,  x0, 0"     );

  asm( 'h00c, "lw   x4,  0(x1)"     );
  asm( 'h010, "lw   x5,  0(x2)"     );
  asm( 'h014, "mul  x6,  x4, x5"    );
  asm( 'h018, "add  x3,  x3, x6"    );
  asm( 'h01c, "addi x1,  x1, 4"     );
  asm( 'h020, "addi x2,  x2, 4"     );

  asm( 'h024, "lw   x4,  0(x1)"     );
  asm( 'h028, "lw   x5,  0(x2)"     );
  asm( 'h02c, "mul  x6,  x4, x5"    );
  asm( 'h030, "add  x3,  x3, x6"    );
  asm( 'h034, "addi x1,  x1, 4"     );
  asm( 'h038, "addi x2,  x2, 4"     );

  asm( 'h03c, "lw   x4,  0(x1)"     );
  asm( 'h040, "lw   x5,  0(x2)"     );
  asm( 'h044, "mul  x6,  x4, x5"    );
  asm( 'h048, "add  x3,  x3, x6"    );
  asm( 'h04c, "addi x1,  x1, 4"     );
  asm( 'h050, "addi x2,  x2, 4"     );

  // Write data into memory

  data( 'h100, 1 );
  data( 'h104, 2 );
  data( 'h108, 3 );

  data( 'h110, 5 );
  data( 'h114, 6 );
  data( 'h118, 7 );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// run_golden_lw_tests
//------------------------------------------------------------------------

task run_golden_lw_tests();
  test_case_golden_lw_1_regs();
  test_case_golden_lw_2_deps();
  test_case_golden_lw_3_mix();
endtask
