//========================================================================
// rob_test_cases.v
//========================================================================

//----------------------------------------------------------------------
// test_case_seq_order
//----------------------------------------------------------------------

task test_case_seq_order();
  t.test_case_begin( "test_case_seq_order" );
  if( !t.run_test ) return;

  fork
    begin
      //   ins_data    ins_tag
      send('h12345678, 'h0);
      send('h87654321, 'h1);
      send('h00000000, 'h2);
      send('hFFFFFFFF, 'h3);
      send('h0F0F0F0F, 'h0);
    end

    begin
      //   deq_front_data
      recv('h12345678);
      recv('h87654321);
      recv('h00000000);
      recv('hFFFFFFFF);
    end
  join

  t.test_case_end();
endtask

//----------------------------------------------------------------------
// test_case_out_of_order
//----------------------------------------------------------------------

task test_case_out_of_order();
  t.test_case_begin( "test_case_out_of_order" );
  if( !t.run_test ) return;

  fork
    begin
      //   ins_data    ins_tag
      send('hFFFFFFFF, 'h3);
      send('h87654321, 'h1);
      send('h00000000, 'h2);
      send('h12345678, 'h0);
    end

    begin
      //   deq_front_data
      recv('h12345678);
      recv('h87654321);
      recv('h00000000);
      recv('hFFFFFFFF);
    end
  join

  t.test_case_end();
endtask

//----------------------------------------------------------------------
// run_basic_test_cases
//----------------------------------------------------------------------

task run_rob_test_cases();
  test_case_seq_order();
  test_case_out_of_order();
endtask
