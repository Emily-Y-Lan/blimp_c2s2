//========================================================================
// bgeu_test_cases.v
//========================================================================

//------------------------------------------------------------------------
// test_case_directed_bgeu_1_basic
//------------------------------------------------------------------------

task test_case_directed_bgeu_1_basic();
  t.test_case_begin( "test_case_directed_bgeu_1_basic" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1, x0, 1"     );
  asm( 'h204, "bgeu x1, x0, 0x20c" );
  asm( 'h208, "addi x1, x0, 2"     );
  asm( 'h20c, "addi x1, x0, 3"     );

  // Check each executed instruction

  check_trace( 'h200,  1, 'h0000_0001, 1 ); // addi x1, x0, 1
  check_trace( 'h204, 'x, 'x,          0 ); // bgeu x1, x0, 0x20c
  check_trace( 'h20c,  1, 'h0000_0003, 1 ); // addi x1, x0, 3

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_bgeu_2_taken
//------------------------------------------------------------------------

task test_case_directed_bgeu_2_taken();
  t.test_case_begin( "test_case_directed_bgeu_2_taken" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0, 1"     );
  asm( 'h204, "addi x2,  x0, 2"     );
  asm( 'h208, "bgeu x2,  x1, 0x210" );
  asm( 'h20c, "addi x3,  x0, 3"     );
  asm( 'h210, "addi x4,  x0, 4"     );

  asm( 'h214, "addi x5,  x0, 100"   );
  asm( 'h218, "addi x6,  x0, 200"   );
  asm( 'h21c, "bgeu x6,  x5, 0x224" );
  asm( 'h220, "addi x7,  x0, 5"     );
  asm( 'h224, "addi x8,  x0, 6"     );

  asm( 'h228, "addi x9,   x0, -13"   );
  asm( 'h22c, "addi x10,  x0, 42"    );
  asm( 'h230, "bgeu  x9, x10, 0x238" );
  asm( 'h234, "addi x11,  x0, 7"     );
  asm( 'h238, "addi x12,  x0, 8"     );

  // Check each executed instruction

  check_trace( 'h200,  1,  1, 1 ); // addi x1,  x0, 1
  check_trace( 'h204,  2,  2, 1 ); // addi x2,  x0, 2
  check_trace( 'h208, 'x, 'x, 0 ); // bgeu x1,  x2, 0x210
  check_trace( 'h210,  4,  4, 1 ); // addi x4,  x0, 4

  check_trace( 'h214,  5, 100, 1 ); // addi x5,  x0, 100
  check_trace( 'h218,  6, 200, 1 ); // addi x6,  x0, 200
  check_trace( 'h21c, 'x,  'x, 0 ); // bgeu x5,  x6, 0x224
  check_trace( 'h224,  8,   6, 1 ); // addi x8,  x0, 6

  check_trace( 'h228,  9, -13, 1 ); // addi  x9,  x0, -13
  check_trace( 'h22c, 10,  42, 1 ); // addi x10,  x0, 42
  check_trace( 'h230, 'x,  'x, 0 ); // bgeu  x9, x10, 0x238
  check_trace( 'h238, 12,   8, 1 ); // addi x12,  x0, 8

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_bgeu_3_not_taken
//------------------------------------------------------------------------

task test_case_directed_bgeu_3_not_taken();
  t.test_case_begin( "test_case_directed_bgeu_3_not_taken" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0, 2"     );
  asm( 'h204, "addi x2,  x0, 1"     );
  asm( 'h208, "bgeu x2,  x1, 0x210" );
  asm( 'h20c, "addi x3,  x0, 3"     );
  asm( 'h210, "addi x4,  x0, 4"     );

  asm( 'h214, "addi x5,  x0, 100"   );
  asm( 'h218, "addi x6,  x0, 200"   );
  asm( 'h21c, "bgeu x5,  x6, 0x224" );
  asm( 'h220, "addi x7,  x0, 5"     );
  asm( 'h224, "addi x8,  x0, 6"     );

  asm( 'h228, "addi x9,  x0,  42"   );
  asm( 'h22c, "addi x10, x0, -13"   );
  asm( 'h230, "bgeu x9, x10, 0x238" );
  asm( 'h234, "addi x11, x0, 7"     );
  asm( 'h238, "addi x12, x0, 8"     );

  // Check each executed instruction

  check_trace( 'h200,  1,  2, 1 ); // addi x1,  x0, 2
  check_trace( 'h204,  2,  1, 1 ); // addi x2,  x0, 1
  check_trace( 'h208, 'x, 'x, 0 ); // bgeu x1,  x2, 0x210
  check_trace( 'h20c,  3,  3, 1 ); // addi x3,  x0, 3
  check_trace( 'h210,  4,  4, 1 ); // addi x4,  x0, 4

  check_trace( 'h214,  5, 100, 1 ); // addi x5,  x0, 100
  check_trace( 'h218,  6, 200, 1 ); // addi x6,  x0, 200
  check_trace( 'h21c, 'x,  'x, 0 ); // bgeu x6,  x5, 0x224
  check_trace( 'h220,  7,   5, 1 ); // addi x7,  x0, 5
  check_trace( 'h224,  8,   6, 1 ); // addi x8,  x0, 6

  check_trace( 'h228,  9,  42, 1 ); // addi x9,  x0, 42
  check_trace( 'h22c, 10, -13, 1 ); // addi x10, x0, -13
  check_trace( 'h230, 'x,  'x, 0 ); // bgeu x9, x10, 0x238
  check_trace( 'h234, 11,   7, 1 ); // addi x11, x0, 7
  check_trace( 'h238, 12,   8, 1 ); // addi x12, x0, 8

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_bgeu_4_chain
//------------------------------------------------------------------------

task test_case_directed_bgeu_4_chain();
  t.test_case_begin( "test_case_directed_bgeu_4_chain" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0, 1"     );
  asm( 'h204, "addi x2,  x0, 2"     );
  asm( 'h208, "addi x3,  x0, 100"   );
  asm( 'h20c, "addi x4,  x0, 200"   );
  asm( 'h210, "addi x5,  x0, -13"   );
  asm( 'h214, "addi x6,  x0, 42"    );

  asm( 'h218, "bgeu x2,  x1, 0x220" );
  asm( 'h21c, "addi x7,  x0, 2"     );
  asm( 'h220, "bgeu x4,  x3, 0x228" );
  asm( 'h224, "addi x8,  x0, 3"     );
  asm( 'h228, "bgeu x5,  x6, 0x230" );
  asm( 'h22c, "addi x9,  x0, 4"     );
  asm( 'h230, "addi x10, x0, 5"     );

  // Check each executed instruction

  check_trace( 'h200,  1,   1, 1 ); // addi x1,  x0, 1
  check_trace( 'h204,  2,   2, 1 ); // addi x2,  x0, 2
  check_trace( 'h208,  3, 100, 1 ); // addi x3,  x0, 100
  check_trace( 'h20c,  4, 200, 1 ); // addi x4,  x0, 200
  check_trace( 'h210,  5, -13, 1 ); // addi x5,  x0, -13
  check_trace( 'h214,  6,  42, 1 ); // addi x6,  x0, 42

  check_trace( 'h218, 'x, 'x, 0 ); // bgeu x2,  x1, 0x220
  check_trace( 'h220, 'x, 'x, 0 ); // bgeu x4,  x3, 0x228
  check_trace( 'h228, 'x, 'x, 0 ); // bgeu x5,  x6, 0x230
  check_trace( 'h230, 10,  5, 1 ); // addi x10, x0, 5

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_bgeu_5_backward
//------------------------------------------------------------------------

task test_case_directed_bgeu_5_backward();
  t.test_case_begin( "test_case_directed_bgeu_5_backward" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0,  1"    );
  asm( 'h204, "addi x8,  x0,  2"    );
  asm( 'h208, "addi x12, x0, -1"    );
  asm( 'h20c, "addi x15, x0, -2"    );

  asm( 'h210, "bgeu x1,  x0, 0x244" ); // --------.
  asm( 'h214, "addi x2,  x0, 1"     ); // <-.     |
  asm( 'h218, "addi x3,  x0, 2"     ); //   |     |
  asm( 'h21c, "addi x4,  x0, 3"     ); //   |     |
  asm( 'h220, "addi x5,  x0, 4"     ); //   |     |
  asm( 'h224, "addi x6,  x0, 5"     ); //   |     |
  asm( 'h228, "addi x7,  x0, 6"     ); // <-+--.  |
  asm( 'h22c, "bgeu x8,  x0, 0x214" ); // --'  |  |
  asm( 'h230, "addi x9,  x0, 7"     ); //      |  |
  asm( 'h234, "addi x10, x0, 8"     ); //      |  |
  asm( 'h238, "addi x11, x0, 9"     ); // <-.  |  |
  asm( 'h23c, "bgeu x12, x0, 0x228" ); // --+--'  |
  asm( 'h240, "addi x13, x0, 10"    ); //   |     |
  asm( 'h244, "addi x14, x0, 11"    ); // <-+-----'
  asm( 'h248, "bgeu x15, x0, 0x238" ); // --'

  // Check each executed instruction

  check_trace( 'h200,  1,  1, 1 ); // addi x1,  x0, 1
  check_trace( 'h204,  8,  2, 1 ); // addi x8,  x0, 2
  check_trace( 'h208, 12, -1, 1 ); // addi x12, x0, -1
  check_trace( 'h20c, 15, -2, 1 ); // addi x15, x0, -2

  check_trace( 'h210, 'x, 'x, 0 ); // bgeu  x1, x0, 0x244
  check_trace( 'h244, 14, 11, 1 ); // addi x14, x0, 11
  check_trace( 'h248, 'x, 'x, 0 ); // bgeu x15, x0, 0x238
  check_trace( 'h238, 11,  9, 1 ); // addi x11, x0, 9
  check_trace( 'h23c, 'x, 'x, 0 ); // bgeu x12, x0, 0x228
  check_trace( 'h228,  7,  6, 1 ); // addi  x7, x0, 6
  check_trace( 'h22c, 'x, 'x, 0 ); // bgeu  x8, x0, 0x214
  check_trace( 'h214,  2,  1, 1 ); // addi  x2, x0, 1
  check_trace( 'h218,  3,  2, 1 ); // addi  x3, x0, 2

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_bgeu_6_loop
//------------------------------------------------------------------------

task test_case_directed_bgeu_6_loop();
  t.test_case_begin( "test_case_directed_bgeu_6_loop" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x4, x0, 4"     );
  asm( 'h204, "addi x1, x0, -3"    ); //
  asm( 'h208, "addi x1, x1, 1"     ); // <-.
  asm( 'h20c, "addi x1, x1, 1"     ); //   |
  asm( 'h210, "bgeu x1, x4, 0x208" ); // --'
  asm( 'h214, "addi x2, x0, 1"     ); //
  asm( 'h218, "addi x3, x0, 2"     ); //

  // Check each executed instruction

  check_trace( 'h200,  4,  4, 1 ); // addi x4, x0, 4
  check_trace( 'h204,  1, -3, 1 ); // addi x1, x0, -3
  check_trace( 'h208,  1, -2, 1 ); // addi x1, x1, 1
  check_trace( 'h20c,  1, -1, 1 ); // addi x1, x1, 1
  check_trace( 'h210, 'x, 'x, 0 ); // bgeu x1, x0, 0x204
  check_trace( 'h208,  1,  0, 1 ); // addi x1, x1, 1
  check_trace( 'h20c,  1,  1, 1 ); // addi x1, x1, 1
  check_trace( 'h210, 'x, 'x, 0 ); // bgeu x1, x0, 0x204
  check_trace( 'h214,  2,  1, 1 ); // addi x2, x0, 1
  check_trace( 'h218,  3,  2, 1 ); // addi x3, x0, 2

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_bgeu_7_loop_self
//------------------------------------------------------------------------

task test_case_directed_bgeu_7_loop_self();
  t.test_case_begin( "test_case_directed_bgeu_7_loop_self" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1, x0, -1"    );
  asm( 'h204, "bgeu x1, x0, 0x204" );

  // Check each executed instruction

  check_trace( 'h200,  1, -1, 1 ); // addi x1, x0, -1
  check_trace( 'h204, 'x, 'x, 0 ); // bgeu x1, x0, 0x204
  check_trace( 'h204, 'x, 'x, 0 ); // bgeu x1, x0, 0x204
  check_trace( 'h204, 'x, 'x, 0 ); // bgeu x1, x0, 0x204
  check_trace( 'h204, 'x, 'x, 0 ); // bgeu x1, x0, 0x204

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// run_directed_bgeu_tests
//------------------------------------------------------------------------

task run_directed_bgeu_tests();
  test_case_directed_bgeu_1_basic();
  test_case_directed_bgeu_2_taken();
  test_case_directed_bgeu_3_not_taken();
  test_case_directed_bgeu_4_chain();
  test_case_directed_bgeu_5_backward();
  test_case_directed_bgeu_6_loop();
  test_case_directed_bgeu_7_loop_self();
endtask
