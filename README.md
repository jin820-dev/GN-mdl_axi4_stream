# GN-mdl_axi4_stream

SystemVerilog AXI4-Stream Mst/Slv model for simulation.

- Simulator: Questa Prime Lite
- Language: SystemVerilog
- License: MIT

## Overview
This repository provides AXI4-Stream master and slave models
for simulation and verification.

The models are intended to be used in testbenches to drive and
monitor AXI4-Stream interfaces.

## Features
- AXI4-Stream master model
- AXI4-Stream slave model
- Task-based transaction control
- Designed for reuse across multiple DUTs

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

## License
This project is licensed under the MIT License.
