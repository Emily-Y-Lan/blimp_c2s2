//========================================================================
// Keyboard.v
//========================================================================
// A module for capturing characters typed on a PS2 keyboard
//
// Protocol reference: https://www.burtonsys.com/ps2_chapweske.htm

`ifndef FPGA_PS2_KEYBOARD_V
`define FPGA_PS2_KEYBOARD_V

`include "fpga/util/Synchronizer.v"

module Keyboard (
  input  logic clk,
  input  logic rst,

  // ---------------------------------------------------------------------
  // PS2 Interface
  // ---------------------------------------------------------------------

  input  logic PS2_CLK,
  input  logic PS2_DATA,

  // ---------------------------------------------------------------------
  // Latency-Sensitive Output
  // ---------------------------------------------------------------------

  output logic [7:0] scan_code,
  output logic       val
);

  // ---------------------------------------------------------------------
  // Synchronize inputs
  // ---------------------------------------------------------------------

  logic ps2_clk_sync;
  logic ps2_data_sync;

  Synchronizer ps2_clk_synchronizer (
    .clk (clk),
    .in  (PS2_CLK),
    .out (ps2_clk_sync)
  );

  Synchronizer ps2_data_synchronizer (
    .clk (clk),
    .in  (PS2_DATA),
    .out (ps2_data_sync)
  );

  // ---------------------------------------------------------------------
  // Detect clock edges
  // ---------------------------------------------------------------------

  logic ps2_clk_buf;
  always_ff @( posedge clk ) begin
    ps2_clk_buf <= ps2_clk_sync;
  end

  logic ps2_negedge;
  assign ps2_negedge = ps2_clk_buf & !ps2_clk_sync;

  // ---------------------------------------------------------------------
  // Define state machine
  // ---------------------------------------------------------------------

  localparam IDLE  = 4'd0;
  localparam DATA0 = 4'd1;
  localparam DATA1 = 4'd2;
  localparam DATA2 = 4'd3;
  localparam DATA3 = 4'd4;
  localparam DATA4 = 4'd5;
  localparam DATA5 = 4'd6;
  localparam DATA6 = 4'd7;
  localparam DATA7 = 4'd8;
  localparam CHECK = 4'd9;

  logic [3:0] curr_state, next_state;

  always_ff @( posedge clk ) begin
    if( rst )
      curr_state <= IDLE;
    else
      curr_state <= next_state;
  end

  always_comb begin
    next_state = curr_state;

    case( curr_state )
      IDLE:  if( ps2_negedge & !ps2_data_sync ) next_state = DATA0;
      DATA0: if( ps2_negedge )                  next_state = DATA1;
      DATA1: if( ps2_negedge )                  next_state = DATA2;
      DATA2: if( ps2_negedge )                  next_state = DATA3;
      DATA3: if( ps2_negedge )                  next_state = DATA4;
      DATA4: if( ps2_negedge )                  next_state = DATA5;
      DATA5: if( ps2_negedge )                  next_state = DATA6;
      DATA6: if( ps2_negedge )                  next_state = DATA7;
      DATA7: if( ps2_negedge )                  next_state = CHECK;
      CHECK: if( ps2_negedge )                  next_state = IDLE;
      default:                                  next_state = IDLE;
    endcase
  end

  // ---------------------------------------------------------------------
  // Shift in data
  // ---------------------------------------------------------------------

  always_ff @( posedge clk ) begin
    if( rst ) scan_code <= 8'b0;
    else if( ps2_negedge ) begin
      case( curr_state )
        DATA0: scan_code <= { ps2_data_sync, scan_code[7:1] };
        DATA1: scan_code <= { ps2_data_sync, scan_code[7:1] };
        DATA2: scan_code <= { ps2_data_sync, scan_code[7:1] };
        DATA3: scan_code <= { ps2_data_sync, scan_code[7:1] };
        DATA4: scan_code <= { ps2_data_sync, scan_code[7:1] };
        DATA5: scan_code <= { ps2_data_sync, scan_code[7:1] };
        DATA6: scan_code <= { ps2_data_sync, scan_code[7:1] };
        DATA7: scan_code <= { ps2_data_sync, scan_code[7:1] };
        default: ; // Do nothing
      endcase
    end
  end

  // ---------------------------------------------------------------------
  // Set valid based on final parity
  // ---------------------------------------------------------------------

  logic parity;
  assign parity = ( ^ascii ) ^ ps2_data_sync;

  always_comb begin
    val = 1'b0;
    if( ps2_negedge & curr_state == CHECK )
      val = parity;
  end
endmodule

`endif // FPGA_PS2_KEYBOARD_V