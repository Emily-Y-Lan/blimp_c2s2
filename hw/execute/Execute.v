//========================================================================
// Execute.v
//========================================================================
// A parametrized execute unit, representing different types of functions

`ifndef HW_EXECUTE_EXECUTE_V
`define HW_EXECUTE_EXECUTE_V

`include "hw/execute/execute_variants/ALU.v"
`include "hw/execute/execute_variants/Multiplier.v"
`include "intf/D__XIntf.v"
`include "intf/X__WIntf.v"

module Execute #(
  parameter p_execute_type = "alu"
)(
  input  logic clk,
  input  logic rst,

  //----------------------------------------------------------------------
  // D <-> X Interface
  //----------------------------------------------------------------------

  D__XIntf.X_intf D,

  //----------------------------------------------------------------------
  // X <-> W Interface
  //----------------------------------------------------------------------

  X__WIntf.X_intf W
);

`ifndef SYNTHESIS
  // verilator lint_off UNUSEDSIGNAL
  string trace;
  // verilator lint_on UNUSEDSIGNAL
`endif

  generate
    //----------------------------------------------------------------------
    // ALU
    //----------------------------------------------------------------------
  
    if ( p_execute_type == "alu" ) begin
      ALU alu (
        .*
      );

`ifndef SYNTHESIS
      assign trace = alu.trace;
`endif
    end

    //----------------------------------------------------------------------
    // Multiplier
    //----------------------------------------------------------------------
  
    else if ( p_execute_type == "mul" ) begin
      Multiplier mul (
        .*
      );

`ifndef SYNTHESIS
      assign trace = mul.trace;
`endif
    end
    
    else begin
      $error("Unknown execute type: '%s'", p_execute_type);
    end
  endgenerate

endmodule

`endif // HW_EXECUTE_EXECUTE_V
