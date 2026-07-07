verifyConnectivity -type regular -geomConnect -error 1000 -warning 50

verifyConnectivity -nets {VDD GND VDDR GNDR} -type all -error 1000 -warning 50

verifyGeometry -allowDiffCellViol

verify_drc