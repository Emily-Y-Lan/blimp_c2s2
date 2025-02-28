//========================================================================
// assemble.v
//========================================================================
// An include to access the 32b assembly function

`ifndef TEST_ASM_ASSEMBLE_V
`define TEST_ASM_ASSEMBLE_V

`ifndef SYNTHESIS
import "DPI-C" function bit [31:0] assemble( string assembly, bit [31:0] pc );
`endif

`endif // TEST_ASM_ASSEMBLE_V
