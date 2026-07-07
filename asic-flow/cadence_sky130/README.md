# Changelog
When | Who | Brief
-----|-----|------
2026-06-04 | UM | RTL updated to RVX with multiplier unit; logic synthesis performed following the proposed flow.
2026-06-25 | UM | Incorporates improvements learned from TC1. Contains what is necessary to reach sign-off.
2026-07-06 | UM | Full RTL-to-GDSII flow executed in Cadence (Genus + Innovus). Sign-off not reached due to sky130 PAD library limitations.

# Design Specification
- Design Name       : RVX
- HDL Used          : Verilog
- Top Module Name   : rvx_top (core wrapped in IO PAD ring)

# Library Information
- Process Design Kit    : SkyWater sky130 (open source)
- Standard Cell Library : sky130_fd_sc_hd
- I/O Cell Library      : sky130_ef_io

# Design Flow
- Flow Name     : ASIC RTL-to-GDSII Flow (Cadence)

# EDA Tools Used
1. Logic Synthesis   : Cadence Genus
2. Physical Design   : Cadence Innovus

# Directories
```
├── constr              (Constraints Directory)
│   ├── mmmc.tcl        (Multi-Mode Multi-Corner setup)
│   └── rvx.sdc         (Timing constraints)
├── scripts             (Scripts Directory)
│   ├── genus           (Logic Synthesis scripts)
│   └── innovus         (Physical Design scripts)
├── pnr                 (Place & Route Directory)
│   └── inputs          (Assembled PnR inputs — see pnr/inputs/README.md)
├── syn                 (Synthesis output dirs — git-ignored; see syn/README.md)
├── Makefile            (Flow orchestration)
└── README.md           (This README file)
```