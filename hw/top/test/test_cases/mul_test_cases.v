//========================================================================
// Proc-mul-test-cases
//========================================================================
// Adapted from Cornell's ECE 2300

//------------------------------------------------------------------------
// test_case_mul_1_basic
//------------------------------------------------------------------------

task test_case_mul_1_basic();
  t.test_case_begin( "test_case_mul_1_basic" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1, x0, 2"  );
  asm( 'h204, "addi x2, x0, 3"  );
  asm( 'h208, "mul  x3, x1, x2" );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_mul_2_x0
//------------------------------------------------------------------------

task test_case_mul_2_x0();
  t.test_case_begin( "test_case_mul_2_x0" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1, x0, 1"  );
  asm( 'h204, "addi x2, x0, 2"  );
  asm( 'h208, "mul  x0, x0, x0" );
  asm( 'h20c, "mul  x0, x0, x1" );
  asm( 'h210, "mul  x0, x2, x0" );
  asm( 'h214, "mul  x3, x0, x1" );
  asm( 'h218, "mul  x4, x2, x0" );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_mul_3_regs
//------------------------------------------------------------------------

task test_case_mul_3_regs();
  t.test_case_begin( "test_case_mul_3_regs" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0,  0x01" );
  asm( 'h204, "addi x2,  x0,  0x02" );
  asm( 'h208, "addi x3,  x0,  0x03" );
  asm( 'h20c, "addi x4,  x0,  0x04" );

  asm( 'h210, "mul  x1,  x2,  x3"   );
  asm( 'h214, "mul  x2,  x3,  x4"   );
  asm( 'h218, "mul  x3,  x4,  x1"   );
  asm( 'h21c, "mul  x4,  x1,  x2"   );

  asm( 'h220, "addi x28, x0,  0x24" );
  asm( 'h224, "addi x29, x0,  0x25" );
  asm( 'h228, "addi x30, x0,  0x26" );
  asm( 'h22c, "addi x31, x0,  0x27" );

  asm( 'h230, "mul  x28, x29, x30"  );
  asm( 'h234, "mul  x29, x30, x31"  );
  asm( 'h238, "mul  x30, x31, x28"  );
  asm( 'h23c, "mul  x31, x28, x29"  );

  asm( 'h240, "mul  x1,  x2,  x2"   );
  asm( 'h244, "mul  x2,  x2,  x3"   );
  asm( 'h248, "mul  x3,  x3,  x3"   );

  asm( 'h24c, "addi x1,  x1,  0"    );
  asm( 'h250, "addi x2,  x2,  0"    );
  asm( 'h254, "addi x3,  x3,  0"    );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_mul_4_deps
//------------------------------------------------------------------------

task test_case_mul_4_deps();
  t.test_case_begin( "test_case_mul_4_deps" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0,  0x02"   );
  asm( 'h204, "addi x2,  x0,  0x03"   );
  asm( 'h208, "mul  x3,  x1,  x2"     );
  asm( 'h20c, "mul  x4,  x3,  x1"     );
  asm( 'h210, "mul  x5,  x4,  x1"     );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_mul_5_pos
//------------------------------------------------------------------------

task test_case_mul_5_pos();
  t.test_case_begin( "test_case_mul_5_pos" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0,  1"    );
  asm( 'h204, "addi x2,  x0,  2"    );
  asm( 'h208, "addi x3,  x0,  3"    );
  asm( 'h20c, "addi x4,  x0,  4"    );

  asm( 'h210, "mul  x5,  x1,  x2"   );
  asm( 'h214, "mul  x6,  x2,  x3"   );
  asm( 'h218, "mul  x7,  x3,  x4"   );

  asm( 'h21c, "addi x1,  x0,  2001" );
  asm( 'h220, "addi x2,  x0,  2002" );
  asm( 'h224, "addi x3,  x0,  2003" );
  asm( 'h228, "addi x4,  x0,  2004" );

  asm( 'h22c, "mul  x5,  x1,  x2"   );
  asm( 'h230, "mul  x6,  x2,  x3"   );
  asm( 'h234, "mul  x7,  x3,  x4"   );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_mul_6_neg
//------------------------------------------------------------------------

task test_case_mul_6_neg();
  t.test_case_begin( "test_case_mul_6_neg" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0,  -1"    );
  asm( 'h204, "addi x2,  x0,   2"    );
  asm( 'h208, "addi x3,  x0,  -3"    );
  asm( 'h20c, "addi x4,  x0,  -4"    );

  asm( 'h210, "mul  x5,  x1,  x2"    );
  asm( 'h214, "mul  x6,  x2,  x3"    );
  asm( 'h218, "mul  x7,  x3,  x4"    );

  asm( 'h21c, "addi x1,  x0,  -2001" );
  asm( 'h220, "addi x2,  x0,   2002" );
  asm( 'h224, "addi x3,  x0,  -2003" );
  asm( 'h228, "addi x4,  x0,  -2004" );

  asm( 'h22c, "mul  x5,  x1,  x2"    );
  asm( 'h230, "mul  x6,  x2,  x3"    );
  asm( 'h234, "mul  x7,  x3,  x4"    );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_mul_7_overflow
//------------------------------------------------------------------------

task test_case_mul_7_overflow();
  t.test_case_begin( "test_case_mul_7_overflow" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0,  0xfff" );
  asm( 'h204, "addi x2,  x0,  2"     );
  asm( 'h208, "mul  x3,  x1,  x2"    );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_mul_8_mix
//------------------------------------------------------------------------

task test_case_mul_8_mix();
  t.test_case_begin( "test_case_mul_8_mix" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x3,  x0, 0"     );

  asm( 'h204, "addi x4,  x0, 1"     );
  asm( 'h208, "addi x5,  x0, 5"     );
  asm( 'h20c, "mul  x6,  x4, x5"    );
  asm( 'h210, "add  x3,  x3, x6"    );

  asm( 'h214, "addi x4,  x0, 2"     );
  asm( 'h218, "addi x5,  x0, 6"     );
  asm( 'h21c, "mul  x6,  x4, x5"    );
  asm( 'h220, "add  x3,  x3, x6"    );

  asm( 'h224, "addi x4,  x0, 3"     );
  asm( 'h228, "addi x5,  x0, 7"     );
  asm( 'h22c, "mul  x6,  x4, x5"    );
  asm( 'h230, "add  x3,  x3, x6"    );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// run_mul_tests
//------------------------------------------------------------------------

task run_mul_tests();
  test_case_mul_1_basic();
  test_case_mul_2_x0();
  test_case_mul_3_regs();
  test_case_mul_4_deps();
  test_case_mul_5_pos();
  test_case_mul_6_neg();
  test_case_mul_7_overflow();
  test_case_mul_8_mix();
endtask
