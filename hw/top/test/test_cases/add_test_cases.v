//========================================================================
// add_test_cases
//========================================================================
// Adapted from Cornell's ECE 2300

//------------------------------------------------------------------------
// test_case_add_1_basic
//------------------------------------------------------------------------

task test_case_add_1_basic();
  t.test_case_begin( "test_case_add_1_basic" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1, x0, 2"  );
  asm( 'h204, "addi x2, x0, 3"  );
  asm( 'h208, "add  x3, x1, x2" );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_add_2_x0
//------------------------------------------------------------------------

task test_case_add_2_x0();
  t.test_case_begin( "test_case_add_2_x0" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1, x0, 1"  );
  asm( 'h204, "addi x2, x0, 2"  );
  asm( 'h208, "add  x0, x0, x0" );
  asm( 'h20c, "add  x0, x0, x1" );
  asm( 'h210, "add  x0, x2, x0" );
  asm( 'h214, "add  x3, x0, x1" );
  asm( 'h218, "add  x4, x2, x0" );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_add_3_regs
//------------------------------------------------------------------------

task test_case_add_3_regs();
  t.test_case_begin( "test_case_add_3_regs" );
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
// test_case_add_4_deps
//------------------------------------------------------------------------

task test_case_add_4_deps();
  t.test_case_begin( "test_case_add_4_deps" );
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
// test_case_add_5_pos
//------------------------------------------------------------------------

task test_case_add_5_pos();
  t.test_case_begin( "test_case_add_5_pos" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0,  1"    );
  asm( 'h204, "addi x2,  x0,  2"    );
  asm( 'h208, "addi x3,  x0,  3"    );
  asm( 'h20c, "addi x4,  x0,  4"    );

  asm( 'h210, "add  x5,  x1,  x2"   );
  asm( 'h214, "add  x6,  x2,  x3"   );
  asm( 'h218, "add  x7,  x3,  x4"   );

  asm( 'h21c, "addi x1,  x0,  2001" );
  asm( 'h220, "addi x2,  x0,  2002" );
  asm( 'h224, "addi x3,  x0,  2003" );
  asm( 'h228, "addi x4,  x0,  2004" );

  asm( 'h22c, "add  x5,  x1,  x2"   );
  asm( 'h230, "add  x6,  x2,  x3"   );
  asm( 'h234, "add  x7,  x3,  x4"   );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_add_6_neg
//------------------------------------------------------------------------

task test_case_add_6_neg();
  t.test_case_begin( "test_case_add_6_neg" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0,  -1"    );
  asm( 'h204, "addi x2,  x0,  -2"    );
  asm( 'h208, "addi x3,  x0,  -3"    );
  asm( 'h20c, "addi x4,  x0,  -4"    );

  asm( 'h210, "add  x5,  x1,  x2"    );
  asm( 'h214, "add  x6,  x2,  x3"    );
  asm( 'h218, "add  x7,  x3,  x4"    );

  asm( 'h21c, "addi x1,  x0,  -2001" );
  asm( 'h220, "addi x2,  x0,  -2002" );
  asm( 'h224, "addi x3,  x0,  -2003" );
  asm( 'h228, "addi x4,  x0,  -2004" );

  asm( 'h22c, "add  x5,  x1,  x2"    );
  asm( 'h230, "add  x6,  x2,  x3"    );
  asm( 'h234, "add  x7,  x3,  x4"    );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_add_7_overflow
//------------------------------------------------------------------------

task test_case_add_7_overflow();
  t.test_case_begin( "test_case_add_7_overflow" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0,  0xfff" );
  asm( 'h204, "addi x2,  x0,  1"     );
  asm( 'h208, "add  x3,  x1,  x2"    );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// run_add_tests
//------------------------------------------------------------------------

task run_add_tests();
  test_case_add_1_basic();
  test_case_add_2_x0();
  test_case_add_3_regs();
  test_case_add_4_deps();
  test_case_add_5_pos();
  test_case_add_6_neg();
  test_case_add_7_overflow();
endtask
