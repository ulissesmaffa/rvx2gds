// =============================================================================
// PADS_rvx — IO ring wrapper (sky130_ef_io)
//
// Rules followed in this netlist:
//   1. NO power pins (VCCD/VSSD/VDDIO/VSSIO) appear here.
//      PG tie-off is handled 100% via globalNetConnect in Innovus.
//   2. No supply1/supply0 — avoids creating local PAD_connection/VDD etc. nets
//      that duplicate global nets (VDD/GND/VDDR/GNDR from init_pwr/gnd_net).
//   3. TIE_HI_ESD / TIE_LO_ESD are pad OUTPUTS in the HV domain (VDDIO).
//      Each pad generates its own pair of tie wires, used for HLD_H_N,
//      ENABLE_H, and DM of the same pad — without crossing voltage domains.
//      (Remember to REMOVE the following lines from 1_setup.tcl:
//         globalNetConnect ... -type tiehi -pin TIE_HI_ESD ...
//         globalNetConnect ... -type tielo -pin TIE_LO_ESD ...
//       since the tie pins are now connected in the netlist.)
//   4. Power pads and corners: empty instantiation — they exist only physically.
// =============================================================================

module PADS_rvx (
    // --- Portas externas (PAD side) ---
    clock, reset_n, uart_rx, uart_tx, gpio_input,
    gpio_output_enable, gpio_output, sclk, mosi, miso, cs,
    i2c_sda_input, i2c_sda_output, i2c_scl_output,
    scan_en, scan_in, scan_out,

    // --- Portas internas (CORE side, sufixo _I) ---
    clock_I, reset_n_I, uart_rx_I, uart_tx_I, gpio_input_I,
    gpio_output_enable_I, gpio_output_I, sclk_I, mosi_I, miso_I, cs_I,
    i2c_sda_input_I, i2c_sda_output_I, i2c_scl_output_I,
    scan_en_I, scan_in_I, scan_out_I
);

// --- Portas externas (PAD side) ---
input  clock, reset_n, uart_rx, miso, i2c_sda_input, scan_en, scan_in;
input  [0:0] gpio_input;
output uart_tx, sclk, mosi, cs, i2c_sda_output, i2c_scl_output, scan_out;
output [0:0] gpio_output_enable, gpio_output;

// --- Portas internas (CORE side, sufixo _I) ---
output clock_I, reset_n_I, uart_rx_I, miso_I, i2c_sda_input_I, scan_en_I, scan_in_I;
output [0:0] gpio_input_I;
input  uart_tx_I, sclk_I, mosi_I, cs_I, i2c_sda_output_I, i2c_scl_output_I, scan_out_I;
input  [0:0] gpio_output_enable_I, gpio_output_I;

// --- Tie wires por pad (domínio HV, gerados pelo TIE_HI/LO_ESD de cada pad) ---
wire clock_hi,        clock_lo;
wire reset_n_hi,      reset_n_lo;
wire uart_rx_hi,      uart_rx_lo;
wire miso_hi,         miso_lo;
wire i2c_sda_in_hi,   i2c_sda_in_lo;
wire scan_en_hi,      scan_en_lo;
wire scan_in_hi,      scan_in_lo;
wire gpio_in_0_hi,    gpio_in_0_lo;
wire uart_tx_hi,      uart_tx_lo;
wire sclk_hi,         sclk_lo;
wire mosi_hi,         mosi_lo;
wire cs_hi,           cs_lo;
wire i2c_sda_out_hi,  i2c_sda_out_lo;
wire i2c_scl_out_hi,  i2c_scl_out_lo;
wire scan_out_hi,     scan_out_lo;
wire gpio_oe_0_hi,    gpio_oe_0_lo;
wire gpio_out_0_hi,   gpio_out_0_lo;

// =============================================================================
// Inputs PADs
// INP_DIS=0 (active input), OE_N=1 (disabled output), OUT=0 (tied)
// HLD_H_N=hi (sem hold), ENABLE_H=hi (enable pad)
// DM=110 (strong pull-up/pull-down, default input buffer)
// =============================================================================

sky130_ef_io__gpiov2_pad PAD_clock (
    .PAD(clock),        .IN(clock_I),       .OUT(1'b0),
    .INP_DIS(1'b0),     .OE_N(1'b1),
    .TIE_HI_ESD(clock_hi),  .TIE_LO_ESD(clock_lo),
    .HLD_H_N(clock_hi),     .ENABLE_H(clock_hi),
    .DM({clock_hi, clock_hi, clock_lo})
);

sky130_ef_io__gpiov2_pad PAD_reset_n (
    .PAD(reset_n),      .IN(reset_n_I),     .OUT(1'b0),
    .INP_DIS(1'b0),     .OE_N(1'b1),
    .TIE_HI_ESD(reset_n_hi),  .TIE_LO_ESD(reset_n_lo),
    .HLD_H_N(reset_n_hi),     .ENABLE_H(reset_n_hi),
    .DM({reset_n_hi, reset_n_hi, reset_n_lo})
);

sky130_ef_io__gpiov2_pad PAD_uart_rx (
    .PAD(uart_rx),      .IN(uart_rx_I),     .OUT(1'b0),
    .INP_DIS(1'b0),     .OE_N(1'b1),
    .TIE_HI_ESD(uart_rx_hi),  .TIE_LO_ESD(uart_rx_lo),
    .HLD_H_N(uart_rx_hi),     .ENABLE_H(uart_rx_hi),
    .DM({uart_rx_hi, uart_rx_hi, uart_rx_lo})
);

sky130_ef_io__gpiov2_pad PAD_miso (
    .PAD(miso),         .IN(miso_I),        .OUT(1'b0),
    .INP_DIS(1'b0),     .OE_N(1'b1),
    .TIE_HI_ESD(miso_hi),  .TIE_LO_ESD(miso_lo),
    .HLD_H_N(miso_hi),     .ENABLE_H(miso_hi),
    .DM({miso_hi, miso_hi, miso_lo})
);

sky130_ef_io__gpiov2_pad PAD_i2c_sda_in (
    .PAD(i2c_sda_input), .IN(i2c_sda_input_I), .OUT(1'b0),
    .INP_DIS(1'b0),      .OE_N(1'b1),
    .TIE_HI_ESD(i2c_sda_in_hi),  .TIE_LO_ESD(i2c_sda_in_lo),
    .HLD_H_N(i2c_sda_in_hi),     .ENABLE_H(i2c_sda_in_hi),
    .DM({i2c_sda_in_hi, i2c_sda_in_hi, i2c_sda_in_lo})
);

sky130_ef_io__gpiov2_pad PAD_scan_en (
    .PAD(scan_en),      .IN(scan_en_I),     .OUT(1'b0),
    .INP_DIS(1'b0),     .OE_N(1'b1),
    .TIE_HI_ESD(scan_en_hi),  .TIE_LO_ESD(scan_en_lo),
    .HLD_H_N(scan_en_hi),     .ENABLE_H(scan_en_hi),
    .DM({scan_en_hi, scan_en_hi, scan_en_lo})
);

sky130_ef_io__gpiov2_pad PAD_scan_in (
    .PAD(scan_in),      .IN(scan_in_I),     .OUT(1'b0),
    .INP_DIS(1'b0),     .OE_N(1'b1),
    .TIE_HI_ESD(scan_in_hi),  .TIE_LO_ESD(scan_in_lo),
    .HLD_H_N(scan_in_hi),     .ENABLE_H(scan_in_hi),
    .DM({scan_in_hi, scan_in_hi, scan_in_lo})
);

sky130_ef_io__gpiov2_pad PAD_gpio_in_0 (
    .PAD(gpio_input[0]),   .IN(gpio_input_I[0]), .OUT(1'b0),
    .INP_DIS(1'b0),        .OE_N(1'b1),
    .TIE_HI_ESD(gpio_in_0_hi),  .TIE_LO_ESD(gpio_in_0_lo),
    .HLD_H_N(gpio_in_0_hi),     .ENABLE_H(gpio_in_0_hi),
    .DM({gpio_in_0_hi, gpio_in_0_hi, gpio_in_0_lo})
);

// =============================================================================
// Outuputs PADs
// INP_DIS=1 (disabled input), OE_N=0 (enable output), IN open
// =============================================================================

sky130_ef_io__gpiov2_pad PAD_uart_tx (
    .PAD(uart_tx),      .IN(),              .OUT(uart_tx_I),
    .INP_DIS(1'b1),     .OE_N(1'b0),
    .TIE_HI_ESD(uart_tx_hi),  .TIE_LO_ESD(uart_tx_lo),
    .HLD_H_N(uart_tx_hi),     .ENABLE_H(uart_tx_hi),
    .DM({uart_tx_hi, uart_tx_hi, uart_tx_lo})
);

sky130_ef_io__gpiov2_pad PAD_sclk (
    .PAD(sclk),         .IN(),              .OUT(sclk_I),
    .INP_DIS(1'b1),     .OE_N(1'b0),
    .TIE_HI_ESD(sclk_hi),  .TIE_LO_ESD(sclk_lo),
    .HLD_H_N(sclk_hi),     .ENABLE_H(sclk_hi),
    .DM({sclk_hi, sclk_hi, sclk_lo})
);

sky130_ef_io__gpiov2_pad PAD_mosi (
    .PAD(mosi),         .IN(),              .OUT(mosi_I),
    .INP_DIS(1'b1),     .OE_N(1'b0),
    .TIE_HI_ESD(mosi_hi),  .TIE_LO_ESD(mosi_lo),
    .HLD_H_N(mosi_hi),     .ENABLE_H(mosi_hi),
    .DM({mosi_hi, mosi_hi, mosi_lo})
);

sky130_ef_io__gpiov2_pad PAD_cs (
    .PAD(cs),           .IN(),              .OUT(cs_I),
    .INP_DIS(1'b1),     .OE_N(1'b0),
    .TIE_HI_ESD(cs_hi),  .TIE_LO_ESD(cs_lo),
    .HLD_H_N(cs_hi),     .ENABLE_H(cs_hi),
    .DM({cs_hi, cs_hi, cs_lo})
);

sky130_ef_io__gpiov2_pad PAD_i2c_sda_out (
    .PAD(i2c_sda_output), .IN(),            .OUT(i2c_sda_output_I),
    .INP_DIS(1'b1),       .OE_N(1'b0),
    .TIE_HI_ESD(i2c_sda_out_hi),  .TIE_LO_ESD(i2c_sda_out_lo),
    .HLD_H_N(i2c_sda_out_hi),     .ENABLE_H(i2c_sda_out_hi),
    .DM({i2c_sda_out_hi, i2c_sda_out_hi, i2c_sda_out_lo})
);

sky130_ef_io__gpiov2_pad PAD_i2c_scl_out (
    .PAD(i2c_scl_output), .IN(),            .OUT(i2c_scl_output_I),
    .INP_DIS(1'b1),       .OE_N(1'b0),
    .TIE_HI_ESD(i2c_scl_out_hi),  .TIE_LO_ESD(i2c_scl_out_lo),
    .HLD_H_N(i2c_scl_out_hi),     .ENABLE_H(i2c_scl_out_hi),
    .DM({i2c_scl_out_hi, i2c_scl_out_hi, i2c_scl_out_lo})
);

sky130_ef_io__gpiov2_pad PAD_scan_out (
    .PAD(scan_out),     .IN(),              .OUT(scan_out_I),
    .INP_DIS(1'b1),     .OE_N(1'b0),
    .TIE_HI_ESD(scan_out_hi),  .TIE_LO_ESD(scan_out_lo),
    .HLD_H_N(scan_out_hi),     .ENABLE_H(scan_out_hi),
    .DM({scan_out_hi, scan_out_hi, scan_out_lo})
);

sky130_ef_io__gpiov2_pad PAD_gpio_oe_0 (
    .PAD(gpio_output_enable[0]), .IN(),     .OUT(gpio_output_enable_I[0]),
    .INP_DIS(1'b1),              .OE_N(1'b0),
    .TIE_HI_ESD(gpio_oe_0_hi),  .TIE_LO_ESD(gpio_oe_0_lo),
    .HLD_H_N(gpio_oe_0_hi),     .ENABLE_H(gpio_oe_0_hi),
    .DM({gpio_oe_0_hi, gpio_oe_0_hi, gpio_oe_0_lo})
);

sky130_ef_io__gpiov2_pad PAD_gpio_out_0 (
    .PAD(gpio_output[0]),        .IN(),     .OUT(gpio_output_I[0]),
    .INP_DIS(1'b1),              .OE_N(1'b0),
    .TIE_HI_ESD(gpio_out_0_hi),  .TIE_LO_ESD(gpio_out_0_lo),
    .HLD_H_N(gpio_out_0_hi),     .ENABLE_H(gpio_out_0_hi),
    .DM({gpio_out_0_hi, gpio_out_0_hi, gpio_out_0_lo})
);

// =============================================================================
// Power PADs (sky130_ef_io, variantes clamped — intern stripe
// globalNetConnect.
//   set _0 -> TOP side    |   set _1 -> RIGHT side
// =============================================================================

sky130_ef_io__vccd_lvc_pad  PAD_VDD_core_0 ();
sky130_ef_io__vssd_lvc_pad  PAD_GND_core_0 ();
sky130_ef_io__vddio_lvc_pad PAD_VDDR_io_0  ();
sky130_ef_io__vssio_lvc_pad PAD_GNDR_io_0  ();

sky130_ef_io__vccd_lvc_pad  PAD_VDD_core_1 ();
sky130_ef_io__vssd_lvc_pad  PAD_GND_core_1 ();
sky130_ef_io__vddio_lvc_pad PAD_VDDR_io_1  ();
sky130_ef_io__vssio_lvc_pad PAD_GNDR_io_1  ();

sky130_ef_io__vccd_lvc_pad  PAD_VDD_core_2 ();
sky130_ef_io__vssd_lvc_pad  PAD_GND_core_2 ();
sky130_ef_io__vddio_lvc_pad PAD_VDDR_io_2  ();
sky130_ef_io__vssio_lvc_pad PAD_GNDR_io_2  ();

sky130_ef_io__vccd_lvc_pad  PAD_VDD_core_3 ();
sky130_ef_io__vssd_lvc_pad  PAD_GND_core_3 ();
sky130_ef_io__vddio_lvc_pad PAD_VDDR_io_3  ();
sky130_ef_io__vssio_lvc_pad PAD_GNDR_io_3  ();

// =============================================================================
// Corners (sky130_ef_io__corner_pad, 200 x 204)
// =============================================================================

sky130_ef_io__corner_pad PAD_corner_ll ();
sky130_ef_io__corner_pad PAD_corner_lr ();
sky130_ef_io__corner_pad PAD_corner_ul ();
sky130_ef_io__corner_pad PAD_corner_ur ();

endmodule


// =============================================================================
// rvx_top — Top-level com IO ring
// =============================================================================

module rvx_top (
    clock, reset_n, uart_rx, uart_tx, gpio_input,
    gpio_output_enable, gpio_output, sclk, mosi, miso, cs,
    i2c_sda_input, i2c_sda_output, i2c_scl_output,
    scan_en, scan_in, scan_out
);

input  clock, reset_n, uart_rx, miso, i2c_sda_input, scan_en, scan_in;
input  [0:0] gpio_input;
output uart_tx, sclk, mosi, cs, i2c_sda_output, i2c_scl_output, scan_out;
output [0:0] gpio_output_enable, gpio_output;

wire clock_c, reset_n_c, uart_rx_c, miso_c, i2c_sda_input_c, scan_en_c, scan_in_c;
wire [0:0] gpio_input_c;
wire uart_tx_c, sclk_c, mosi_c, cs_c, i2c_sda_output_c, i2c_scl_output_c, scan_out_c;
wire [0:0] gpio_output_enable_c, gpio_output_c;

PADS_rvx PAD_connection (
    .clock(clock),                   .reset_n(reset_n),
    .uart_rx(uart_rx),               .uart_tx(uart_tx),
    .gpio_input(gpio_input),         .gpio_output_enable(gpio_output_enable),
    .gpio_output(gpio_output),       .sclk(sclk),
    .mosi(mosi),                     .miso(miso),
    .cs(cs),                         .i2c_sda_input(i2c_sda_input),
    .i2c_sda_output(i2c_sda_output), .i2c_scl_output(i2c_scl_output),
    .scan_en(scan_en),               .scan_in(scan_in),
    .scan_out(scan_out),
    .clock_I(clock_c),               .reset_n_I(reset_n_c),
    .uart_rx_I(uart_rx_c),           .uart_tx_I(uart_tx_c),
    .gpio_input_I(gpio_input_c),     .gpio_output_enable_I(gpio_output_enable_c),
    .gpio_output_I(gpio_output_c),   .sclk_I(sclk_c),
    .mosi_I(mosi_c),                 .miso_I(miso_c),
    .cs_I(cs_c),                     .i2c_sda_input_I(i2c_sda_input_c),
    .i2c_sda_output_I(i2c_sda_output_c), .i2c_scl_output_I(i2c_scl_output_c),
    .scan_en_I(scan_en_c),           .scan_in_I(scan_in_c),
    .scan_out_I(scan_out_c)
);

rvx rvx(
    .clock(clock_c),                 .reset_n(reset_n_c),
    .uart_rx(uart_rx_c),             .uart_tx(uart_tx_c),
    .gpio_input(gpio_input_c),       .gpio_output_enable(gpio_output_enable_c),
    .gpio_output(gpio_output_c),     .sclk(sclk_c),
    .mosi(mosi_c),                   .miso(miso_c),
    .cs(cs_c),                       .i2c_sda_input(i2c_sda_input_c),
    .i2c_sda_output(i2c_sda_output_c), .i2c_scl_output(i2c_scl_output_c),
    .scan_en(scan_en_c),             .scan_in(scan_in_c),
    .scan_out(scan_out_c)
);

endmodule