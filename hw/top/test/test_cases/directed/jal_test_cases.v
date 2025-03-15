//========================================================================
// jal_test_cases.v
//========================================================================
// Adapted from Cornell's ECE 2300

//------------------------------------------------------------------------
// test_case_directed_jal_1_basic
//------------------------------------------------------------------------

task test_case_directed_jal_1_basic();
  t.test_case_begin( "test_case_directed_jal_1_basic" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1, x0, 1" );
  asm( 'h204, "jal  x2, 0x20c" );
  asm( 'h208, "addi x1, x0, 2" );
  asm( 'h20c, "addi x1, x0, 3" );

  // Check each executed instruction

  check_trace( 'h200,  1, 'h0000_0001, 1 ); // addi x1, x0, 1
  check_trace( 'h204,  2, 'h0000_0208, 1 ); // jal  x2, 0x00c
  check_trace( 'h20c,  1, 'h0000_0003, 1 ); // addi x1, x0, 3

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_jal_2_x0
//------------------------------------------------------------------------

task test_case_directed_jal_2_x0();
  t.test_case_begin( "test_case_directed_jal_2_x0" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "jal  x0, 0x208"   );
  asm( 'h204, "addi x1, x0, 1"   );
  asm( 'h208, "addi x2, x0, 2"   );

  // Check each executed instruction

  check_trace( 'h200, 'x,          'x, 0 ); // jal  x0, 0x008
  check_trace( 'h208,  2, 'h0000_0002, 1 ); // addi x2, x0, 2

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_jal_3_chain
//------------------------------------------------------------------------

task test_case_directed_jal_3_chain();
  t.test_case_begin( "test_case_directed_jal_3_chain" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "jal  x1, 0x208" );
  asm( 'h204, "addi x2, x0, 1" );
  asm( 'h208, "jal  x3, 0x210" );
  asm( 'h20c, "addi x4, x0, 2" );
  asm( 'h210, "jal  x5, 0x218" );
  asm( 'h214, "addi x6, x0, 3" );
  asm( 'h218, "addi x7, x0, 4" );

  // Check each executed instruction

  check_trace( 'h200,  1, 'h204, 1 ); // jal  x1, 0x208
  check_trace( 'h208,  3, 'h20c, 1 ); // jal  x3, 0x210
  check_trace( 'h210,  5, 'h214, 1 ); // jal  x5, 0x218
  check_trace( 'h218,  7,     4, 1 ); // addi x7, x0, 4

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_jal_4_forward
//------------------------------------------------------------------------

task test_case_directed_jal_4_forward();
  t.test_case_begin( "test_case_directed_jal_4_forward" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "jal  x1,  0x208"  );
  asm( 'h204, "addi x2,  x0,  1" );
  asm( 'h208, "addi x3,  x0,  2" );

  asm( 'h20c, "jal  x4,  0x218"  );
  asm( 'h210, "addi x5,  x0,  3" );
  asm( 'h214, "addi x6,  x0,  4" );
  asm( 'h218, "addi x7,  x0,  5" );

  asm( 'h21c, "jal  x8,  0x22c" );
  asm( 'h220, "addi x9,  x0,  6" );
  asm( 'h224, "addi x10, x0,  7" );
  asm( 'h228, "addi x11, x0,  8" );
  asm( 'h22c, "addi x12, x0,  9" );

  asm( 'h230, "jal  x13, 0x244"  );
  asm( 'h234, "addi x14, x0, 10" );
  asm( 'h238, "addi x15, x0, 11" );
  asm( 'h23c, "addi x16, x0, 12" );
  asm( 'h240, "addi x17, x0, 13" );
  asm( 'h244, "addi x18, x0, 14" );

  // Check each executed instruction

  check_trace( 'h200,  1, 'h204, 1 ); // jal  x1,  0x208
  check_trace( 'h208,  3,     2, 1 ); // addi x3,  x0,  2

  check_trace( 'h20c,  4, 'h210, 1 ); // jal  x4,  0x218
  check_trace( 'h218,  7,     5, 1 ); // addi x7,  x0,  5

  check_trace( 'h21c,  8, 'h220, 1 ); // jal  x8,  0x22c
  check_trace( 'h22c, 12,     9, 1 ); // addi x12, x0,  9

  check_trace( 'h230, 13, 'h234, 1 ); // jal  x13, 0x244
  check_trace( 'h244, 18,    14, 1 ); // addi x18, x0, 14

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_jal_5_backward
//------------------------------------------------------------------------

task test_case_directed_jal_5_backward();
  t.test_case_begin( "test_case_directed_jal_5_backward" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "jal  x1,  0x234"  ); // --------.
  asm( 'h204, "addi x2,  x0, 1"  ); // <-.     |
  asm( 'h208, "addi x3,  x0, 2"  ); //   |     |
  asm( 'h20c, "addi x4,  x0, 3"  ); //   |     |
  asm( 'h210, "addi x5,  x0, 4"  ); //   |     |
  asm( 'h214, "addi x6,  x0, 5"  ); //   |     |
  asm( 'h218, "addi x7,  x0, 6"  ); // <-+--.  |
  asm( 'h21c, "jal  x8,  0x204"  ); // --'  |  |
  asm( 'h220, "addi x9,  x0, 7"  ); //      |  |
  asm( 'h224, "addi x10, x0, 8"  ); //      |  |
  asm( 'h228, "addi x11, x0, 9"  ); // <-.  |  |
  asm( 'h22c, "jal  x12, 0x218"  ); // --+--'  |
  asm( 'h230, "addi x13, x0, 10" ); //   |     |
  asm( 'h234, "addi x14, x0, 11" ); // <-+-----'
  asm( 'h238, "jal  x15, 0x228"  ); // --'

  // Check each executed instruction

  check_trace( 'h200,  1, 'h204, 1 ); // jal  x1,  0x238
  check_trace( 'h234, 14,    11, 1 ); // addi x14, x0, 11
  check_trace( 'h238, 15, 'h23c, 1 ); // jal  x15, 0x228
  check_trace( 'h228, 11,     9, 1 ); // addi x11, x0, 9
  check_trace( 'h22c, 12, 'h230, 1 ); // jal  x12, 0x218
  check_trace( 'h218,  7,     6, 1 ); // addi x7,  x0, 6
  check_trace( 'h21c,  8, 'h220, 1 ); // jal  x8,  0x204
  check_trace( 'h204,  2,     1, 1 ); // addi x2,  x0, 1
  check_trace( 'h208,  3,     2, 1 ); // addi x3,  x0, 2

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_jal_6_loop
//------------------------------------------------------------------------

task test_case_directed_jal_6_loop();
  t.test_case_begin( "test_case_directed_jal_6_loop" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0, 1"  ); // <-.
  asm( 'h204, "addi x2,  x0, 2"  ); //   |
  asm( 'h208, "addi x3,  x0, 3"  ); //   |
  asm( 'h20c, "jal  x4,  0x200"  ); // --'

  // Check each executed instruction

  check_trace( 'h200,  1,     1, 1 ); // addi x1,  x0, 1
  check_trace( 'h204,  2,     2, 1 ); // addi x2,  x0, 2
  check_trace( 'h208,  3,     3, 1 ); // addi x3,  x0, 3
  check_trace( 'h20c,  4, 'h210, 1 ); // jal  x4,  0x200
  check_trace( 'h200,  1,     1, 1 ); // addi x1,  x0, 1
  check_trace( 'h204,  2,     2, 1 ); // addi x2,  x0, 2
  check_trace( 'h208,  3,     3, 1 ); // addi x3,  x0, 3
  check_trace( 'h20c,  4, 'h210, 1 ); // jal  x4,  0x200
  check_trace( 'h200,  1,     1, 1 ); // addi x1,  x0, 1
  check_trace( 'h204,  2,     2, 1 ); // addi x2,  x0, 2
  check_trace( 'h208,  3,     3, 1 ); // addi x3,  x0, 3
  check_trace( 'h20c,  4, 'h210, 1 ); // jal  x4,  0x200

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_jal_7_loop_self
//------------------------------------------------------------------------

task test_case_directed_jal_7_loop_self();
  t.test_case_begin( "test_case_directed_jal_7_loop_self" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x0, x0, 0" );
  asm( 'h204, "addi x0, x0, 0" );
  asm( 'h208, "jal  x1, 0x208" );

  // Check each executed instruction

  check_trace( 'h200, 'x,    'x, 0 ); // addi x0, x0, 0
  check_trace( 'h204, 'x,    'x, 0 ); // addi x0, x0, 0
  check_trace( 'h208,  1, 'h20c, 1 ); // jal x1, 0x208
  check_trace( 'h208,  1, 'h20c, 1 ); // jal x1, 0x208
  check_trace( 'h208,  1, 'h20c, 1 ); // jal x1, 0x208
  check_trace( 'h208,  1, 'h20c, 1 ); // jal x1, 0x208

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_directed_jal_8_mix
//------------------------------------------------------------------------

task test_case_directed_jal_8_mix();
  t.test_case_begin( "test_case_directed_jal_8_mix" );
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

  // Check each executed instruction

  check_trace( 'h200, 1, 'h100, 1 ); // addi x1,  x0, 0x100
  check_trace( 'h204, 2, 'h110, 1 ); // addi x2,  x0, 0x110
  check_trace( 'h208, 3, 'h120, 1 ); // addi x3,  x0, 0x120
  check_trace( 'h20c, 4,     0, 1 ); // addi x4,  x0, 0

  check_trace( 'h210,  5,     1, 1 ); // lw   x5,  0(x1)
  check_trace( 'h214,  6,     5, 1 ); // lw   x6,  0(x2)
  check_trace( 'h218,  7,     5, 1 ); // mul  x7,  x5, x6
  check_trace( 'h21c,  4,     5, 1 ); // add  x4,  x4, x7
  check_trace( 'h220, 'x,    'x, 0 ); // sw   x4,  0(x3)
  check_trace( 'h224,  1, 'h104, 1 ); // addi x1,  x1, 4
  check_trace( 'h228,  2, 'h114, 1 ); // addi x2,  x2, 4
  check_trace( 'h22c,  3, 'h124, 1 ); // addi x3,  x3, 4
  check_trace( 'h230, 'x,    'x, 0 ); // jal  x0,  0x010
  
  check_trace( 'h210,  5,     2, 1 ); // lw   x5,  0(x1)
  check_trace( 'h214,  6,     6, 1 ); // lw   x6,  0(x2)
  check_trace( 'h218,  7,    12, 1 ); // mul  x7,  x5, x6
  check_trace( 'h21c,  4,    17, 1 ); // add  x4,  x4, x7
  check_trace( 'h220, 'x,    'x, 0 ); // sw   x4,  0(x3)
  check_trace( 'h224,  1, 'h108, 1 ); // addi x1,  x1, 4
  check_trace( 'h228,  2, 'h118, 1 ); // addi x2,  x2, 4
  check_trace( 'h22c,  3, 'h128, 1 ); // addi x3,  x3, 4
  check_trace( 'h230, 'x,    'x, 0 ); // jal  x0,  0x010

  check_trace( 'h210,  5,     3, 1 ); // lw   x5,  0(x1)
  check_trace( 'h214,  6,     7, 1 ); // lw   x6,  0(x2)
  check_trace( 'h218,  7,    21, 1 ); // mul  x7,  x5, x6
  check_trace( 'h21c,  4,    38, 1 ); // add  x4,  x4, x7
  check_trace( 'h220, 'x,    'x, 0 ); // sw   x4,  0(x3)
  check_trace( 'h224,  1, 'h10c, 1 ); // addi x1,  x1, 4
  check_trace( 'h228,  2, 'h11c, 1 ); // addi x2,  x2, 4
  check_trace( 'h22c,  3, 'h12c, 1 ); // addi x3,  x3, 4
  check_trace( 'h230, 'x,    'x, 0 ); // jal  x0,  0x010

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// run_directed_jal_tests
//------------------------------------------------------------------------

task run_directed_jal_tests();
  test_case_directed_jal_1_basic();
  test_case_directed_jal_2_x0();
  test_case_directed_jal_3_chain();
  test_case_directed_jal_4_forward();
  test_case_directed_jal_5_backward();
  test_case_directed_jal_6_loop();
  test_case_directed_jal_7_loop_self();
  test_case_directed_jal_8_mix();
endtask
