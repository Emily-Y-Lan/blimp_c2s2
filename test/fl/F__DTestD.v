//========================================================================
// F__DTestD.v
//========================================================================
// A FL model of the Decode interface, to use in testing

`include "intf/F__DIntf.v"
`include "test/FLTestUtils.v"

`ifndef TEST_FL_F__D_TEST_D_V
`define TEST_FL_F__D_TEST_D_V

module F__DTestD #(
  parameter p_branch_delay = 0,

  parameter p_addr_bits = 32,
  parameter p_inst_bits = 32
)(
  input logic clk,
  input logic rst,
  
  F__DIntf.D_intf dut
);

  FLTestUtils t( .* );
  
  //----------------------------------------------------------------------
  // Store expected results in queue
  //----------------------------------------------------------------------

  typedef struct {
    logic [p_inst_bits-1:0] exp_inst;
    logic [p_addr_bits-1:0] exp_pc;
    logic                   dut_squash;
    logic [p_addr_bits-1:0] dut_branch_target;
    logic                   dut_branch_val;
  } transaction;

  transaction transaction_queue [$];

  transaction new_transaction;

  task add_msg(
    logic [p_inst_bits-1:0] exp_inst,
    logic [p_addr_bits-1:0] exp_pc,
    logic                   dut_squash,
    logic [p_addr_bits-1:0] dut_branch_target,
    logic                   dut_branch_val
  );
    new_transaction.exp_inst          = exp_inst;
    new_transaction.exp_pc            = exp_pc;
    new_transaction.dut_squash        = dut_squash;
    new_transaction.dut_branch_target = dut_branch_target;
    new_transaction.dut_branch_val    = dut_branch_val;

    transaction_queue.push_back( new_transaction );
  endtask

  int num_in_flight;
  initial num_in_flight = 0;

  function logic done();
    done = ( transaction_queue.size() == 0 )
         & ( num_in_flight == 0 );
  endfunction

  //----------------------------------------------------------------------
  // Set signals appropriately
  //----------------------------------------------------------------------

  transaction exp_transaction;

  initial begin
    while( 1 ) begin
      // Initial signal values
      dut.rdy           = 1'b0;
      dut.squash        = 1'b0;
      dut.branch_target = '0;
      dut.branch_val    = 1'b0;

      // Wait for reset
      @( negedge rst );

      // Align with clock edge
      @( posedge clk );
      #1;

      while ( !done() ) begin
        num_in_flight += 1;
        exp_transaction = transaction_queue.pop_front();
  
        // Set input values for the transaction
        dut.rdy = 1'b1;
  
        // Wait for the next transaction before a clock edge
        #8;
        while ( !dut.val & !rst ) begin
          #10;
        end
        if( rst ) break;
  
        // Check expected values
        `CHECK_EQ( dut.inst, exp_transaction.exp_inst );
        `CHECK_EQ( dut.pc,   exp_transaction.exp_pc   );
  
        #2;
        dut.rdy = 1'b0;
  
        // Inform our design of a squash/branch when needed
        for( int i = 0; i < p_branch_delay; i = i + 1 ) begin
          #10;
          if( rst ) break;
        end
        dut.squash        = exp_transaction.dut_squash;
        dut.branch_target = exp_transaction.dut_branch_target;
        dut.branch_val    = exp_transaction.dut_branch_val;
        #10;
        dut.squash        = 1'b0;
        dut.branch_target = '0;
        dut.branch_val    = 1'b0;

        num_in_flight -= 1;
      end
    end
  end

endmodule

`endif // TEST_FL_F__D_TEST_D_V
