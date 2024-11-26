//========================================================================
// assemble32.v
//========================================================================
// An include to access the 32b assembly function

`ifndef TEST_ASM_RV32_ASSEMBLE32_V
`define TEST_ASM_RV32_ASSEMBLE32_V

`ifndef SYNTHESIS
import "DPI-C" function bit [31:0] assemble32( string assembly );
`endif

`endif // TEST_ASM_RV32_ASSEMBLE32_V
