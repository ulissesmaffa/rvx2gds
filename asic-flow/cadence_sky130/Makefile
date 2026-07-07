########################################
# Roots
########################################
PRJ_ROOT    := $(abspath ..)
FLOW_ROOT   := $(abspath .)

########################################
# Dirs
########################################
RTL_DIR     := $(PRJ_ROOT)/rtl
TB_DIR      := $(PRJ_ROOT)/tests/testbenches
SCRIPTS_DIR := $(FLOW_ROOT)/scripts
CONSTR_DIR  := $(FLOW_ROOT)/constr

SYN_WORK_DIR    := $(FLOW_ROOT)/syn/work
SYN_LOGS_DIR    := $(FLOW_ROOT)/syn/logs
SYN_OUTPUTS_DIR := $(FLOW_ROOT)/syn/outputs
SYN_REPORTS_DIR := $(FLOW_ROOT)/syn/reports

PNR_WORK_DIR    := $(FLOW_ROOT)/pnr/work
PNR_LOGS_DIR    := $(FLOW_ROOT)/pnr/logs
PNR_OUTPUTS_DIR := $(FLOW_ROOT)/pnr/outputs
PNR_REPORTS_DIR := $(FLOW_ROOT)/pnr/reports
PNR_INPUTS_DIR  := $(FLOW_ROOT)/pnr/inputs

########################################
# External paths 
########################################
PDK_PATH    := #Path of the PDK

########################################
# Files
########################################
RTL_FILES := $(shell find $(RTL_DIR) -name "*.sv" -o -name "*.v" 2>/dev/null)

########################################
# Syn env
########################################
SYN_ENV := PRJ_ROOT=$(PRJ_ROOT)               \
           FLOW_ROOT=$(FLOW_ROOT)             \
           RTL_DIR=$(RTL_DIR)                 \
           RTL_FILES="$(RTL_FILES)"           \
           SCRIPTS_DIR=$(SCRIPTS_DIR)         \
           CONSTR_DIR=$(CONSTR_DIR)           \
           SYN_OUTPUTS_DIR=$(SYN_OUTPUTS_DIR) \
           SYN_REPORTS_DIR=$(SYN_REPORTS_DIR) \
           SYN_LOGS_DIR=$(SYN_LOGS_DIR)       \
           PDK_PATH=$(PDK_PATH)

########################################
# PnR env
########################################
PNR_ENV := PRJ_ROOT=$(PRJ_ROOT)               \
           FLOW_ROOT=$(FLOW_ROOT)             \
           RTL_DIR=$(RTL_DIR)                 \
           RTL_FILES="$(RTL_FILES)"           \
           SCRIPTS_DIR=$(SCRIPTS_DIR)         \
           CONSTR_DIR=$(CONSTR_DIR)           \
           PNR_OUTPUTS_DIR=$(PNR_OUTPUTS_DIR) \
           PNR_REPORTS_DIR=$(PNR_REPORTS_DIR) \
           PNR_LOGS_DIR=$(PNR_LOGS_DIR)       \
		   SYN_OUTPUTS_DIR=$(SYN_OUTPUTS_DIR) \
		   PNR_INPUTS_DIR=$(PNR_INPUTS_DIR)   \
           PDK_PATH=$(PDK_PATH)


########################################
# Targets
########################################
.PHONY: all syn syn_clean pnr pnr_clean fix_scandef

syn: syn_clean
	@mkdir -p $(SYN_WORK_DIR) $(SYN_LOGS_DIR) $(SYN_OUTPUTS_DIR) $(SYN_REPORTS_DIR)
	@echo "=== Running Synthesis ==="
	cd $(SYN_WORK_DIR) && \
		module load genus && \
		env $(SYN_ENV) genus -f $(SCRIPTS_DIR)/genus/genus_main.tcl \
			| tee $(SYN_LOGS_DIR)/syn.log
	@echo "=== Done ==="

syn_clean:
	@echo "=== Cleaning syn directories ==="
	@rm -rf $(SYN_WORK_DIR)/* $(SYN_LOGS_DIR)/* \
	        $(SYN_OUTPUTS_DIR)/* $(SYN_REPORTS_DIR)/* || true

# no interface
pnr: pnr_clean fix_scandef
	@mkdir -p $(PNR_WORK_DIR) $(PNR_LOGS_DIR) $(PNR_OUTPUTS_DIR) $(PNR_REPORTS_DIR)
	@echo "=== Running Place & Route ==="
	cd $(PNR_WORK_DIR) && \
		module load innovus && \
		env $(PNR_ENV) innovus -batch -no_gui -files $(SCRIPTS_DIR)/innovus/innovus_main.tcl \
			| tee $(PNR_LOGS_DIR)/pnr.log
	@echo "=== Done ==="

# with interface
pnr_gui: pnr_clean fix_scandef
	@mkdir -p $(PNR_WORK_DIR) $(PNR_LOGS_DIR) $(PNR_OUTPUTS_DIR) $(PNR_REPORTS_DIR)
	@echo "=== Running Place & Route ==="
	cd $(PNR_WORK_DIR) && \
		module load innovus && \
		env $(PNR_ENV) innovus -files $(SCRIPTS_DIR)/innovus/innovus_main.tcl \
			| tee $(PNR_LOGS_DIR)/pnr.log
	@echo "=== Done ==="
 
pnr_clean:
	@echo "=== Cleaning pnr directories ==="
	@rm -rf $(PNR_WORK_DIR)/* $(PNR_LOGS_DIR)/* $(PNR_OUTPUTS_DIR)/* $(PNR_REPORTS_DIR)/* || true

fix_scandef:
	sed 's/DESIGN rvx ;/DESIGN rvx_top ;/' \
	    $(PNR_INPUTS_DIR)/genus/rvx_scan_chain.def | \
	sed 's/^\(       \)\([a-z]\)/\1rvx\/\2/' \
	    > $(PNR_INPUTS_DIR)/genus/rvx_scan_chain_top.def
