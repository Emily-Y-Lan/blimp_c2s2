//========================================================================
// arith_test_cases.v
//========================================================================
// Arithmetic test cases for a decode-issue unit

//----------------------------------------------------------------------
// test_case_add
//----------------------------------------------------------------------

task test_case_add();
  t.test_case_begin( "test_case_add" );
  if( !t.run_test ) return;
    
  //   seq_num waddr wdata wen
  pub( 'x,     1,    3,    1 );
  pub( 'x,     2,    7,    1 );

  fork
    begin
      //   addr   inst
      send('h200, assemble32("add x4, x1, x2"));
      send('h204, assemble32("add x2, x5, x4"));
    end

    begin
      //   pc     op1 op2 waddr uop
      recv('h200, 3,  7,  4,    OP_ADD);
      pub( 'x, 4, 10, 1 );
      recv('h204, 0, 10,  2,    OP_ADD);
    end
  join

  t.test_case_end();
endtask

//----------------------------------------------------------------------
// test_case_addi
//----------------------------------------------------------------------

task test_case_addi();
  t.test_case_begin( "test_case_addi" );
  if( !t.run_test ) return;

  //   seq_num waddr wdata wen
  pub( 'x,     1,    9,    1 );

  fork
    begin
      //   addr   inst
      send('h200, assemble32("addi x3, x1, 10"));
      send('h204, assemble32("addi x2, x3, 2047"));
    end

    begin
      //   pc     op1 op2  waddr uop
      recv('h200, 9,   10, 3,    OP_ADD );
      pub( 'x, 3, 13, 1 );
      recv('h204, 13, 2047, 2,    OP_ADD );
    end
  join
  
  t.test_case_end();
endtask

//----------------------------------------------------------------------
// test_case_mul
//----------------------------------------------------------------------

task test_case_mul();
  t.test_case_begin( "test_case_mul" );
  if( !t.run_test ) return;

  fork
    begin
      //   addr   inst
      send('h200, assemble32("addi x3, x0, 10"));
      send('h204, assemble32("addi x2, x0,  5"));
      send('h208, assemble32("mul  x4, x3, x2"));
      send('h20c, assemble32("mul  x4, x4, x2"));
      send('h210, assemble32("mul  x4, x4, x4"));
    end

    begin
      recv('h200,   0,   10, 3,    OP_ADD );
      pub( 'x, 3,  10, 1 );
      recv('h204,   0,    5, 2,    OP_ADD );
      pub( 'x, 2,   5, 1 );
      recv('h208,  10,    5, 4,    OP_MUL );
      pub( 'x, 4,  50, 1 );
      recv('h20c,  50,    5, 4,    OP_MUL );
      pub( 'x, 4, 250, 1 );
      recv('h210, 250,  250, 4,    OP_MUL );
    end
  join
  
  t.test_case_end();
endtask

//----------------------------------------------------------------------
// run_arith_l1_test_cases
//----------------------------------------------------------------------

task run_arith_l1_test_cases();
  test_case_add();
  test_case_addi();
  test_case_mul();
endtask
