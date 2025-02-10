//========================================================================
// Proc-mul-test-cases
//========================================================================
// Adapted from Cornell's ECE 2300

//------------------------------------------------------------------------
// test_case_mul_1_basic
//------------------------------------------------------------------------

task test_case_mul_1_basic(input int test_num);
  t.test_case_begin( $sformatf("test_case_%0d_mul_1_basic", test_num) );
  if( t.n != 0 )
      tracer.enable_trace();

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 2"  );
  asm( 'h004, "addi x2, x0, 3"  );
  asm( 'h008, "mul  x3, x1, x2" );

  // Check each executed instruction

  check_trace( 'h000, 1, 'h0000_0002, 1 ); // addi x1, x0, 2
  check_trace( 'h004, 2, 'h0000_0003, 1 ); // addi x2, x0, 3
  check_trace( 'h008, 3, 'h0000_0006, 1 ); // mul  x3, x1, x2

  tracer.disable_trace();
endtask

//------------------------------------------------------------------------
// test_case_mul_2_x0
//------------------------------------------------------------------------

task test_case_mul_2_x0(input int test_num);
  t.test_case_begin( $sformatf("test_case_%0d_mul_2_x0", test_num) );
  if( t.n != 0 )
      tracer.enable_trace();

  // Write assembly program into memory

  asm( 'h000, "addi x1, x0, 1"  );
  asm( 'h004, "addi x2, x0, 2"  );
  asm( 'h008, "mul  x0, x0, x0" );
  asm( 'h00c, "mul  x0, x0, x1" );
  asm( 'h010, "mul  x0, x2, x0" );
  asm( 'h014, "mul  x3, x0, x1" );
  asm( 'h018, "mul  x4, x2, x0" );

  // Check each executed instruction

  check_trace( 'h000,  1, 'h01, 1 ); // addi x1, x0, 1
  check_trace( 'h004,  2, 'h02, 1 ); // addi x2, x0, 2
  check_trace( 'h008, 'x, 'x,   0 ); // mul  x0, x0, x0
  check_trace( 'h00c, 'x, 'x,   0 ); // mul  x0, x0, x1
  check_trace( 'h010, 'x, 'x,   0 ); // mul  x0, x2, x0
  check_trace( 'h014,  3, 'h00, 1 ); // mul  x3, x0, x1
  check_trace( 'h018,  4, 'h00, 1 ); // mul  x4, x2, x0

  tracer.disable_trace();
endtask

//------------------------------------------------------------------------
// test_case_mul_3_regs
//------------------------------------------------------------------------

task test_case_mul_3_regs(input int test_num);
  t.test_case_begin( $sformatf("test_case_%0d_mul_3_regs", test_num) );
  if( t.n != 0 )
      tracer.enable_trace();

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0,  0x01" );
  asm( 'h004, "addi x2,  x0,  0x02" );
  asm( 'h008, "addi x3,  x0,  0x03" );
  asm( 'h00c, "addi x4,  x0,  0x04" );

  asm( 'h010, "mul  x1,  x2,  x3"   );
  asm( 'h014, "mul  x2,  x3,  x4"   );
  asm( 'h018, "mul  x3,  x4,  x1"   );
  asm( 'h01c, "mul  x4,  x1,  x2"   );

  asm( 'h020, "addi x28, x0,  0x24" );
  asm( 'h024, "addi x29, x0,  0x25" );
  asm( 'h028, "addi x30, x0,  0x26" );
  asm( 'h02c, "addi x31, x0,  0x27" );

  asm( 'h030, "mul  x28, x29, x30"  );
  asm( 'h034, "mul  x29, x30, x31"  );
  asm( 'h038, "mul  x30, x31, x28"  );
  asm( 'h03c, "mul  x31, x28, x29"  );

  asm( 'h040, "mul  x1,  x2,  x2"   );
  asm( 'h044, "mul  x2,  x2,  x3"   );
  asm( 'h048, "mul  x3,  x3,  x3"   );

  asm( 'h04c, "addi x1,  x1,  0"    );
  asm( 'h050, "addi x2,  x2,  0"    );
  asm( 'h054, "addi x3,  x3,  0"    );

  // Check each executed instruction

  check_trace( 'h000,  1, 'h01,     1 ); // mul  x1,  x0,  0x01
  check_trace( 'h004,  2, 'h02,     1 ); // mul  x2,  x0,  0x02
  check_trace( 'h008,  3, 'h03,     1 ); // mul  x3,  x0,  0x03
  check_trace( 'h00c,  4, 'h04,     1 ); // mul  x4,  x0,  0x04

  check_trace( 'h010,  1, 'h06,     1 ); // mul  x1,  x2,  x3
  check_trace( 'h014,  2, 'h0c,     1 ); // mul  x2,  x3,  x4
  check_trace( 'h018,  3, 'h18,     1 ); // mul  x3,  x4,  x1
  check_trace( 'h01c,  4, 'h48,     1 ); // mul  x4,  x1,  x2

  check_trace( 'h020, 28, 'h24,     1 ); // mul  x28, x0,  0x24
  check_trace( 'h024, 29, 'h25,     1 ); // mul  x29, x0,  0x25
  check_trace( 'h028, 30, 'h26,     1 ); // mul  x30, x0,  0x26
  check_trace( 'h02c, 31, 'h27,     1 ); // mul  x31, x0,  0x27

  check_trace( 'h030, 28, 'h00057e, 1 ); // mul  x28, x29, x30
  check_trace( 'h034, 29, 'h0005ca, 1 ); // mul  x29, x30, x31
  check_trace( 'h038, 30, 'h00d632, 1 ); // mul  x30, x31, x28
  check_trace( 'h03c, 31, 'h1fcb6c, 1 ); // mul  x31, x28, x29

  check_trace( 'h040,  1, 'h090,    1 ); // mul  x1,  x2,  x2
  check_trace( 'h044,  2, 'h120,    1 ); // mul  x2,  x2,  x3
  check_trace( 'h048,  3, 'h240,    1 ); // mul  x3,  x3,  x3

  check_trace( 'h04c,  1, 'h090,    1 ); // addi x1,  x2,  0
  check_trace( 'h050,  2, 'h120,    1 ); // addi x2,  x2,  0
  check_trace( 'h054,  3, 'h240,    1 ); // addi x3,  x3,  0

  tracer.disable_trace();
endtask

//------------------------------------------------------------------------
// test_case_mul_4_deps
//------------------------------------------------------------------------

task test_case_mul_4_deps(input int test_num);
  t.test_case_begin( $sformatf("test_case_%0d_mul_4_deps", test_num) );
  if( t.n != 0 )
      tracer.enable_trace();

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0,  0x02"   );
  asm( 'h004, "addi x2,  x0,  0x03"   );
  asm( 'h008, "mul  x3,  x1,  x2"     );
  asm( 'h00c, "mul  x4,  x3,  x1"     );
  asm( 'h010, "mul  x5,  x4,  x1"     );

  // Check each executed instruction

  check_trace( 'h000, 1, 'h02, 1 ); // addi x1,  x0,  0x02
  check_trace( 'h004, 2, 'h03, 1 ); // addi x2,  x0,  0x03
  check_trace( 'h008, 3, 'h06, 1 ); // mul  x3,  x1,  x2
  check_trace( 'h00c, 4, 'h0c, 1 ); // mul  x4,  x3,  x1
  check_trace( 'h010, 5, 'h18, 1 ); // mul  x5,  x4,  x1

  tracer.disable_trace();
endtask

//------------------------------------------------------------------------
// test_case_mul_5_pos
//------------------------------------------------------------------------

task test_case_mul_5_pos(input int test_num);
  t.test_case_begin( $sformatf("test_case_%0d_mul_5_pos", test_num) );
  if( t.n != 0 )
      tracer.enable_trace();

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0,  1"    );
  asm( 'h004, "addi x2,  x0,  2"    );
  asm( 'h008, "addi x3,  x0,  3"    );
  asm( 'h00c, "addi x4,  x0,  4"    );

  asm( 'h010, "mul  x5,  x1,  x2"   );
  asm( 'h014, "mul  x6,  x2,  x3"   );
  asm( 'h018, "mul  x7,  x3,  x4"   );

  asm( 'h01c, "addi x1,  x0,  2001" );
  asm( 'h020, "addi x2,  x0,  2002" );
  asm( 'h024, "addi x3,  x0,  2003" );
  asm( 'h028, "addi x4,  x0,  2004" );

  asm( 'h02c, "mul  x5,  x1,  x2"   );
  asm( 'h030, "mul  x6,  x2,  x3"   );
  asm( 'h034, "mul  x7,  x3,  x4"   );

  // Check each executed instruction

  check_trace( 'h000, 1, 1,         1 ); // addi x1,  x0,  1
  check_trace( 'h004, 2, 2,         1 ); // addi x2,  x0,  2
  check_trace( 'h008, 3, 3,         1 ); // addi x3,  x0,  3
  check_trace( 'h00c, 4, 4,         1 ); // addi x4,  x0,  4

  check_trace( 'h010, 5, 2,         1 ); // mul  x5,  x1,  x2
  check_trace( 'h014, 6, 6,         1 ); // mul  x6,  x2,  x3
  check_trace( 'h018, 7, 12,        1 ); // mul  x7,  x3,  x4

  check_trace( 'h01c, 1, 2001,      1 ); // addi x1,  x0,  2001
  check_trace( 'h020, 2, 2002,      1 ); // addi x2,  x0,  2002
  check_trace( 'h024, 3, 2003,      1 ); // addi x3,  x0,  2003
  check_trace( 'h028, 4, 2004,      1 ); // addi x4,  x0,  2004

  check_trace( 'h02c, 5, 4_006_002, 1 ); // mul  x5,  x1,  x2
  check_trace( 'h030, 6, 4_010_006, 1 ); // mul  x6,  x2,  x3
  check_trace( 'h034, 7, 4_014_012, 1 ); // mul  x7,  x3,  x4

  tracer.disable_trace();
endtask

//------------------------------------------------------------------------
// test_case_mul_6_neg
//------------------------------------------------------------------------

task test_case_mul_6_neg(input int test_num);
  t.test_case_begin( $sformatf("test_case_%0d_mul_6_neg", test_num) );
  if( t.n != 0 )
      tracer.enable_trace();

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0,  -1"    );
  asm( 'h004, "addi x2,  x0,   2"    );
  asm( 'h008, "addi x3,  x0,  -3"    );
  asm( 'h00c, "addi x4,  x0,  -4"    );

  asm( 'h010, "mul  x5,  x1,  x2"    );
  asm( 'h014, "mul  x6,  x2,  x3"    );
  asm( 'h018, "mul  x7,  x3,  x4"    );

  asm( 'h01c, "addi x1,  x0,  -2001" );
  asm( 'h020, "addi x2,  x0,   2002" );
  asm( 'h024, "addi x3,  x0,  -2003" );
  asm( 'h028, "addi x4,  x0,  -2004" );

  asm( 'h02c, "mul  x5,  x1,  x2"    );
  asm( 'h030, "mul  x6,  x2,  x3"    );
  asm( 'h034, "mul  x7,  x3,  x4"    );

  // Check each executed instruction

  check_trace( 'h000, 1, -1,         1 ); // addi x1,  x0,  -1
  check_trace( 'h004, 2,  2,         1 ); // addi x2,  x0,   2
  check_trace( 'h008, 3, -3,         1 ); // addi x3,  x0,  -3
  check_trace( 'h00c, 4, -4,         1 ); // addi x4,  x0,  -4

  check_trace( 'h010, 5, -2,         1 ); // mul  x5,  x1,  x2
  check_trace( 'h014, 6, -6,         1 ); // mul  x6,  x2,  x3
  check_trace( 'h018, 7, 12,         1 ); // mul  x7,  x3,  x4

  check_trace( 'h01c, 1, -2001,      1 ); // addi x1,  x0,  -2001
  check_trace( 'h020, 2,  2002,      1 ); // addi x2,  x0,   2002
  check_trace( 'h024, 3, -2003,      1 ); // addi x3,  x0,  -2003
  check_trace( 'h028, 4, -2004,      1 ); // addi x4,  x0,  -2004

  check_trace( 'h02c, 5, -4_006_002, 1 ); // mul  x5,  x1,  x2
  check_trace( 'h030, 6, -4_010_006, 1 ); // mul  x6,  x2,  x3
  check_trace( 'h034, 7,  4_014_012, 1 ); // mul  x7,  x3,  x4

  tracer.disable_trace();
endtask

//------------------------------------------------------------------------
// test_case_mul_7_overflow
//------------------------------------------------------------------------

task test_case_mul_7_overflow(input int test_num);
  t.test_case_begin( $sformatf("test_case_%0d_mul_7_overflow", test_num) );
  if( t.n != 0 )
      tracer.enable_trace();

  // Write assembly program into memory

  asm( 'h000, "addi x1,  x0,  0xfff" );
  asm( 'h004, "addi x2,  x0,  2"     );
  asm( 'h008, "mul  x3,  x1,  x2"    );

  // Check each executed instruction

  check_trace( 'h000, 1, 'hffff_ffff, 1 ); // addi x1,  x0,  0xfff
  check_trace( 'h004, 2, 'h0000_0002, 1 ); // addi x2,  x0,  2
  check_trace( 'h008, 3, 'hffff_fffe, 1 ); // addi x3,  x1,  x2

  tracer.disable_trace();
endtask

//------------------------------------------------------------------------
// test_case_mul_8_mix
//------------------------------------------------------------------------

task test_case_mul_8_mix(input int test_num);
  t.test_case_begin( $sformatf("test_case_%0d_mul_8_mix", test_num) );
  if( t.n != 0 )
      tracer.enable_trace();

  // Write assembly program into memory

  asm( 'h000, "addi x3,  x0, 0"     );

  asm( 'h004, "addi x4,  x0, 1"     );
  asm( 'h008, "addi x5,  x0, 5"     );
  asm( 'h00c, "mul  x6,  x4, x5"    );
  asm( 'h010, "add  x3,  x3, x6"    );

  asm( 'h014, "addi x4,  x0, 2"     );
  asm( 'h018, "addi x5,  x0, 6"     );
  asm( 'h01c, "mul  x6,  x4, x5"    );
  asm( 'h020, "add  x3,  x3, x6"    );

  asm( 'h024, "addi x4,  x0, 3"     );
  asm( 'h028, "addi x5,  x0, 7"     );
  asm( 'h02c, "mul  x6,  x4, x5"    );
  asm( 'h030, "add  x3,  x3, x6"    );

  // Check each executed instruction

  check_trace( 'h000, 3,  0, 1 ); // addi x3,  x0, 0

  check_trace( 'h004, 4,  1, 1 ); // addi x4,  x0, 1
  check_trace( 'h008, 5,  5, 1 ); // addi x5,  x0, 5
  check_trace( 'h00c, 6,  5, 1 ); // mul  x6,  x4, x5
  check_trace( 'h010, 3,  5, 1 ); // add  x3,  x3, x6

  check_trace( 'h014, 4,  2, 1 ); // addi x4,  x0, 2
  check_trace( 'h018, 5,  6, 1 ); // addi x5,  x0, 6
  check_trace( 'h01c, 6, 12, 1 ); // mul  x6,  x4, x5
  check_trace( 'h020, 3, 17, 1 ); // add  x3,  x3, x6

  check_trace( 'h024, 4,  3, 1 ); // addi x4,  x0, 3
  check_trace( 'h028, 5,  7, 1 ); // addi x5,  x0, 7
  check_trace( 'h02c, 6, 21, 1 ); // mul  x6,  x4, x5
  check_trace( 'h030, 3, 38, 1 ); // add  x3,  x3, x6

  tracer.disable_trace();
endtask

//------------------------------------------------------------------------
// run_mul_tests
//------------------------------------------------------------------------

task run_mul_tests(input int test_num);
  if ((t.c <= 0) || (t.c == 1)) test_case_mul_1_basic   ( test_num );
  if ((t.c <= 0) || (t.c == 2)) test_case_mul_2_x0      ( test_num );
  if ((t.c <= 0) || (t.c == 3)) test_case_mul_3_regs    ( test_num );
  if ((t.c <= 0) || (t.c == 4)) test_case_mul_4_deps    ( test_num );
  if ((t.c <= 0) || (t.c == 5)) test_case_mul_5_pos     ( test_num );
  if ((t.c <= 0) || (t.c == 6)) test_case_mul_6_neg     ( test_num );
  if ((t.c <= 0) || (t.c == 7)) test_case_mul_7_overflow( test_num );
  if ((t.c <= 0) || (t.c == 8)) test_case_mul_8_mix     ( test_num );
endtask
