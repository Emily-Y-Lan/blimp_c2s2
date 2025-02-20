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
      //   addr            inst
      send(p_rst_addr + 0, assemble32("mul x1, x0, x0"));
      send(p_rst_addr + 4, assemble32("addi x1, x0, 10"));
    end

    begin
      //   pc              op1 op2  waddr uop
      recv(p_rst_addr + 0, 0,   0,  1,    OP_MUL);
      recv(p_rst_addr + 4, 0,  10,  1,    OP_ADD);
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
      send(p_rst_addr +  0, assemble32("add  x2, x0, x1"));
      send(p_rst_addr +  4, assemble32("add  x4, x3, x2"));
      send(p_rst_addr +  8, assemble32("add  x5, x5, x4"));
      send(p_rst_addr + 12, assemble32("add  x5, x5, x5"));
      send(p_rst_addr + 16, assemble32("add  x6, x5, x4"));
    end

    begin
      //   pc                op1 op2  waddr uop
      recv(p_rst_addr +  0,  0,   1,  2,    OP_ADD);
      pub( 'x, 2, 1, 1 );
      recv(p_rst_addr +  4,  3,   1,  4,    OP_ADD);
      pub( 'x, 4, 4, 1 );
      recv(p_rst_addr +  8,  5,   4,  5,    OP_ADD);
      pub( 'x, 5, 9, 1 );
      recv(p_rst_addr + 12,  9,   9,  5,    OP_ADD);
      pub( 'x, 5, 18, 1 );
      recv(p_rst_addr + 16, 18,   4,  6,    OP_ADD);
    end
  join

  t.test_case_end();
endtask

//----------------------------------------------------------------------
// run_basic
//----------------------------------------------------------------------

task run_basic();
  test_case_basic();
  test_case_pending();
endtask
