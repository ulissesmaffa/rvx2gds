##################################################
## Lê variáveis de ambiente passadas pelo Makefile
## (definidas em PNR_ENV no Makefile)
##################################################
set DESIGN      rvx_top

##################################################
## PDK — paths derivados de $PDK_PATH
##################################################
set SC_LIB      "$PDK_PATH/sky130_fd_sc_hd/lib"
set IO_LIB      "$PDK_PATH/sky130_fd_io/lib"
set TLEF_PATH   "$PDK_PATH/sky130_fd_sc_hd/techlef"
set SC_LEF_PATH "$PDK_PATH/sky130_fd_sc_hd/lef"
set IO_LEF_PATH "$PDK_PATH/sky130_fd_io/lef"

##################################################
## Process Mode
##################################################
setDesignMode -process 130

##################################################
## Power Nets
##################################################
set init_pwr_net {VDD VDDR}
set init_gnd_net {GND GNDR}

##################################################
## MMMC
##################################################
set init_mmmc_file $PNR_INPUTS_DIR/innovus/cmn/rvx.mmmc.tcl

##################################################
## LEFs — mandatory order: tlef → sc → ef_sc → fd_io → ef_io
##################################################
set init_lef_file [list \
    $TLEF_PATH/sky130_fd_sc_hd__nom.tlef  \
    $SC_LEF_PATH/sky130_fd_sc_hd.lef      \
    $IO_LEF_PATH/sky130_ef_io_patched.lef \ 
]

##################################################
## Netlists
##################################################
set init_verilog [list \
    $PNR_INPUTS_DIR/genus/rvx_netlist.v \
    $PNR_INPUTS_DIR/rvx_pads.v    \
]

##################################################
## Init
##################################################
init_design

##################################################
## IO
##################################################
loadIoFile $PNR_INPUTS_DIR/rvx_top.io 

##################################################
## Save checkpoint de init
##################################################
saveDesign $PNR_OUTPUTS_DIR/${DESIGN}_genesis.enc
