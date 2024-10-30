//========================================================================
// ISA.v
//========================================================================
// Common definitions to use to describe the ISA

`ifndef DEFS_ISA_V
`define DEFS_ISA_V

//------------------------------------------------------------------------
// Instructions
//------------------------------------------------------------------------

package ISA;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Pipe Types
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Here, we define types of pipes based on the subsections of the ISA
  // they can handle. This is in a one-how encoding, such that a pipe can
  // handle multiple subsets

  parameter p_num_pipe_types = 4

  typedef enum logic [p_num_pipe_types-1:0] {
    RVI_ARITH  = 4'b0001,
    RVI_MEM    = 4'b0010,
    RVI_JUMP   = 4'b0100,
    RVI_BRANCH = 4'b1000
  } rv_pipe_type;

endpackage

//------------------------------------------------------------------------
// Instructions
//------------------------------------------------------------------------
// These are preprocessor defines, to be used in casez statements

`define RVI_INST_ADD   32'b0000000_?????_?????_000_?????_0110011
`define RVI_INST_MUL   32'b0000001_?????_?????_000_?????_0110011
`define RVI_INST_ADDI  32'b???????_?????_?????_000_?????_0010011
`define RVI_INST_LW    32'b???????_?????_?????_010_?????_0000011
`define RVI_INST_SW    32'b???????_?????_?????_010_?????_0100011
`define RVI_INST_JAL   32'b???????_?????_?????_???_?????_1101111
`define RVI_INST_JALR  32'b???????_?????_?????_000_?????_1100111
`define RVI_INST_BEQ   32'b???????_?????_?????_000_?????_1100011

`endif  // DEFS_ISA_V
