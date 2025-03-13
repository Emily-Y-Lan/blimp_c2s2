//========================================================================
// RegfilePending.v
//========================================================================
// A parametrized register file that tracks which registers are pending

`ifndef HW_DECODE_REGFILEPENDING_V
`define HW_DECODE_REGFILEPENDING_V

`include "hw/decode_issue/Regfile.v"

module RegfilePending #(
  parameter type t_entry = logic [31:0],
  parameter p_num_regs   = 32,

  parameter p_addr_bits  = $clog2(p_num_regs)
) (
  input  logic clk,
  input  logic rst,

  //----------------------------------------------------------------------
  // Read Interface
  //----------------------------------------------------------------------

  input  logic [p_addr_bits-1:0] raddr   [1:0],
  output t_entry                 rdata   [1:0],

  // Include checking whether the instruction's write address is pending
  input  logic [p_addr_bits-1:0] check_addr,

  //----------------------------------------------------------------------
  // Write Interface
  //----------------------------------------------------------------------

  input  logic [p_addr_bits-1:0] waddr,
  input  t_entry                 wdata,
  input  logic                   wen,

  //----------------------------------------------------------------------
  // Pending Interface
  //----------------------------------------------------------------------

  input  logic [p_addr_bits-1:0] pending_set_addr,
  input  logic                   pending_set_val,
  output logic                   read_pending [1:0],
  output logic                   check_addr_pending
);

  //----------------------------------------------------------------------
  // Base Register File
  //----------------------------------------------------------------------

  Regfile #(
    .t_entry    (t_entry),
    .p_num_regs (p_num_regs)
  ) registers (
    .*
  );

  //----------------------------------------------------------------------
  // Forwarding Logic
  //----------------------------------------------------------------------

  logic forward_write [1:0];
  always_comb begin
    forward_write[0] = wen & ( raddr[0] == waddr );
    forward_write[1] = wen & ( raddr[1] == waddr );
  end

  //----------------------------------------------------------------------
  // Pending Bits
  //----------------------------------------------------------------------

  logic pending_regs [p_num_regs-1:1];

  genvar i;
  generate
    for( i = 1; i < p_num_regs; i = i + 1 ) begin
      always_ff @( posedge clk ) begin
        if ( rst )
          pending_regs[i] <= 1'b0;
        else if ( pending_set_val & ( pending_set_addr == i ))
          pending_regs[i] <= 1'b1;
        else if ( wen & ( waddr == i ))
          pending_regs[i] <= 1'b0;
      end
    end
  endgenerate

  always_comb begin
    if ( raddr[0] == '0 )
      read_pending[0] = 1'b0;
    else
      read_pending[0] = !forward_write[0] & pending_regs[raddr[0]];

    if ( raddr[1] == '0 )
      read_pending[1] = 1'b0;
    else
      read_pending[1] = !forward_write[1] & pending_regs[raddr[1]];
  end

  assign check_addr_pending = pending_regs[check_addr] &
                              (check_addr != waddr)    &
                              (check_addr != '0);

endmodule

`endif // HW_DECODE_REGFILE_V
