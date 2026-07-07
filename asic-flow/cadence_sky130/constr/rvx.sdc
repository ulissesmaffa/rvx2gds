# Clock
create_clock -name clk -period 15 [get_ports clock]

# Ajusta clk para trapezoidal
set_clock_transition -rise 0.1 [get_clocks "clk"]
set_clock_transition -fall 0.1 [get_clocks "clk"]

# Incerteza do clock (300-400ps)
set_clock_uncertainty 0.3 [get_ports clock]

# ------------------------------------------------
# IO Constraints — baseado no clock de 10ns
# ------------------------------------------------
set IN_DELAY  1.5    ;# 15% de 10ns
set OUT_DELAY 1.5    ;# 15% de 10ns
set IN_TRANS  0.5    ;# 5% de 10ns
set OUT_LOAD  0.01   ;# 10fF — típico sky130

set all_in  [remove_from_collection [all_inputs]  [get_ports clock]]
set all_out [all_outputs]

set_input_delay      $IN_DELAY  -clock clk $all_in
set_output_delay     $OUT_DELAY -clock clk $all_out
set_input_transition $IN_TRANS  $all_in
set_load             $OUT_LOAD  $all_out