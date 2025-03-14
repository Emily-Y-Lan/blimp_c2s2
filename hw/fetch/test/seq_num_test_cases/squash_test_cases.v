//========================================================================
// squash_test_cases.v
//========================================================================
// Tests that a sequence number generator can handle squashing

//----------------------------------------------------------------------
// test_case_squash_basic
//----------------------------------------------------------------------

task test_case_squash_basic();
  t.test_case_begin( "test_case_squash_basic" );
  if( !t.run_test ) return;

  seq_alloc( 0 );
  seq_alloc( 1 );

  check_allocated( 2 );

  squash( 0 ); // 1 is squashed
  seq_free( 0 );

  // Need at most two more cycles to reclaim
  @( posedge clk );
  @( posedge clk );
  #1;

  check_allocated( 0 );

  t.test_case_end();
endtask

//----------------------------------------------------------------------
// test_case_squash_capacity
//----------------------------------------------------------------------

task test_case_squash_capacity();
  t.test_case_begin( "test_case_squash_capacity" );
  if( !t.run_test ) return;

  for( int i = 0; i < p_num_seq_nums - 1; i = i + 1 ) begin
    seq_alloc(
      p_seq_num_bits'(i)
    );
  end

  check_allocated( p_num_seq_nums - 1 );

  squash( 0 ); // All but 0 are squashed
  seq_free( 0 );

  // Check that we can continue allocating
  seq_alloc( p_seq_num_bits'(p_num_seq_nums - 1) );
  for( int i = 0; i < p_num_seq_nums - 2; i = i + 1 ) begin
    seq_alloc(
      p_seq_num_bits'(i)
    );
  end

  t.test_case_end();
endtask

//----------------------------------------------------------------------
// run_squash_test_cases
//----------------------------------------------------------------------

task run_squash_test_cases();
  test_case_squash_basic();
  test_case_squash_capacity();
endtask

