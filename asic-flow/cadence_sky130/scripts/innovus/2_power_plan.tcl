clearGlobalNets
globalNetConnect VDD  -type pgpin -pin VCCD    -inst * -module {} -override
globalNetConnect GND  -type pgpin -pin VSSD    -inst * -module {} -override
globalNetConnect VDDR -type pgpin -pin VDDIO   -inst * -module {} -override
globalNetConnect GNDR -type pgpin -pin VSSIO   -inst * -module {} -override
globalNetConnect VDDR -type pgpin -pin VDDIO_Q -inst * -module {} -override
globalNetConnect GNDR -type pgpin -pin VSSIO_Q -inst * -module {} -override
globalNetConnect VDD  -type pgpin -pin VCCHIB  -inst * -module {} -override
globalNetConnect VDD -type pgpin -pin VPWR -inst * -module {} -override
globalNetConnect GND -type pgpin -pin VGND -inst * -module {} -override

setViaGenMode -ignore_viarule_enclosure false

floorPlan -site unithd -d 1120 1100 30 30 30 30 -noSnapToGrid

addIoFiller -cell {sky130_ef_io__com_bus_slice_20um \
                   sky130_ef_io__com_bus_slice_10um \
                   sky130_ef_io__com_bus_slice_5um \
                   sky130_ef_io__com_bus_slice_1um \
                   } -prefix IOFILLER -fillAnyGap


foreach inst [dbGet top.insts.name -regexp {IOFILLER}] {
    dbSet [dbGet -p top.insts.name $inst].pStatus fixed
}

addRing -nets {VDD GND} -type core_rings -follow core \
    -layer {top met5 bottom met5 left met4 right met4} \
    -width {top 6 bottom 6 left 6 right 6} \
    -spacing {top 4 bottom 4 left 4 right 4} \
    -center 1 -threshold 0 -jog_distance 0 \
    -snap_wire_center_to_grid None

addStripe -nets {VDD GND} \
    -layer met4 -direction vertical \
    -width 6 -spacing 15 \
    -set_to_set_distance 120 \
    -start_from left -start_offset 20 -stop_offset 10 \
    -switch_layer_over_obs false \
    -max_same_layer_jog_length 2 \
    -padcore_ring_top_layer_limit met5 \
    -padcore_ring_bottom_layer_limit met2 \
    -block_ring_top_layer_limit met5 \
    -block_ring_bottom_layer_limit met2 \
    -use_wire_group 0 \
    -snap_wire_center_to_grid None

addStripe -nets {VDD GND} \
    -layer met5 -direction horizontal \
    -width 6 -spacing 15 \
    -set_to_set_distance 110 \
    -start_from bottom -start_offset 20 -stop_offset 0 \
    -switch_layer_over_obs false \
    -max_same_layer_jog_length 2 \
    -padcore_ring_top_layer_limit met5 \
    -padcore_ring_bottom_layer_limit met2 \
    -block_ring_top_layer_limit met5 \
    -block_ring_bottom_layer_limit met2 \
    -use_wire_group 0 \
    -snap_wire_center_to_grid None

sroute -connect {blockPin padPin padRing corePin floatingStripe} \
    -allowJogging true \
    -allowLayerChange true \
    -blockPin useLef \
    -targetViaLayerRange {met1 met5} 

editPowerVia -add_vias 1 -nets {VDD GND}

setDesignMode -topRoutingLayer 5
setDesignMode -bottomRoutingLayer 1


saveDesign $PNR_OUTPUTS_DIR/rvx_top_powerplan.enc
