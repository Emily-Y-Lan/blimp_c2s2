//========================================================================
// basic_test_cases.v
//========================================================================

//----------------------------------------------------------------------
// test_case_basic
//----------------------------------------------------------------------

task test_case_basic();
  t.test_case_begin( "test_case_basic" );
  if( !t.run_test ) return;

  fork
    begin
      //   pipe pc  seq_num addr  data          wen
      send(0,   '0, 0,      5'h1, 32'hdeadbeef, 1'b1);
      send(0,   '1, 1,      5'h2, 32'hcafecafe, 1'b1);
    end

    begin
      //           seq_num addr  data          wen
      complete_sub(0,      5'h1, 32'hdeadbeef, 1'b1);
      complete_sub(1,      5'h2, 32'hcafecafe, 1'b1);
    end

    begin
      //         pc  seq_num addr  data          wen
      commit_sub('0, 0,      5'h1, 32'hdeadbeef, 1'b1);
      commit_sub('1, 1,      5'h2, 32'hcafecafe, 1'b1);
    end
  join

  t.test_case_end();
endtask

//----------------------------------------------------------------------
// run_basic_test_cases
//----------------------------------------------------------------------

task run_basic_test_cases();
  test_case_basic();
endtask
