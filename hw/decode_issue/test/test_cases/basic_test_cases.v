//========================================================================
// basic_test_cases.v
//========================================================================
// Basic test cases for a decode-issue unit (to ensure baseline
// functionality)

//----------------------------------------------------------------------
// test_case_basic
//----------------------------------------------------------------------

task test_case_basic();
  t.test_case_begin( "test_case_basic" );
  if( !t.run_test ) return;

  fork
    begin
      //   addr   inst
      send('h200, assemble("mul x1, x0, x0"));
      send('h204, assemble("addi x1, x0, 10"));
    end

    begin
      //   pc     op1 op2  waddr uop
      recv('h200, 0,   0,  1,    OP_MUL);
      recv('h204, 0,  10,  1,    OP_ADD);
    end
  join

  t.test_case_end();
endtask

//----------------------------------------------------------------------
// test_case_pending
//----------------------------------------------------------------------

task test_case_pending();
  t.test_case_begin( "test_case_pending" );
  if( !t.run_test ) return;

  //   seq_num waddr wdata wen
  pub( 'x,     1,    1,    1 );
  pub( 'x,     3,    3,    1 );
  pub( 'x,     5,    5,    1 );

  fork
    begin
      //   addr             inst
      send('h200, assemble("add  x2, x0, x1"));
      send('h204, assemble("add  x4, x3, x2"));
      send('h208, assemble("add  x5, x5, x4"));
      send('h20c, assemble("add  x5, x5, x5"));
      send('h210, assemble("add  x6, x5, x4"));
    end

    begin
      //   pc                op1 op2  waddr uop
      recv('h200,  0,   1,  2,    OP_ADD);
      pub( 'x, 2, 1, 1 );
      recv('h204,  3,   1,  4,    OP_ADD);
      pub( 'x, 4, 4, 1 );
      recv('h208,  5,   4,  5,    OP_ADD);
      pub( 'x, 5, 9, 1 );
      recv('h20c,  9,   9,  5,    OP_ADD);
      pub( 'x, 5, 18, 1 );
      recv('h210, 18,   4,  6,    OP_ADD);
    end
  join

  t.test_case_end();
endtask

//----------------------------------------------------------------------
// run_basic_test_cases
//----------------------------------------------------------------------

task run_basic_test_cases();
  test_case_basic();
  test_case_pending();
endtask
