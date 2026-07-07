defIn  $PNR_INPUTS_DIR/genus/rvx_scan_chain_top.def
setScanReorderMode -compLogic true

place_design

scanReorder

assignIoPins

saveDesign $PNR_OUTPUTS_DIR/rvx_top_place.enc