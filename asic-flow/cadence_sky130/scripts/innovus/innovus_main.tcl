##################################################
## Reads environment variables passed by the Makefile
##################################################
set PRJ_ROOT        $::env(PRJ_ROOT)
set FLOW_ROOT       $::env(FLOW_ROOT)
set RTL_DIR         $::env(RTL_DIR)
set RTL_FILES       $::env(RTL_FILES)
set SCRIPTS_DIR     $::env(SCRIPTS_DIR)
set CONSTR_DIR      $::env(CONSTR_DIR)
set PNR_OUTPUTS_DIR $::env(PNR_OUTPUTS_DIR)
set PNR_REPORTS_DIR $::env(PNR_REPORTS_DIR)
set PNR_LOGS_DIR    $::env(PNR_LOGS_DIR)
set PDK_PATH        $::env(PDK_PATH)
set SYN_OUTPUTS_DIR $::env(SYN_OUTPUTS_DIR)
set PNR_INPUTS_DIR  $::env(PNR_INPUTS_DIR)

#################################################
# Paths — hardcoded to direct execution (without MakeFile)
#################################################
# set PRJ_ROOT        /home/mic63/ulisses.maffazioli/ci-expert/proj/rvx_mul
# set FLOW_ROOT       /home/mic63/ulisses.maffazioli/ci-expert/proj/rvx_mul/1_cadence_sky130_flow
# set RTL_DIR         $PRJ_ROOT/rtl
# set RTL_FILES       {}
# set SCRIPTS_DIR     $FLOW_ROOT/scripts
# set CONSTR_DIR      $FLOW_ROOT/constr
# set PNR_OUTPUTS_DIR $FLOW_ROOT/pnr/outputs
# set PNR_REPORTS_DIR $FLOW_ROOT/pnr/reports
# set PNR_LOGS_DIR    $FLOW_ROOT/pnr/logs
# set PDK_PATH        /home/mic63/ulisses.maffazioli/pdk/sky130_workspace/libs.ref
# set SYN_OUTPUTS_DIR $FLOW_ROOT/syn/outputs
# set PNR_INPUTS_DIR  $FLOW_ROOT/pnr/inputs

##################################################
## Carrega os scripts do flow
##################################################
source $SCRIPTS_DIR/innovus/1_setup.tcl
source $SCRIPTS_DIR/innovus/2_power_plan.tcl
source $SCRIPTS_DIR/innovus/3_place.tcl
source $SCRIPTS_DIR/innovus/4_cts.tcl
source $SCRIPTS_DIR/innovus/5_route.tcl
source $SCRIPTS_DIR/innovus/6_verif.tcl