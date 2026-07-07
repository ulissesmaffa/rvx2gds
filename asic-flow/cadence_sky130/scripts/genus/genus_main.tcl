##################################################
## Reads environment variables passed by the Makefile
##################################################
set PRJ_ROOT        $::env(PRJ_ROOT)
set FLOW_ROOT       $::env(FLOW_ROOT)
set RTL_DIR         $::env(RTL_DIR)
set RTL_FILES       $::env(RTL_FILES)
set SCRIPTS_DIR     $::env(SCRIPTS_DIR)
set CONSTR_DIR      $::env(CONSTR_DIR)
set SYN_OUTPUTS_DIR $::env(SYN_OUTPUTS_DIR)
set SYN_REPORTS_DIR $::env(SYN_REPORTS_DIR)
set SYN_LOGS_DIR    $::env(SYN_LOGS_DIR)
set PDK_PATH        $::env(PDK_PATH)

##################################################
## Loads the flow scripts
##################################################
source $SCRIPTS_DIR/genus/setup.tcl
source $SCRIPTS_DIR/genus/syn.tcl
