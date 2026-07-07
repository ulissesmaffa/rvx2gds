proc find_rtl {dir} {
    set files [glob -nocomplain -directory $dir *.v *.sv]
    foreach subdir [glob -nocomplain -directory $dir -type d *] {
        set files [concat $files [find_rtl $subdir]]
    }
    return $files
}

set RTL_LIST [find_rtl $RTL_DIR]

set DESIGN rvx

set SYN_EFF high
set MAP_EFF high
set OPT_EFF high

##################################################
## PDK / Library paths
##################################################
set LIB_PATH  "$PDK_PATH/sky130_fd_sc_hd/lib $PDK_PATH/sky130_fd_io/lib"
set LEF_PATH  "$PDK_PATH/sky130_fd_sc_hd/lef $PDK_PATH/sky130_fd_io/lef"
set TLEF_PATH "$PDK_PATH/sky130_fd_sc_hd/techlef"

# set LIB_LIST {
#     sky130_fd_sc_hd__tt_025C_1v80.lib
#     sky130_fd_sc_hd__ss_100C_1v60.lib
#     sky130_fd_sc_hd__ff_n40C_1v95.lib
# }
set LIB_LIST {
    sky130_fd_sc_hd__tt_025C_1v80.lib
    sky130_fd_sc_hd__ss_100C_1v60.lib
    sky130_fd_sc_hd__ff_n40C_1v95.lib
    sky130_fd_io__top_gpiov2_tt_tt_025C_1v80_3v30.lib
    sky130_fd_io__top_power_lvc_wpad_tt_025C_1v80_3v30_3v30.lib
}

set LEF_LIST {
    sky130_fd_sc_hd.lef
    sky130_ef_sc_hd.lef
    sky130_fd_io.lef
    sky130_ef_io.lef
}

set TLEF_LIST {
    sky130_fd_sc_hd__nom.tlef
}

##################################################
## General
##################################################
set_db information_level                  9    ;# nível máximo de verbosidade — exibe todas as mensagens incluindo debug
set_db hdl_track_filename_row_col         true ;# rastreia arquivo, linha e coluna de cada elemento HDL — melhora mensagens de erro
set_db lp_power_unit                      mW   ;# define mW como unidade dos relatórios de potência
set_db error_on_lib_lef_pin_inconsistency true ;# para com erro se houver inconsistência entre pinos do .lib e do LEF
set_db auto_ungroup                       none ;# preserva hierarquia do RTL — sem isso o Genus abre módulos entre fronteiras
set_db tns_opto                           true ;# otimiza Total Negative Slack — sem isso foca apenas no pior path (WNS)

#set_db lp_insert_clock_gating             true ;# insere clock gating automaticamente para reduzir potência dinâmica
set_db lp_insert_clock_gating             false

set_db syn_generic_effort                 $SYN_EFF ;# esforço da síntese genérica — otimização independente de tecnologia
set_db syn_map_effort                     $MAP_EFF ;# esforço do mapeamento tecnológico — células da biblioteca
set_db syn_opt_effort                     $OPT_EFF ;# esforço da otimização incremental — fechamento de timing

##################################################
## Search paths
##################################################
set_db init_lib_search_path "$LIB_PATH $LEF_PATH $TLEF_PATH"
set_db script_search_path   $SCRIPTS_DIR/genus
set_db init_hdl_search_path $RTL_DIR

##################################################
## Read Libs
##################################################
set MMMC_LIB "$PDK_PATH/sky130_fd_sc_hd/lib"  
set MMMC_LIB_IO "$PDK_PATH/sky130_fd_io/lib"
read_mmmc $FLOW_ROOT/constr/mmmc.tcl

# Use when the MMMC is not performed
# read_libs $LIB_LIST
read_physical -lef "$TLEF_LIST $LEF_LIST"