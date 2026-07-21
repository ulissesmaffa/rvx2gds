# RVX-TO-GDSII

Physical implementation of the open-source **RVX** 32-bit RISC-V core using the
commercial **Cadence** toolchain (Genus + Innovus) on the open-source
**SkyWater sky130** PDK.


## Highlights

- **Commercial Cadence flow** — logic synthesis in Genus and place & route in Innovus,
  rather than an automated open-source flow (e.g. OpenLANE).
- **Real RISC-V core** — built on the open-source RVX core, taken through the full
  physical implementation flow.
- **Complete backend flow executed** — floorplan, power planning, CTS, routing and
  verification, including a hand-built IO PAD ring. Sign-off was not reached on sky130
  due to PAD-library limitations (see Status).

## Repository layout

```
rvx2gds/
├── rtl/                            # RVX RTL sources (Verilog / SystemVerilog)
└── asic-flow/                      # ASIC implementation flow
    └── cadence_sky130/
        ├── constr/                 # constraints
        │   ├── mmmc.tcl            # multi-mode multi-corner setup
        │   └── rvx.sdc             # timing constraints
        ├── scripts/
        │   ├── genus/              # logic synthesis (setup, syn, main)
        │   └── innovus/            # physical synthesis (setup → power → place → cts → route → verify)
        ├── pnr/
        │   └── inputs/             # assembled PnR inputs (see pnr/inputs/README.md)
        ├── syn/                    # synthesis output dirs (git-ignored; see syn/README.md)
        └── Makefile                # flow orchestration
```

## Requirements

- **Cadence Genus** (logic synthesis)
- **Cadence Innovus** (place & route)
- **SkyWater sky130** PDK (`sky130_fd_sc_hd` standard cells, `sky130_ef_io` pad cells)

Set the PDK location before running: edit `PDK_PATH` in the `Makefile` to point to
your local sky130 installation. The flow assumes `genus` and `innovus` are available
as environment modules (`module load`).

## Usage

All targets are run from the `asic-flow/cadence_sky130` directory.

| Target        | Description                                                        |
|---------------|--------------------------------------------------------------------|
| `make syn`    | Run logic synthesis in Genus.                                      |
| `make pnr`    | Run place & route in Innovus (batch, no GUI).                      |
| `make pnr_gui`| Run place & route with the Innovus GUI.                            |
| `make fix_scandef` | Reanchor the Genus scan-chain DEF to the `rvx_top` hierarchy. |
| `make syn_clean` / `make pnr_clean` | Clear the respective work/output/report/log dirs. |

Both `pnr` and `pnr_gui` depend on `fix_scandef`, which prefixes the scan-chain
flip-flop paths with the core instance name (`rvx/`) and updates the DEF header from
`rvx` to `rvx_top`, so Innovus can locate the scan elements once the core is wrapped
inside the PAD ring.

## Status

The full sky130 flow runs end to end. Sign-off was not reached due to limitations in
the available sky130 PAD library, which is not fully characterized for a complete
pad-ring flow in this environment. Signal routing of the core is DRC-clean; the
remaining violations are confined to the power/pad interface.

## References

- [Calçada — rvx](https://github.com/rafaelcalcada/rvx/tree/main), referenced at commit `<hash>`.

## License

<MIT>
