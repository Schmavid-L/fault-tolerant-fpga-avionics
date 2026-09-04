# Fault-Tolerant FPGA Controller

A hardware-implemented fault-tolerant control system built in SystemVerilog and deployed on a Digilent Basys 3 FPGA.

The design uses **Triple Modular Redundancy (TMR)** with three parallel finite-state-machine controllers, combinational majority voting, and channel-disagreement detection. A single controller fault can be masked while the remaining two healthy channels maintain the system output.

The project was developed through the complete FPGA workflow: RTL design, self-checking simulation, synthesis, place-and-route, timing analysis, bitstream generation, and physical fault-injection testing on an Artix-7 FPGA.

## Hardware

- Digilent Basys 3
- Xilinx Artix-7 XC7A35T
- 100 MHz onboard clock
- Physical switches for enable and fault injection
- LEDs for voted state and disagreement indication

## Architecture

```text
                     clk / reset / enable
                             |
               +-------------+-------------+
               |             |             |
               v             v             v
         +-----------+ +-----------+ +-----------+
         |Controller | |Controller | |Controller |
         |     A     | |     B     | |     C     |
         +-----------+ +-----------+ +-----------+
               |             |             |
               +-------------+-------------+
                             |
                  +----------+----------+
                  |                     |
                  v                     v
           ACTIVE Majority        SAFE Majority
                Voter                 Voter
                  |                     |
                  v                     v
           voted_active          voted_safe

           Channel ACTIVE outputs
                  |
                  v
          Disagreement Detector
             |      |      |
             v      v      v
          detect_A detect_B detect_C
```

Each controller contains three operating states:

- `STANDBY` — waiting for the system to be enabled
- `ACTIVE` — normal operating state
- `SAFE` — latched safe state entered after a fault

`SAFE` remains latched until reset.

## Triple Modular Redundancy

The three controllers execute concurrently in hardware.

The majority voter implements:

```text
Vote = (A & B) | (A & C) | (B & C)
```

This allows the system to mask one disagreeing controller.

Example:

```text
Controller A: ACTIVE
Controller B: SAFE
Controller C: ACTIVE

Majority: ACTIVE
```

With two channels in `SAFE`, the majority changes to `SAFE`, demonstrating the single-fault tolerance limit of basic TMR.

## Disagreement Detection

Each controller's `active` output is compared with the majority-voted result.

```text
fault_detect_x = active_x XOR voted_active
```

A high disagreement flag indicates that a channel differs from the current majority.

This is intentionally a **disagreement detector**, not an independent physical-fault oracle. If two channels fail identically, they can establish the majority and cause the remaining healthy channel to appear as the outlier.

## Verification

Self-checking SystemVerilog testbenches were developed for each major subsystem.

### Majority Voter

All eight possible three-input combinations were tested:

```text
000 -> 0
001 -> 0
010 -> 0
011 -> 1
100 -> 0
101 -> 1
110 -> 1
111 -> 1
```

The voter testbench was also validated by intentionally introducing incorrect RTL and confirming that `$fatal` detected the failure.

### Controller FSM

Verification included:

- Reset to `STANDBY`
- `STANDBY` to `ACTIVE`
- `ACTIVE` to `SAFE`
- SAFE-state latching after the fault is removed
- Reset recovery from `SAFE`

### Integrated TMR System

System-level tests verified:

```text
Healthy:
A = ACTIVE
B = ACTIVE
C = ACTIVE
Result = ACTIVE

Single fault:
A = ACTIVE
B = SAFE
C = ACTIVE
Result = ACTIVE
B disagreement detected

Two faults:
A = ACTIVE
B = SAFE
C = SAFE
Result = SAFE
```

## FPGA Implementation

The design was synthesized and implemented in AMD Vivado for the XC7A35T Artix-7 FPGA.

Post-synthesis inspection confirmed three separate controller instances in the hardware hierarchy.

A synthesis snapshot of the TMR core reported:

| Resource | Used |
|---|---:|
| Slice LUTs | 10 |
| Slice Registers | 9 |
| Bonded I/O | 11 |
| BUFGCTRL | 1 |

The three controller instances accounted for three registers each, providing structural evidence of hardware replication rather than sequential software execution.

## Timing

The implemented Basys 3 design met the 100 MHz clock constraint.

| Timing Metric | Result |
|---|---:|
| Worst Setup Slack (WNS) | +8.580 ns |
| Total Negative Slack (TNS) | 0.000 ns |
| Worst Hold Slack (WHS) | +0.246 ns |
| Total Hold Slack (THS) | 0.000 ns |
| Failing Endpoints | 0 |

Vivado reported that all user-specified timing constraints were met.

## Hardware Demonstration

The design was programmed onto a Basys 3 and tested using physical switch-based fault injection.

### Controls

| Basys 3 Control | Function |
|---|---|
| SW0 | Enable |
| SW1 | Inject fault into Controller A |
| SW2 | Inject fault into Controller B |
| SW3 | Inject fault into Controller C |
| BTNC | Reset |

### Indicators

| LED | Function |
|---|---|
| LED0 | Voted ACTIVE |
| LED1 | Voted SAFE |
| LED2 | Controller A disagreement |
| LED3 | Controller B disagreement |
| LED4 | Controller C disagreement |

Physical testing confirmed:

1. Enabling the healthy system asserted `voted_active`.
2. Injecting a fault into Controller B left `voted_active` asserted while identifying B as the disagreeing channel.
3. Injecting a second fault caused the majority to transition to `SAFE`.

## Repository Structure

```text
fault-tolerant-fpga/
|
+-- rtl/
|   +-- majority_voter.sv
|   +-- controller.sv
|   +-- fault_detector.sv
|   +-- tmr_controller.sv
|   +-- basys3_top.sv
|
+-- tb/
|   +-- majority_voter_tb.sv
|   +-- controller_tb.sv
|   +-- fault_detector_tb.sv
|   +-- tmr_controller_tb.sv
|
+-- constraints/
|   +-- basys3.xdc
|
+-- docs/
|
+-- README.md
```

## Tools and Skills Demonstrated

- SystemVerilog RTL design
- Finite-state machines
- Sequential and combinational logic
- Triple Modular Redundancy
- Majority voting
- Fault injection and disagreement detection
- Self-checking testbenches
- Behavioral simulation
- FPGA synthesis
- Place and route
- Static timing analysis
- XDC pin and clock constraints
- Basys 3 / Artix-7 hardware bring-up
- Git version control

## Project Status

**Hardware verified.**

The TMR controller was successfully simulated, synthesized, implemented, timing-verified, programmed onto the Basys 3, and validated using physical fault injection.# fault-tolerant-fpga-avionics
