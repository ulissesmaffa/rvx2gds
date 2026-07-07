######################################################
## Load Design
######################################################
read_hdl    $RTL_LIST
elaborate   $DESIGN

init_design
time_info init_design
check_design -unresolved

####################################################################
## Constraints Setup
####################################################################
# Use when MMMC is not performed.
# read_sdc $CONSTR/${DESIGN}.sdc

####################################################################
## DFT Setup
####################################################################
set_db dft_scan_style muxed_scan
set_db dft_identify_top_level_test_clocks true
set_db dft_identify_test_signals true

define_dft shift_enable -name scan_en -active high -create_port scan_en
define_dft scan_chain -name chain1 -sdi scan_in -sdo scan_out -create_ports -shift_enable scan_en
set_compatible_test_clocks -all

####################################################################
## Synthesis
####################################################################
# Síntese genérica (tecnologia independente)
syn_generic
write_snapshot -outdir $SYN_REPORTS_DIR -tag 1_generic
report_summary -directory $SYN_REPORTS_DIR
 
# Mapeamento para células da biblioteca
syn_map
write_snapshot -outdir $SYN_REPORTS_DIR -tag 2_mapped
report_summary -directory $SYN_REPORTS_DIR

# DFT: Scan-Chain insertion 
check_dft_rules > $SYN_REPORTS_DIR/_DFT_${DESIGN}_check_dft_rules.rpt
convert_to_scan
connect_scan_chains $DESIGN -auto_create_chain

# Otimização incremental
syn_opt
write_snapshot -outdir $SYN_REPORTS_DIR -tag 3_final
report_summary -directory $SYN_REPORTS_DIR

####################################################################
## Reports MMMC
####################################################################
foreach { view label } {
    worst_view   ss
    nominal_view tt
    best_view    ff
} {
    set_analysis_view -setup $view -hold $view
    write_snapshot  -outdir $SYN_REPORTS_DIR -tag mmmc_$label
    report_summary  -directory $SYN_REPORTS_DIR

    puts "=== Reports gerados: corner $label ($view) ==="
}

# Restaura: setup=worst, hold=best
set_analysis_view -setup worst_view -hold best_view

####################################################################
## Reports
####################################################################
file mkdir $SYN_REPORTS_DIR/custom

report_gates                     > $SYN_REPORTS_DIR/custom/${DESIGN}_gates.rpt
report_area                      > $SYN_REPORTS_DIR/custom/${DESIGN}_area.rpt
report_timing                    > $SYN_REPORTS_DIR/custom/${DESIGN}_timing.rpt
report_power                     > $SYN_REPORTS_DIR/custom/${DESIGN}_power.rpt
report_messages                  > $SYN_REPORTS_DIR/custom/${DESIGN}_messages.rpt
report_hierarchy                 > $SYN_REPORTS_DIR/custom/${DESIGN}_hierarchy.rpt
report_port [get_db ports .name] > $SYN_REPORTS_DIR/custom/${DESIGN}_ports.rpt

report_scan_registers > $SYN_REPORTS_DIR/custom/DFT_${DESIGN}_scan_registers.rpt
report_scan_setup     > $SYN_REPORTS_DIR/custom/DFT_${DESIGN}_scan_setup.rpt
report_dft_violations > $SYN_REPORTS_DIR/custom/DFT_${DESIGN}_dft_violations.rpt
report_scan_chains    > $SYN_REPORTS_DIR/custom/DFT_${DESIGN}_scan_chains.rpt

####################################################################
## Outputs
####################################################################
write_hdl  > $SYN_OUTPUTS_DIR/${DESIGN}_netlist.v

write_sdc -view worst_view   > $SYN_OUTPUTS_DIR/${DESIGN}_worst.sdc
write_sdc -view nominal_view > $SYN_OUTPUTS_DIR/${DESIGN}_nominal.sdc
write_sdc -view best_view    > $SYN_OUTPUTS_DIR/${DESIGN}_best.sdc

write_mmmc -dir $SYN_OUTPUTS_DIR -prefix ${DESIGN}

write_sdf -timescale ns -nonegchecks -recrem split \
          -edges check_edge -setuphold split \
          > $SYN_OUTPUTS_DIR/${DESIGN}_delays.sdf

write_scandef > $SYN_OUTPUTS_DIR/${DESIGN}_scan_chain.def

write_db      $SYN_OUTPUTS_DIR/${DESIGN}_post_syn.db

write_db -common -legacy -all_root_attributes $SYN_OUTPUTS_DIR/innovus

puts "============================"
puts "Synthesis Finished ........."
puts "============================"