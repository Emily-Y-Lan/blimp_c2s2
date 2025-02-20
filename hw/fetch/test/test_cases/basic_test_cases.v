//========================================================================
// basic_test_cases.v
//========================================================================
// Basic test cases for a modular fetch unit

//----------------------------------------------------------------------
// test_case_basic
//----------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_basic" );
  if( !t.run_test ) return;

  //               addr            data
  fl_mem.init_mem( p_rst_addr,     p_inst_bits'(32'hdeadbeef) );
  fl_mem.init_mem( p_rst_addr + 4, p_inst_bits'(32'hcafef00d) );
  fl_mem.init_mem( p_rst_addr + 8, p_inst_bits'(32'hbaadb0ba) );

  //    inst          pc
  recv( p_inst_bits'(32'hdeadbeef), p_rst_addr     );
  recv( p_inst_bits'(32'hcafef00d), p_rst_addr + 4 );
  recv( p_inst_bits'(32'hbaadb0ba), p_rst_addr + 8 );

  t.test_case_end();
endtask

//----------------------------------------------------------------------
// run_basic_test_cases
//----------------------------------------------------------------------

task run_basic_test_cases();
  test_case_1_basic();
endtask
