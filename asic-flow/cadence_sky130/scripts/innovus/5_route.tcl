setNanoRouteMode -route_antenna_cell_name sky130_fd_sc_hd__diode_2
setNanoRouteMode -route_antenna_diode_insertion true
setNanoRouteMode -route_detail_fix_antenna true

set_db timing_analysis_type ocv
routeDesign -globalDetail
route_opt_design -opt
optDesign -postRoute

ecoRoute -target
optDesign -incr


saveDesign $PNR_OUTPUTS_DIR/rvx_top_route_working.enc