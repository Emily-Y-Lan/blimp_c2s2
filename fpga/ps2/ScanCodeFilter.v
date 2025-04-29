//========================================================================
// ScanCodeFilter.v
//========================================================================
// A filter for turning scan codes into ASCII
//
// Here, we emit the correct ASCII for many visible keys (see scan codes)
// on a standard QWERTY keyboard according to scan set 2, when they are
// released. The keypad isn't currently supported, but could be trivially
// added.
//
// Capitalization is supported through the shift keys ONLY (not caps lock,
// due to different handling of non-alphabetic keys)

`ifndef FPGA_PS2_SCANCODEFILTER_V
`define FPGA_PS2_SCANCODEFILTER_V

module ScanCodeFilter(
  input  logic clk,
  input  logic rst,

  // ---------------------------------------------------------------------
  // Scan Code Input
  // ---------------------------------------------------------------------

  input  logic [7:0] scan_code,
  input  logic       scan_code_val,

  // ---------------------------------------------------------------------
  // ASCII Output
  // ---------------------------------------------------------------------

  output logic [7:0] ascii,
  output logic       ascii_val
);

  // ---------------------------------------------------------------------
  // Buffer Inputs
  // ---------------------------------------------------------------------

  logic [7:0] sc;
  logic       sc_val;

  always_ff @( posedge clk ) begin
    if( rst ) begin
      sc     <= 8'b0;
      sc_val <= 1'b0;
    end else begin
      sc     <= scan_code;
      sc_val <= scan_code_val;
    end
  end
  
  // ---------------------------------------------------------------------
  // Scan Codes
  // ---------------------------------------------------------------------

  localparam SC_BREAK = 8'hF0;

  localparam SC_A = 8'h1C;
  localparam SC_B = 8'h32;
  localparam SC_C = 8'h21;
  localparam SC_D = 8'h23;
  localparam SC_E = 8'h24;
  localparam SC_F = 8'h2B;
  localparam SC_G = 8'h34;
  localparam SC_H = 8'h33;
  localparam SC_I = 8'h43;
  localparam SC_J = 8'h3B;
  localparam SC_K = 8'h42;
  localparam SC_L = 8'h4B;
  localparam SC_M = 8'h3A;
  localparam SC_N = 8'h31;
  localparam SC_O = 8'h44;
  localparam SC_P = 8'h4D;
  localparam SC_Q = 8'h15;
  localparam SC_R = 8'h2D;
  localparam SC_S = 8'h1B;
  localparam SC_T = 8'h2C;
  localparam SC_U = 8'h3C;
  localparam SC_V = 8'h2A;
  localparam SC_W = 8'h1D;
  localparam SC_X = 8'h22;
  localparam SC_Y = 8'h35;
  localparam SC_Z = 8'h1A;

  localparam SC_0 = 8'h45;
  localparam SC_1 = 8'h16;
  localparam SC_2 = 8'h1E;
  localparam SC_3 = 8'h26;
  localparam SC_4 = 8'h25;
  localparam SC_5 = 8'h2E;
  localparam SC_6 = 8'h36;
  localparam SC_7 = 8'h3D;
  localparam SC_8 = 8'h3E;
  localparam SC_9 = 8'h46;

  localparam SC_LSHIFT = 8'h12;
  localparam SC_RSHIFT = 8'h59;
  localparam SC_TAB    = 8'h0D;
  localparam SC_SLASH  = 8'h4A;
  localparam SC_BSLASH = 8'h5D;
  localparam SC_BRACK  = 8'h54;
  localparam SC_EBRACK = 8'h5B;
  localparam SC_SCOLON = 8'h4C;
  localparam SC_APOST  = 8'h52;
  localparam SC_BTICK  = 8'h0E;
  localparam SC_DASH   = 8'h4E;
  localparam SC_EQUAL  = 8'h55;
  localparam SC_ENTER  = 8'h5A;
  localparam SC_COMMA  = 8'h41;
  localparam SC_PERD   = 8'h49;
  localparam SC_BACK   = 8'h66;
  localparam SC_SPACE  = 8'h29;
  localparam SC_ESC    = 8'h76;

  // ---------------------------------------------------------------------
  // Use break to track releases
  // ---------------------------------------------------------------------

  logic released;
  always_ff @( posedge clk ) begin
    if( rst )
      released <= 1'b0;
    else if( sc_val & ( sc == SC_BREAK) )
      released <= 1'b1;
    else if( sc_val )
      released <= 1'b0;
  end

  // ---------------------------------------------------------------------
  // Keep track of shift
  // ---------------------------------------------------------------------

  logic shifted;
  always_ff @( posedge clk ) begin
    if( rst )
      shifted <= 1'b0;
    else if( sc_val & (
      ( sc == SC_LSHIFT ) |
      ( sc == SC_RSHIFT )
    ) ) begin
      if( released )
        shifted <= 1'b0;
      else
        shifted <= 1'b1;
    end
  end

  // ---------------------------------------------------------------------
  // ASCII Characters
  // ---------------------------------------------------------------------

  localparam A_A = 8'h41;
  localparam A_B = 8'h42;
  localparam A_C = 8'h43;
  localparam A_D = 8'h44;
  localparam A_E = 8'h45;
  localparam A_F = 8'h46;
  localparam A_G = 8'h47;
  localparam A_H = 8'h48;
  localparam A_I = 8'h49;
  localparam A_J = 8'h4A;
  localparam A_K = 8'h4B;
  localparam A_L = 8'h4C;
  localparam A_M = 8'h4D;
  localparam A_N = 8'h4E;
  localparam A_O = 8'h4F;
  localparam A_P = 8'h50;
  localparam A_Q = 8'h51;
  localparam A_R = 8'h52;
  localparam A_S = 8'h53;
  localparam A_T = 8'h54;
  localparam A_U = 8'h55;
  localparam A_V = 8'h56;
  localparam A_W = 8'h57;
  localparam A_X = 8'h58;
  localparam A_Y = 8'h59;
  localparam A_Z = 8'h5A;

  localparam A_LCA = 8'h61;
  localparam A_LCB = 8'h62;
  localparam A_LCC = 8'h63;
  localparam A_LCD = 8'h64;
  localparam A_LCE = 8'h65;
  localparam A_LCF = 8'h66;
  localparam A_LCG = 8'h67;
  localparam A_LCH = 8'h68;
  localparam A_LCI = 8'h69;
  localparam A_LCJ = 8'h6A;
  localparam A_LCK = 8'h6B;
  localparam A_LCL = 8'h6C;
  localparam A_LCM = 8'h6D;
  localparam A_LCN = 8'h6E;
  localparam A_LCO = 8'h6F;
  localparam A_LCP = 8'h70;
  localparam A_LCQ = 8'h71;
  localparam A_LCR = 8'h72;
  localparam A_LCS = 8'h73;
  localparam A_LCT = 8'h74;
  localparam A_LCU = 8'h75;
  localparam A_LCV = 8'h76;
  localparam A_LCW = 8'h77;
  localparam A_LCX = 8'h78;
  localparam A_LCY = 8'h79;
  localparam A_LCZ = 8'h7A;

  localparam A_SPACE  = 8'h20;
  localparam A_EXCL   = 8'h21;
  localparam A_QUOTE  = 8'h22;
  localparam A_POUND  = 8'h23;
  localparam A_DOLLR  = 8'h24;
  localparam A_PECNT  = 8'h25;
  localparam A_AMPSD  = 8'h26;
  localparam A_APOST  = 8'h27;
  localparam A_PAREN  = 8'h28;
  localparam A_EPAREN = 8'h29;
  localparam A_STAR   = 8'h2A;
  localparam A_PLUS   = 8'h2B;
  localparam A_COMMA  = 8'h2C;
  localparam A_DASH   = 8'h2D;
  localparam A_PERD   = 8'h2E;
  localparam A_SLASH  = 8'h2F;

  localparam A_0 = 8'h30;
  localparam A_1 = 8'h31;
  localparam A_2 = 8'h32;
  localparam A_3 = 8'h33;
  localparam A_4 = 8'h34;
  localparam A_5 = 8'h35;
  localparam A_6 = 8'h36;
  localparam A_7 = 8'h37;
  localparam A_8 = 8'h38;
  localparam A_9 = 8'h39;

  localparam A_COLON  = 8'h3A;
  localparam A_SCOLON = 8'h3B;
  localparam A_LT     = 8'h3C;
  localparam A_EQUAL  = 8'h3D;
  localparam A_GT     = 8'h3E;
  localparam A_QUEST  = 8'h3F;
  localparam A_AT     = 8'h40;

  localparam A_BRACK  = 8'h5B;
  localparam A_BSLASH = 8'h5C;
  localparam A_EBRACK = 8'h5D;
  localparam A_CARET  = 8'h5E;
  localparam A_UNDSC  = 8'h5F;
  localparam A_BTICK  = 8'h60;

  localparam A_BRACE  = 8'h7B;
  localparam A_PIPE   = 8'h7C;
  localparam A_EBRACE = 8'h7D;
  localparam A_TILDE  = 8'h7E;

  localparam A_ESC    = 8'h1B;
  localparam A_NEWLN  = 8'h0A;
  localparam A_DEL    = 8'h7F;

  // ---------------------------------------------------------------------
  // Assign characters based on shifted or not
  // ---------------------------------------------------------------------

  task out(
    input logic       val,
    input logic [7:0] shift_char,
    input logic [7:0] unshift_char
  );
    ascii_val = val & released;
    if( shifted )
      ascii = shift_char;
    else
      ascii = unshift_char;
  endtask

  always_comb begin
    case( sc )     // val     shift     unshift
      SC_A:      out( sc_val, A_A,      A_LCA    );
      SC_B:      out( sc_val, A_B,      A_LCB    );
      SC_C:      out( sc_val, A_C,      A_LCC    );
      SC_D:      out( sc_val, A_D,      A_LCD    );
      SC_E:      out( sc_val, A_E,      A_LCE    );
      SC_F:      out( sc_val, A_F,      A_LCF    );
      SC_G:      out( sc_val, A_G,      A_LCG    );
      SC_H:      out( sc_val, A_H,      A_LCH    );
      SC_I:      out( sc_val, A_I,      A_LCI    );
      SC_J:      out( sc_val, A_J,      A_LCJ    );
      SC_K:      out( sc_val, A_K,      A_LCK    );
      SC_L:      out( sc_val, A_L,      A_LCL    );
      SC_M:      out( sc_val, A_M,      A_LCM    );
      SC_N:      out( sc_val, A_N,      A_LCN    );
      SC_O:      out( sc_val, A_O,      A_LCO    );
      SC_P:      out( sc_val, A_P,      A_LCP    );
      SC_Q:      out( sc_val, A_Q,      A_LCQ    );
      SC_R:      out( sc_val, A_R,      A_LCR    );
      SC_S:      out( sc_val, A_S,      A_LCS    );
      SC_T:      out( sc_val, A_T,      A_LCT    );
      SC_U:      out( sc_val, A_U,      A_LCU    );
      SC_V:      out( sc_val, A_V,      A_LCV    );
      SC_W:      out( sc_val, A_W,      A_LCW    );
      SC_X:      out( sc_val, A_X,      A_LCX    );
      SC_Y:      out( sc_val, A_Y,      A_LCY    );
      SC_Z:      out( sc_val, A_Z,      A_LCZ    );
      SC_0:      out( sc_val, A_EPAREN, A_0      );
      SC_1:      out( sc_val, A_EXCL,   A_1      );
      SC_2:      out( sc_val, A_AT,     A_2      );
      SC_3:      out( sc_val, A_POUND,  A_3      );
      SC_4:      out( sc_val, A_DOLLR,  A_4      );
      SC_5:      out( sc_val, A_PECNT,  A_5      );
      SC_6:      out( sc_val, A_CARET,  A_6      );
      SC_7:      out( sc_val, A_AMPSD,  A_7      );
      SC_8:      out( sc_val, A_STAR,   A_8      );
      SC_9:      out( sc_val, A_PAREN,  A_9      );
      SC_TAB:    out( sc_val, A_SPACE,  A_SPACE  ); // Maybe fix later
      SC_SLASH:  out( sc_val, A_QUEST,  A_SLASH  );
      SC_BSLASH: out( sc_val, A_PIPE,   A_BSLASH );
      SC_BRACK:  out( sc_val, A_BRACE,  A_BRACK  );
      SC_EBRACK: out( sc_val, A_EBRACE, A_EBRACK );
      SC_SCOLON: out( sc_val, A_COLON,  A_SCOLON );
      SC_APOST:  out( sc_val, A_QUOTE,  A_APOST  );
      SC_BTICK:  out( sc_val, A_TILDE,  A_BTICK  );
      SC_DASH:   out( sc_val, A_UNDSC,  A_DASH   );
      SC_EQUAL:  out( sc_val, A_PLUS,   A_EQUAL  );
      SC_ENTER:  out( sc_val, A_NEWLN,  A_NEWLN  );
      SC_COMMA:  out( sc_val, A_LT,     A_COMMA  );
      SC_PERD:   out( sc_val, A_GT,     A_PERD   );
      SC_BACK:   out( sc_val, A_DEL,    A_DEL    );
      SC_SPACE:  out( sc_val, A_SPACE,  A_SPACE  );
      SC_ESC:    out( sc_val, A_ESC,    A_ESC    );
      default:   out( 0,      'x,       'x       );
    endcase
  end
endmodule

`endif // FPGA_PS2_SCANCODEFILTER_V