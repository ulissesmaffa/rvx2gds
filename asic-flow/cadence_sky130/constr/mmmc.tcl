################################################################################
# MMMC - Multi-Mode Multi-Corner
# Projeto: rvx  |  PDK: Sky130 HD
# Ferramenta: Cadence Genus (síntese lógica)
################################################################################

create_library_set -name worst_libset \
    -timing [list \
        $MMMC_LIB/sky130_fd_sc_hd__ss_100C_1v60.lib \
        $MMMC_LIB_IO/sky130_fd_io__top_gpiov2_ss_ss_100C_1v60_1v65.lib \
        $MMMC_LIB_IO/sky130_fd_io__top_power_lvc_wpad_ss_100C_1v60_1v65_1v65.lib \
    ]
create_library_set -name nominal_libset \
    -timing [list \
        $MMMC_LIB/sky130_fd_sc_hd__tt_025C_1v80.lib \
        $MMMC_LIB_IO/sky130_fd_io__top_gpiov2_tt_tt_025C_1v80_3v30.lib \
        $MMMC_LIB_IO/sky130_fd_io__top_power_lvc_wpad_tt_025C_1v80_3v30_3v30.lib \
    ]
create_library_set -name best_libset \
    -timing [list \
        $MMMC_LIB/sky130_fd_sc_hd__ff_n40C_1v95.lib \
        $MMMC_LIB_IO/sky130_fd_io__top_gpiov2_ff_ff_n40C_1v95_5v50.lib \
        $MMMC_LIB_IO/sky130_fd_io__top_power_lvc_wpad_ff_n40C_1v95_5v50_5v50.lib \
    ]

# Operating conditions
create_opcond -name worst_opcond   -voltage 1.60 -temperature 100.0
create_opcond -name nominal_opcond -voltage 1.80 -temperature  25.0
create_opcond -name best_opcond    -voltage 1.95 -temperature -40.0

# Timing conditions
create_timing_condition -name worst_timing_cond \
    -opcond worst_opcond -library_sets { worst_libset }

create_timing_condition -name nominal_timing_cond \
    -opcond nominal_opcond -library_sets { nominal_libset }

create_timing_condition -name best_timing_cond \
    -opcond best_opcond -library_sets { best_libset }

# Delay corners — sem rc_corner no Genus (sem roteamento físico)
create_delay_corner -name worst_delay_corner \
    -timing_condition worst_timing_cond

create_delay_corner -name nominal_delay_corner \
    -timing_condition nominal_timing_cond

create_delay_corner -name best_delay_corner \
    -timing_condition best_timing_cond

# Constraint mode — -sdc_files obrigatório no Genus 23.12
create_constraint_mode -name func_mode \
    -sdc_files [list $CONSTR_DIR/rvx.sdc]

# Analysis views
create_analysis_view -name worst_view \
    -constraint_mode func_mode -delay_corner worst_delay_corner

create_analysis_view -name nominal_view \
    -constraint_mode func_mode -delay_corner nominal_delay_corner

create_analysis_view -name best_view \
    -constraint_mode func_mode -delay_corner best_delay_corner

# Setup=SS (células lentas → setup crítico) / Hold=FF (células rápidas → hold crítico)
set_analysis_view \
    -setup { worst_view } \
    -hold  { best_view  }