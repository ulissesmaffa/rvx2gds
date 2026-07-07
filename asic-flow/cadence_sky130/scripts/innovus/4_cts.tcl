# Fixes the CLK bug.
set_interactive_constraint_modes [all_constraint_modes -active]
create_clock -name clk -period 15 [get_pins PAD_connection/PAD_clock/IN]
set_interactive_constraint_modes {}
report_clocks

# Start script
timeDesign -postRoute

add_ndr \
  -name CTS_2W1S \
  -width_multiplier {met2:met3 2.0} \
  -spacing_multiplier {met2:met3 2.0}

create_route_type \
  -name top_rule \
  -non_default_rule CTS_2W1S \
  -top_preferred_layer met3 \
  -bottom_preferred_layer met3

create_route_type \
  -name trunk_rule \
  -non_default_rule CTS_2W1S \
  -top_preferred_layer met3 \
  -bottom_preferred_layer met2

set_ccopt_property \
  -net_type trunk route_type trunk_rule

set_ccopt_property \
  -net_type top route_type top_rule

set_ccopt_property buffer_cells   {sky130_fd_sc_hd__clkbuf_1 sky130_fd_sc_hd__clkbuf_2 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8 sky130_fd_sc_hd__clkbuf_16}
set_ccopt_property inverter_cells {sky130_fd_sc_hd__clkinv_1 sky130_fd_sc_hd__clkinv_2 sky130_fd_sc_hd__clkinv_4 sky130_fd_sc_hd__clkinv_8 sky130_fd_sc_hd__clkinv_16}

set_ccopt_property routing_top_min_fanout 10000

optDesign -preCTS
ccopt_design -outDir clk_report
optDesign -postCTSf

saveDesign $PNR_OUTPUTS_DIR/rvx_top_cts.enc