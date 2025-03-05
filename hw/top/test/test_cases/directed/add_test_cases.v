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

  // Check each executed instruction

  check_trace( 'h200, 1, 'h0000_0002, 1 ); // addi x1, x0, 2
  check_trace( 'h204, 2, 'h0000_0003, 1 ); // addi x2, x0, 3
  check_trace( 'h208, 3, 'h0000_0005, 1 ); // add  x3, x1, x2

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

  // Check each executed instruction

  check_trace( 'h200,  1, 'h01, 1 ); // addi x1, x0, 1
  check_trace( 'h204,  2, 'h02, 1 ); // addi x2, x0, 2
  check_trace( 'h208, 'x, 'x,   0 ); // add  x0, x0, x0
  check_trace( 'h20c, 'x, 'x,   0 ); // add  x0, x0, x1
  check_trace( 'h210, 'x, 'x,   0 ); // add  x0, x2, x0
  check_trace( 'h214,  3, 'h01, 1 ); // add  x3, x0, x1
  check_trace( 'h218,  4, 'h02, 1 ); // add  x4, x2, x0


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

  // Check each executed instruction

  check_trace( 'h200,  1, 'h01, 1 ); // add  x1,  x0,  0x01
  check_trace( 'h204,  2, 'h02, 1 ); // add  x2,  x0,  0x02
  check_trace( 'h208,  3, 'h03, 1 ); // add  x3,  x0,  0x03
  check_trace( 'h20c,  4, 'h04, 1 ); // add  x4,  x0,  0x04

  check_trace( 'h210,  1, 'h05, 1 ); // add  x1,  x2,  x3
  check_trace( 'h214,  2, 'h07, 1 ); // add  x2,  x3,  x4
  check_trace( 'h218,  3, 'h09, 1 ); // add  x3,  x4,  x1
  check_trace( 'h21c,  4, 'h0c, 1 ); // add  x4,  x1,  x2

  check_trace( 'h220, 28, 'h24, 1 ); // add  x28, x0,  0x24
  check_trace( 'h224, 29, 'h25, 1 ); // add  x29, x0,  0x25
  check_trace( 'h228, 30, 'h26, 1 ); // add  x30, x0,  0x26
  check_trace( 'h22c, 31, 'h27, 1 ); // add  x31, x0,  0x27

  check_trace( 'h230, 28, 'h4b, 1 ); // add  x28, x29, x30
  check_trace( 'h234, 29, 'h4d, 1 ); // add  x29, x30, x31
  check_trace( 'h238, 30, 'h72, 1 ); // add  x30, x31, x28
  check_trace( 'h23c, 31, 'h98, 1 ); // add  x31, x28, x29

  check_trace( 'h240,  1, 'h0e, 1 ); // add  x1,  x2,  x2
  check_trace( 'h244,  2, 'h10, 1 ); // add  x2,  x2,  x3
  check_trace( 'h248,  3, 'h12, 1 ); // add  x3,  x3,  x3

  check_trace( 'h24c,  1, 'h0e, 1 ); // addi x1,  x2,  0
  check_trace( 'h250,  2, 'h10, 1 ); // addi x2,  x2,  0
  check_trace( 'h254,  3, 'h12, 1 ); // addi x3,  x3,  0


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

  // Check each executed instruction

  check_trace( 'h200, 1, 'h01, 1 ); // addi x1,  x0,  0x01
  check_trace( 'h204, 2, 'h02, 1 ); // addi x2,  x0,  0x02
  check_trace( 'h208, 3, 'h03, 1 ); // add  x3,  x1,  x2
  check_trace( 'h20c, 4, 'h04, 1 ); // add  x4,  x3,  x1
  check_trace( 'h210, 5, 'h05, 1 ); // add  x5,  x4,  x1

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

  // Check each executed instruction

  check_trace( 'h200, 1, 1,    1 ); // addi x1,  x0,  1
  check_trace( 'h204, 2, 2,    1 ); // addi x2,  x0,  2
  check_trace( 'h208, 3, 3,    1 ); // addi x3,  x0,  3
  check_trace( 'h20c, 4, 4,    1 ); // addi x4,  x0,  4

  check_trace( 'h210, 5, 3,    1 ); // add  x5,  x1,  x2
  check_trace( 'h214, 6, 5,    1 ); // add  x6,  x2,  x3
  check_trace( 'h218, 7, 7,    1 ); // add  x7,  x3,  x4

  check_trace( 'h21c, 1, 2001, 1 ); // addi x1,  x0,  2001
  check_trace( 'h220, 2, 2002, 1 ); // addi x2,  x0,  2002
  check_trace( 'h224, 3, 2003, 1 ); // addi x3,  x0,  2003
  check_trace( 'h228, 4, 2004, 1 ); // addi x4,  x0,  2004

  check_trace( 'h22c, 5, 4003, 1 ); // add  x5,  x1,  x2
  check_trace( 'h230, 6, 4005, 1 ); // add  x6,  x2,  x3
  check_trace( 'h234, 7, 4007, 1 ); // add  x7,  x3,  x4

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

  // Check each executed instruction

  check_trace( 'h200, 1, -1,    1 ); // addi x1,  x0,  -1
  check_trace( 'h204, 2, -2,    1 ); // addi x2,  x0,  -2
  check_trace( 'h208, 3, -3,    1 ); // addi x3,  x0,  -3
  check_trace( 'h20c, 4, -4,    1 ); // addi x4,  x0,  -4

  check_trace( 'h210, 5, -3,    1 ); // add  x5,  x1,  x2
  check_trace( 'h214, 6, -5,    1 ); // add  x6,  x2,  x3
  check_trace( 'h218, 7, -7,    1 ); // add  x7,  x3,  x4

  check_trace( 'h21c, 1, -2001, 1 ); // addi x1,  x0,  -2001
  check_trace( 'h220, 2, -2002, 1 ); // addi x2,  x0,  -2002
  check_trace( 'h224, 3, -2003, 1 ); // addi x3,  x0,  -2003
  check_trace( 'h228, 4, -2004, 1 ); // addi x4,  x0,  -2004

  check_trace( 'h22c, 5, -4003, 1 ); // add  x5,  x1,  x2
  check_trace( 'h230, 6, -4005, 1 ); // add  x6,  x2,  x3
  check_trace( 'h234, 7, -4007, 1 ); // add  x7,  x3,  x4

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

  // Check each executed instruction

  check_trace( 'h200, 1, 'hffff_ffff, 1 ); // addi x1,  x0,  0xfff
  check_trace( 'h204, 2, 'h0000_0001, 1 ); // addi x2,  x0,  1
  check_trace( 'h208, 3, 'h0000_0000, 1 ); // addi x3,  x1,  x2

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
