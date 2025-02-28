//========================================================================
// disassemble.v
//========================================================================
// An include to access the 32b disassembly function

`ifndef TEST_ASM_RV32_DISASSEMBLE32_V
`define TEST_ASM_RV32_DISASSEMBLE32_V

`ifndef SYNTHESIS
import "DPI-C" function string disassemble( bit [31:0] binary, bit [31:0] pc );
`endif

`endif // TEST_ASM_DISASSEMBLE_V
