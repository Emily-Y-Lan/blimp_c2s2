// ==========================================================================
// MemSubSys.v
// ==========================================================================
// The top-level memory subsystem, including all peripherals

`ifndef FPGA_MEMSUBSYS_V
`define FPGA_MEMSUBSYS_V

`include "fpga/FPGAMem.v"
`include "fpga/MemXBar.v"
`include "fpga/PeripheralMemServer.v"
`include "fpga/net/MemNetReq.v"
`include "fpga/net/MemNetResp.v"
`include "fpga/spi/SPIMemClient.v"
`include "intf/MemIntf.v"

module MemSubSys #(
  parameter p_opaq_bits = 8
)(
  input  logic clk,
  input  logic rst,
  input  logic mem_clk, // >= 3x faster than clk
  
  // ---------------------------------------------------------------------
  // Memory Interfaces
  // ---------------------------------------------------------------------

  MemIntf.server imem,
  MemIntf.server dmem,

  // ---------------------------------------------------------------------
  // SPI Interface
  // ---------------------------------------------------------------------

  input  logic cs,
  output logic miso,
  input  logic mosi,
  input  logic sclk,

  // ---------------------------------------------------------------------
  // PS2 Interface
  // ---------------------------------------------------------------------

  input  logic PS2_CLK,
  input  logic PS2_DATA,

  // ---------------------------------------------------------------------
  // VGA Interface
  // ---------------------------------------------------------------------

  output  logic [3:0] VGA_R,
  output  logic [3:0] VGA_G,
  output  logic [3:0] VGA_B,
  output  logic       VGA_HS,
  output  logic       VGA_VS,
  output  logic       VGA_BLANK_N,
  output  logic       VGA_SYNC_N
);

  // ---------------------------------------------------------------------
  // SPI Memory Client
  // ---------------------------------------------------------------------

  MemIntf #(
    .p_opaq_bits (p_opaq_bits)
  ) spi_mem_client();

  logic go;

  SPIMemClient #(
    .p_opaq_bits (p_opaq_bits)
  ) spi_client (
    .mem (spi_mem_client),
    .*
  );

  // ---------------------------------------------------------------------
  // Memory Crossbar
  // ---------------------------------------------------------------------

  MemNetReq  #( p_opaq_bits ) bram_req();
  MemNetReq  #( p_opaq_bits ) peripheral_req();
  MemNetResp #( p_opaq_bits ) bram_resp();
  MemNetResp #( p_opaq_bits ) peripheral_resp();

  MemXBar #(
    .p_opaq_bits (p_opaq_bits)
  ) xbar (
    .spi (spi_mem_client),
    .*
  );

  // ---------------------------------------------------------------------
  // M10K Memory
  // ---------------------------------------------------------------------

  FPGAMem #(
    .p_opaq_bits (p_opaq_bits)
  ) bram (
    .req  (bram_req),
    .resp (bram_resp),
    .*
  );

  // ---------------------------------------------------------------------
  // Peripherals
  // ---------------------------------------------------------------------

  PeripheralMemServer #(
    .p_opaq_bits (p_opaq_bits)
  ) peripherals (
    .req  (peripheral_req),
    .resp (peripheral_resp),
    .*
  );

endmodule

`endif // FPGA_MEMSUBSYS_V
