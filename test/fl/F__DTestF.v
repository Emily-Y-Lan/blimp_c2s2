//========================================================================
// F__DTestD.v
//========================================================================
// A FL model of the Fetch interface, to use in testing

`ifndef TEST_FL_F__D_TEST_F_V
`define TEST_FL_F__D_TEST_F_V

import "DPI-C" function bit [31:0] assemble32( string assembly );

`include "intf/F__DIntf.v"

module F__DTestF #(
  parameter p_send_intv_delay = 0,
  parameter p_rst_addr        = 32'b0
)(
  input logic clk,
  input logic rst,
  
  F__DIntf.F_intf dut
);

  localparam p_addr_bits = dut.p_addr_bits;
  localparam p_inst_bits = dut.p_inst_bits;

  //----------------------------------------------------------------------
  // Store instructions in association array
  //----------------------------------------------------------------------

  logic [p_inst_bits-1:0] insts [logic [p_addr_bits-1:0]];

  always_ff @( posedge clk ) begin
    if( rst )
      insts.delete();
  end

  task add_inst(
    input logic [p_addr_bits-1:0] addr,
    input string                  inst
  );
    if ( p_addr_bits == 32 )
      insts[addr] = assemble32( inst );
    else
      $error(
        "Unsupported instruction size for assembly: %d", p_addr_bits);
  endtask

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Handle request control flow
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  int send_intv_delay;

  always_ff @( posedge clk ) begin
    if( send_intv_delay > 0 ) send_intv_delay <= send_intv_delay - 1;
  end

  logic incr_addr;

  always_ff @( posedge clk ) begin
    #1;
    if( rst ) begin
      dut.val <= 1'b0;
      incr_addr <= 1'b0;
    end else begin
      if( send_intv_delay == 0 ) begin
        dut.val <= 1'b1;
        #2;
        if( dut.rdy & !dut.squash ) begin
          incr_addr <= 1'b1;
          send_intv_delay <= p_send_intv_delay;
        end
      end else begin
        dut.val <= 1'b0;
        incr_addr <= 1'b0;
      end
    end
  end

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Form data
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logic [p_addr_bits-1:0] curr_addr;

  always_ff @( posedge clk ) begin
    if( rst )
      curr_addr <= p_rst_addr;
    else if( dut.squash )
      curr_addr <= dut.branch_target;
    else if( incr_addr )
      curr_addr <= curr_addr + 4;
  end

  always_comb begin
    dut.pc = curr_addr;

    if( insts.exists(curr_addr) == 1 )
      dut.inst = insts[curr_addr];
    else
      dut.inst = 'x;
  end

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

  function int ceil_div_4( int val );
    return (val / 4) + (val % 4);
  endfunction

  // verilator lint_off UNUSEDSIGNAL
  string trace;
  // verilator lint_on UNUSEDSIGNAL

  // verilator lint_off BLKSEQ
  always_comb begin
    int str_len;

    str_len = ceil_div_4(p_inst_bits) + 1 + // inst
              ceil_div_4(p_addr_bits);      // addr

    if( dut.val & dut.rdy )
      trace = $sformatf("%h:%h", dut.pc, dut.inst);
    else
      trace = {str_len{" "}};
  end
  // verilator lint_on BLKSEQ

endmodule

`endif // TEST_FL_F__D_TEST_F_V
