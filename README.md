# GN-mdl_axi4_stream

SystemVerilog AXI4-Stream Mst/Slv model for simulation.

- Simulator: Questa Prime Lite
- Language: SystemVerilog
- License: MIT

## Overview
This repository provides **AXI4-Stream master and slave models**
intended for **simulation and verification environments**.

The models are designed to:
- Drive AXI4-Stream transactions from test scenarios
- Apply realistic backpressure behavior
- Validate DUT protocol handling when combined with assertions

These models are **not cycle-accurate hardware implementations**,
but verification-oriented behavioral models.

## Features
- AXI4-Stream master model
- AXI4-Stream slave model
- Task-based transaction control
- Burst / gap style `tready` backpressure (slave model)
- Designed for reuse across multiple DUTs

## Model Behavior Notes

### Master Model
- Drives `tvalid` and `tdata` using task-based APIs
- **Keeps `tdata` stable while `tvalid=1 && tready=0`**
- Holds `tvalid` asserted until handshake completes
- Intended to follow AXI4-Stream protocol strictly

### Slave Model
- Drives `tready` to apply backpressure to the DUT
- `tready` behavior can include:
  - Continuous ready
  - Burst / gap backpressure patterns (tready asserted and deasserted for multiple consecutive cycles)
- Backpressure is intentionally applied to expose protocol violations

## Directory Structure
```
.
├─ src/
│   ├─ gn_mdl_axis_mst.sv      # AXI4-Stream master model
│   └─ gn_mdl_axis_slv.sv      # AXI4-Stream slave model
│
├─ lib/
│   ├─ gn_mdl_axis_mst_tasks.svh   # Master model tasks
│   ├─ gn_mdl_axis_slv_tasks.svh   # Slave model tasks
│   └─ util_task.svh               # Common utility tasks
│
├─ LICENSE
└─ README.md
```

The `src` directory contains the SystemVerilog model implementations.
The `lib` directory contains reusable task and utility definitions
included by the models and test scenarios.

## Usage
These models are intended to be instantiated in a simulation
top-level module (e.g. `board_top`) and controlled from test scenarios
using tasks.

Typical usage:
- Instantiate master/slave model modules
- Include task files from `lib/`
- Drive transactions from test scenarios
- Observe DUT behavior via assertions and scoreboards

## Notes
- These models assume **AXI4-Stream compliant DUT behavior**.
- Master tasks must not change `tdata` while stalled.
- Slave backpressure is intentionally active to expose corner cases.
- The models are designed for verification robustness rather than performance.

## License
This project is licensed under the MIT License.
