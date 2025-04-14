//========================================================================
// BlimpV6_jal_test.v
//========================================================================

`include "hw/top/test/BlimpV6TestHarness.v"

module BlimpV6TestSuite_jal #(
  parameter p_suite_num     = 0,
  parameter p_opaq_bits     = 8,
  parameter p_seq_num_bits  = 5,
  parameter p_num_phys_regs = 36,

  parameter p_mem_send_intv_delay = 1,
  parameter p_mem_recv_intv_delay = 1
);
  string suite_name = $sformatf("%0d: BlimpV6TestSuite_%0d_%0d_%0d_%0d", 
                                p_suite_num,
                                p_opaq_bits, p_seq_num_bits,
                                p_mem_send_intv_delay, p_mem_recv_intv_delay);
  BlimpV6TestHarness #(
    .p_opaq_bits           (p_opaq_bits),
    .p_seq_num_bits        (p_seq_num_bits),
    .p_num_phys_regs       (p_num_phys_regs),
    .p_mem_send_intv_delay (p_mem_send_intv_delay),
    .p_mem_recv_intv_delay (p_mem_recv_intv_delay)
  ) h();

  `include "hw/top/test/test_cases/directed/jal_test_cases.v"
  `include "hw/top/test/test_cases/golden/jal_test_cases.v"
  task run_test_suite();
    h.t.test_suite_begin( suite_name );
    run_directed_jal_tests();
    run_golden_jal_tests();
  endtask
endmodule

module BlimpV6_jal_test;
  BlimpV6TestSuite_jal #(1)                 suite_1();
  BlimpV6TestSuite_jal #(2, 8, 5, 36, 1, 1) suite_2();
  BlimpV6TestSuite_jal #(3, 4, 3, 33, 1, 1) suite_3();
  BlimpV6TestSuite_jal #(4,32, 4, 50, 3, 1) suite_4();
  BlimpV6TestSuite_jal #(5, 2, 2, 48, 1, 3) suite_5();
  BlimpV6TestSuite_jal #(6, 4, 6, 42, 3, 3) suite_6();
  int s;

  initial begin
    test_bench_begin( `__FILE__ );
    s = get_test_suite();

    if ((s <= 0) || (s == 1)) suite_1.run_test_suite();
    if ((s <= 0) || (s == 2)) suite_2.run_test_suite();
    if ((s <= 0) || (s == 3)) suite_3.run_test_suite();
    if ((s <= 0) || (s == 4)) suite_4.run_test_suite();
    if ((s <= 0) || (s == 5)) suite_5.run_test_suite();
    if ((s <= 0) || (s == 6)) suite_6.run_test_suite();

    test_bench_end();
  end
endmodule
