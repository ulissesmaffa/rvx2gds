# ASIC Implementation Flows

This directory groups the ASIC implementation flows for the RVX core, organized by
EDA toolchain and target PDK. Each subdirectory is a self-contained flow with its own
scripts, constraints and README.

# Flows
| Flow | Toolchain | PDK | Status |
|------|-----------|-----|--------|
| `cadence_sky130`     | Cadence (Genus + Innovus)        | SkyWater sky130 (open source) | Full flow executed; sign-off not reached (PAD library limitations) |
| `synopsys_silterra180` | Synopsys (DC + ICC) | Silterra 180 nm | Planned |

See each flow's own `README.md` for tool versions, directory layout and usage.