//========================================================================
// addi_test_cases.v
//========================================================================
// Adapted from Cornell's ECE 2300

//------------------------------------------------------------------------
// test_case_golden_addi_1_regs
//------------------------------------------------------------------------

task test_case_golden_addi_1_regs();
  t.test_case_begin( "test_case_golden_addi_1_regs" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0,  0x01"   );
  asm( 'h204, "addi x2,  x0,  0x02"   );
  asm( 'h208, "addi x3,  x0,  0x03"   );
  asm( 'h20c, "addi x4,  x0,  0x04"   );

  asm( 'h210, "addi x28, x0,  0x05"   );
  asm( 'h214, "addi x29, x0,  0x06"   );
  asm( 'h218, "addi x30, x0,  0x07"   );
  asm( 'h21c, "addi x31, x0,  0x08"   );

  asm( 'h220, "addi x5,  x1,  0x09"   );
  asm( 'h224, "addi x6,  x2,  0x0a"   );
  asm( 'h228, "addi x7,  x3,  0x0b"   );
  asm( 'h22c, "addi x8,  x4,  0x0c"   );

  asm( 'h230, "addi x24, x28, 0x0d"   );
  asm( 'h234, "addi x25, x29, 0x0e"   );
  asm( 'h238, "addi x26, x30, 0x0f"   );
  asm( 'h23c, "addi x27, x31, 0x10"   );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_golden_addi_2_deps
//------------------------------------------------------------------------

task test_case_golden_addi_2_deps();
  t.test_case_begin( "test_case_golden_addi_2_deps" );
  if( !t.run_test ) return;
  fl_reset();

  // Write assembly program into memory

  asm( 'h200, "addi x1,  x0,  0x01"   );
  asm( 'h204, "addi x1,  x1,  0x02"   );
  asm( 'h208, "addi x1,  x1,  0x03"   );
  asm( 'h20c, "addi x1,  x1,  0x04"   );

  check_traces();

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// run_golden_addi_tests
//------------------------------------------------------------------------

task run_golden_addi_tests();
  test_case_golden_addi_1_regs();
  test_case_golden_addi_2_deps();
endtask
