# PnR Inputs

This directory holds all inputs required to run the physical synthesis (Place & Route)
flow in Cadence Innovus. Its contents are assembled from two sources:

1. **`innovus/`** — the complete Innovus setup, copied in as a whole. It contains the
   flow scripts (`1_setup.tcl` through `6_verif.tcl`) and the common configuration
   under `cmn/` (e.g. the `rvx.mmmc.tcl` MMMC view definitions).

2. **`genus/`** — the loose output files from logic synthesis, copied here from the
   Genus run. These include the synthesized netlist (`rvx_netlist.v`), the SDC
   constraints, the exported MMMC configuration, the SDF delays, and the scan-chain DEF.

In addition, two manually produced files sit at the root of this directory:

- **`rvx_pads.v`** — the top-level wrapper (`rvx_top`) instantiating the core inside
  the PAD ring.
- **`rvx_top.io`** — the PAD placement file, defining the position of each PAD along
  the die edges.

The flow reads everything from here through the `$PNR_INPUTS_DIR` environment
variable set by the Makefile.