//========================================================================
// basic_test_cases.v
//========================================================================
// Basic tests for a sequencing unit

//----------------------------------------------------------------------
// test_case_1_basic
//----------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );
  if( !t.run_test ) return;

  seq_alloc( mk_seq_num(0, 0) );
  seq_alloc( mk_seq_num(0, 1) );

  check_age( mk_seq_num(0, 0), mk_seq_num(0, 1), 1 );
  check_allocated( 2 );

  seq_free( mk_seq_num(0, 0) );
  seq_free( mk_seq_num(0, 1) );

  t.test_case_end();
endtask

//----------------------------------------------------------------------
// test_case_2_reclaim
//----------------------------------------------------------------------

task test_case_2_reclaim();
  t.test_case_begin( "test_case_2_reclaim" );
  if( !t.run_test ) return;

  seq_alloc( mk_seq_num(0, 0) );
  seq_alloc( mk_seq_num(0, 1) );

  check_age( mk_seq_num(0, 0), mk_seq_num(0, 1), 1 );
  check_allocated( 2 );

  seq_free( mk_seq_num(0, 0) );
  seq_free( mk_seq_num(0, 1) );

  // Need one more cycle to reclaim
  @( posedge clk );
  #1;

  check_allocated( 0 );

  t.test_case_end();
endtask

//----------------------------------------------------------------------
// test_case_3_ooo_free
//----------------------------------------------------------------------

task test_case_3_ooo_free();
  t.test_case_begin( "test_case_3_ooo_free" );
  if( !t.run_test ) return;

  seq_alloc( mk_seq_num(0, 0) );
  seq_alloc( mk_seq_num(0, 1) );

  check_age( mk_seq_num(0, 0), mk_seq_num(0, 1), 1 );
  check_allocated( 2 );

  seq_free( mk_seq_num(0, 1) );
  seq_free( mk_seq_num(0, 0) );

  // Need at max two more cycles to reclaim
  @( posedge clk );
  @( posedge clk );
  #1;

  check_allocated( 0 );

  t.test_case_end();
endtask

//----------------------------------------------------------------------
// test_case_4_reclaim_speed
//----------------------------------------------------------------------
// Test how fast entries are reclaimed

task test_case_4_reclaim_speed();
  t.test_case_begin( "test_case_4_reclaim_speed" );
  if( !t.run_test ) return;

  for( int i = 0; i < 16; i = i + 1 )
    seq_alloc( p_seq_num_bits'(i) );

  for( int i = 1; i < 16; i = i + 1 )
    seq_free( p_seq_num_bits'(i) );

  // Check we still have 16 outstanding entries to reclaim
  check_allocated( 16 );

  // Free the last
  seq_free( 0 );

  // Only wait the needed time
  for( int i = 0; i < 16 / p_free_width; i = i + 1 )
    @( posedge clk );
  #1;

  check_allocated( 0 );

  t.test_case_end();
endtask

//----------------------------------------------------------------------
// run_basic_test_cases
//----------------------------------------------------------------------

task run_basic_test_cases();
  test_case_1_basic();
  test_case_2_reclaim();
  test_case_3_ooo_free();
  test_case_4_reclaim_speed();
endtask

