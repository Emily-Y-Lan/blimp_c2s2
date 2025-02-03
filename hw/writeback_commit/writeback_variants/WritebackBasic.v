//========================================================================
// WritebackBasic.v
//========================================================================
// A basic writeback unit that writes back one result at a time, with
// no separate comit

`ifndef HW_WRITEBACK_WRITEBACK_VARIANTS_BASIC_V
`define HW_WRITEBACK_WRITEBACK_VARIANTS_BASIC_V

`include "hw/common/RRArb.v"
`include "intf/CommitNotif.v"
`include "intf/WritebackNotif.v"
`include "intf/X__WIntf.v"

module WritebackBasic #(
  parameter p_num_pipes = 1
) (
  input  logic clk,
  input  logic rst,

  //----------------------------------------------------------------------
  // X <-> W Interface
  //----------------------------------------------------------------------

  X__WIntf.W_intf Ex [p_num_pipes-1:0],

  //----------------------------------------------------------------------
  // Writeback Interface
  //----------------------------------------------------------------------

  WritebackNotif.pub writeback,

  //----------------------------------------------------------------------
  // Commit Interface
  //----------------------------------------------------------------------

  CommitNotif.pub commit
);

  localparam p_data_bits = writeback.p_data_bits;

  //----------------------------------------------------------------------
  // Select which pipe to get from
  //----------------------------------------------------------------------

  logic             [4:0] Ex_waddr [p_num_pipes-1:0];
  logic [p_data_bits-1:0] Ex_wdata [p_num_pipes-1:0];
  logic                   Ex_wen   [p_num_pipes-1:0];
  logic                   Ex_val   [p_num_pipes-1:0];
  logic                   Ex_rdy   [p_num_pipes-1:0];

  genvar i;
  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin
      assign Ex_waddr[i] = Ex[i].waddr;
      assign Ex_wdata[i] = Ex[i].wdata;
      assign Ex_wen[i]   = Ex[i].wen;
      assign Ex_val[i]   = Ex[i].val;
      assign Ex[i].rdy   = Ex_rdy[i];
    end
  endgenerate

  logic [p_num_pipes-1:0] Ex_val_packed;
  logic [p_num_pipes-1:0] Ex_gnt_packed;
  logic                   Ex_gnt [p_num_pipes-1:0];

  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin
      assign Ex_val_packed[i] = Ex_val[i];
      assign Ex_gnt[i] = Ex_gnt_packed[i];
    end
  endgenerate

  RRArb #(p_num_pipes) ex_arb (
    .clk (clk),
    .rst (rst),
    .req (Ex_val_packed),
    .gnt (Ex_gnt_packed)
  );

  logic             [4:0] Ex_waddr_masked [p_num_pipes-1:0];
  logic [p_data_bits-1:0] Ex_wdata_masked [p_num_pipes-1:0];
  logic                   Ex_wen_masked   [p_num_pipes-1:0];
  logic                   Ex_val_masked   [p_num_pipes-1:0];

  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin
      assign Ex_waddr_masked[i] = Ex_waddr[i] & {5{Ex_gnt[i]}};
      assign Ex_wdata_masked[i] = Ex_wdata[i] & {p_data_bits{Ex_gnt[i]}};
      assign Ex_wen_masked[i]   = Ex_wen[i]   & Ex_gnt[i];
      assign Ex_val_masked[i]   = Ex_val[i]   & Ex_gnt[i];
    end
  endgenerate

  logic             [4:0] Ex_waddr_sel;
  logic [p_data_bits-1:0] Ex_wdata_sel;
  logic                   Ex_wen_sel;
  logic                   Ex_val_sel;

  assign Ex_waddr_sel = Ex_waddr_masked.or();
  assign Ex_wdata_sel = Ex_wdata_masked.or();
  assign Ex_wen_sel   = Ex_wen_masked.or();
  assign Ex_val_sel   = Ex_val_masked.or();

  // No backpressure - always ready
  generate
    for( i = 0; i < p_num_pipes; i = i + 1 ) begin
      assign Ex_rdy[i] = Ex_gnt[i];
    end
  endgenerate
  
  //----------------------------------------------------------------------
  // Pipeline registers for X interface
  //----------------------------------------------------------------------

  typedef struct packed {
    logic             [4:0] waddr;
    logic [p_data_bits-1:0] wdata;
    logic                   wen;
  } X_input;

  X_input X_reg;
  X_input X_reg_next;

  always_ff @( posedge clk ) begin
    if ( rst )
      X_reg <= '{ waddr: 'x, wdata: 'x, wen: 1'b0 };
    else
      X_reg <= X_reg_next;
  end

  always_comb begin
    if ( Ex_val_sel )
      X_reg_next = '{ waddr: Ex_waddr_sel, wdata: Ex_wdata_sel, wen: Ex_wen_sel };
    else
      X_reg_next = '{ waddr: 'x, wdata: 'x, wen: 1'b0 };
  end

  assign writeback.waddr = X_reg.waddr;
  assign writeback.wdata = X_reg.wdata;
  assign writeback.wen   = X_reg.wen;

  //----------------------------------------------------------------------
  // Unused commit interface
  //----------------------------------------------------------------------

  assign commit.seq_num = 'x;
  assign commit.waddr   = 'x;
  assign commit.wdata   = 'x;
  assign commit.wen     = 'x;
  assign commit.val     = 1'b0;

  //----------------------------------------------------------------------
  // Linetracing
  //----------------------------------------------------------------------

`ifndef SYNTHESIS
  function int ceil_div_4( int val );
    return (val / 4) + (val % 4);
  endfunction

  // verilator lint_off UNUSEDSIGNAL
  string trace;
  int str_len;
  // verilator lint_on UNUSEDSIGNAL

  assign str_len = ceil_div_4( 5 )     + 1 +  // addr
                   ceil_div_4( p_data_bits ); // data
  
  always_comb begin
    if( X_reg.wen )
      trace = $sformatf("%h:%h", X_reg.waddr, X_reg.wdata );
    else
      trace = {str_len{" "}};
  end
`endif

endmodule

`endif // HW_DECODE_DECODE_VARIANTS_BASIC_V
