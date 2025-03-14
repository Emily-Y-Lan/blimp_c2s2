//========================================================================
// squash_test_cases.v
//========================================================================
// Test cases to check handling of a squash

//----------------------------------------------------------------------
// test_case_squash_basic
//----------------------------------------------------------------------

task test_case_squash_basic();
  t.test_case_begin( "test_case_squash_basic" );
  if( !t.run_test ) return;

  //               addr  data
  fl_mem.init_mem( 'h200, 32'hdeadbeef );
  fl_mem.init_mem( 'h204, 32'hcafef00d );
  fl_mem.init_mem( 'h208, 32'hbaadb0ba );

  //    inst          pc     seq_num
  recv( 32'hdeadbeef, 'h200, 0 );

  //      seq_num target
  squash( 0,      'h208 );

  recv( 32'hbaadb0ba, 'h208, 1 );

  t.test_case_end();
endtask

//----------------------------------------------------------------------
// test_case_squash_forward
//----------------------------------------------------------------------

task test_case_squash_forward();
  t.test_case_begin( "test_case_squash_forward" );
  if( !t.run_test ) return;

  //               addr  data
  fl_mem.init_mem( 'h200, 32'h10101010 );
  fl_mem.init_mem( 'h204, 32'h20202020 );
  fl_mem.init_mem( 'h208, 32'h30303030 );
  fl_mem.init_mem( 'h20c, 32'h40404040 );
  fl_mem.init_mem( 'h210, 32'h50505050 );

  //    inst          pc     seq_num
  recv( 32'h10101010, 'h200, 0 );
  recv( 32'h20202020, 'h204, 1 );

  //      seq_num target
  squash( 0,      'h20c );

  recv( 32'h40404040, 'h20c, 2 );
  recv( 32'h50505050, 'h210, 3 );

  t.test_case_end();
endtask

//----------------------------------------------------------------------
// test_case_squash_backward
//----------------------------------------------------------------------

task test_case_squash_backward();
  t.test_case_begin( "test_case_squash_backward" );
  if( !t.run_test ) return;

  //               addr  data
  fl_mem.init_mem( 'h200, 32'hf0f0f0f0 );
  fl_mem.init_mem( 'h204, 32'he0e0e0e0 );
  fl_mem.init_mem( 'h208, 32'hd0d0d0d0 );
  fl_mem.init_mem( 'h20c, 32'hc0c0c0c0 );

  //    inst          pc     seq_num
  recv( 32'hf0f0f0f0, 'h200, 0 );
  recv( 32'he0e0e0e0, 'h204, 1 );
  recv( 32'hd0d0d0d0, 'h208, 2 );

  //      seq_num target
  squash( 1,      'h200 );

  recv( 32'hf0f0f0f0, 'h200, 3 );

  t.test_case_end();
endtask

//----------------------------------------------------------------------
// run_squash_test_cases
//----------------------------------------------------------------------

task run_squash_test_cases();
  test_case_squash_basic();
  test_case_squash_forward();
  test_case_squash_backward();
endtask
