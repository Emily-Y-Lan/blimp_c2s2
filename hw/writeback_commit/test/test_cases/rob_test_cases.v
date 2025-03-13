//========================================================================
// rob_test_cases.v
//========================================================================
`include "hw/writeback_commit/ROB.v"

localparam ref_data_len = 5;
t_rob_data ref_data[ref_data_len];

//----------------------------------------------------------------------
// test_case_seq_order
//----------------------------------------------------------------------

task test_case_seq_order();
  t.test_case_begin( "test_case_seq_order" );
  if( !t.run_test ) return;
  for (int i = 0; i < ref_data_len; i++) ref_data[i] = $bits(t_rob_data)'($urandom());

  fork
    begin
      //   seq_num   data
      send({2'h0, ref_data[0][($bits(t_rob_data)-3):0]});
      send({2'h1, ref_data[1][($bits(t_rob_data)-3):0]});
      send({2'h2, ref_data[2][($bits(t_rob_data)-3):0]});
      send({2'h3, ref_data[3][($bits(t_rob_data)-3):0]});
      send({2'h0, ref_data[4][($bits(t_rob_data)-3):0]});
    end

    begin
      //   seq_num   data
      recv({2'h0, ref_data[0][($bits(t_rob_data)-3):0]});
      recv({2'h1, ref_data[1][($bits(t_rob_data)-3):0]});
      recv({2'h2, ref_data[2][($bits(t_rob_data)-3):0]});
      recv({2'h3, ref_data[3][($bits(t_rob_data)-3):0]});
      recv({2'h0, ref_data[4][($bits(t_rob_data)-3):0]});
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

  for (int i = 0; i < ref_data_len; i++) ref_data[i] = $bits(t_rob_data)'($urandom());

  fork
    begin
      //   seq_num   data
      send({2'h1, ref_data[0][($bits(t_rob_data)-3):0]});
      send({2'h2, ref_data[1][($bits(t_rob_data)-3):0]});
      send({2'h0, ref_data[2][($bits(t_rob_data)-3):0]});
      send({2'h3, ref_data[3][($bits(t_rob_data)-3):0]});
      send({2'h0, ref_data[4][($bits(t_rob_data)-3):0]});
    end

    begin
      //   seq_num   data
      recv({2'h0, ref_data[2][($bits(t_rob_data)-3):0]});
      recv({2'h1, ref_data[0][($bits(t_rob_data)-3):0]});
      recv({2'h2, ref_data[1][($bits(t_rob_data)-3):0]});
      recv({2'h3, ref_data[3][($bits(t_rob_data)-3):0]});
      recv({2'h0, ref_data[4][($bits(t_rob_data)-3):0]});
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
