# RISC-V-32bit-ALU-RV32IM
Design and verification of a 32-bit RISC-V RV32IM ALU with Barrel Shifter and Hardware Divider in Vivado
# 32-bit RISC-V (RV32IM) Execution Unit & Hardware ALU

A robust, fully verified 32-bit **RISC-V (RV32IM)** Execution Unit designed in Verilog HDL and implemented on AMD Xilinx Vivado. This design extends the standard RV32I Base Integer ALU into a high-performance execution engine featuring a 5-stage Logarithmic Barrel Shifter, a 64-bit Hardware Multiplier, and a 32-cycle FSM-based Iterative Restoring Divider with corner-case handling.

---

## 📌 Project Overview

This project implements a complete hardware execution block tailored for the RISC-V architecture:
- **Base Architecture:** RISC-V RV32I (Integer arithmetic, logical, and shift operations)
- **Extension:** RISC-V RV32M (Hardware Multiplication and Division)
- **Design Paradigm:** High-speed parallel arithmetic coupled with a multi-cycle sequential division unit
- **EDA Tool:** AMD Xilinx Vivado (Synthesis, RTL Elaboration & Simulation)
- **Language:** Verilog HDL

---

## 🚀 Key Features & Architectural Modules

### 1. RV32I Base Arithmetic & Condition Flags
- Supports `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLT` (Signed Set Less Than), and `SLTU` (Unsigned Set Less Than).
- Generates 3 status flags for full branch resolution:
  - **Zero ($Z$):** Asserted when the ALU result is zero.
  - **Negative ($N$):** Tracks the sign bit ($ALU\_Result[31]$).
  - **Overflow ($V$):** 2's complement signed overflow detection on addition/subtraction.

### 2. 5-Stage Logarithmic Barrel Shifter (`barrel_shifter.v`)
- Replaces standard combinational shift multiplexer chains with an $O(\log_2 32) = 5$-stage shifter.
- Supports:
  - **SLL:** Shift Left Logical
  - **SRL:** Shift Right Logical
  - **SRA:** Shift Right Arithmetic (preserves sign bit)

### 3. RV32M 64-bit Parallel Multiplier (`riscv_alu_adv.v`)
- Executes 32-bit $\times$ 32-bit multiplication producing a 64-bit wide product mapped to DSP hardware.
- Supports:
  - **`MUL`:** Lower 32 bits of product
  - **`MULH`:** Upper 32 bits of signed $\times$ signed product
  - **`MULHU`:** Upper 32 bits of unsigned $\times$ unsigned product

### 4. 32-Cycle Iterative Hardware Divider (`riscv_divider.v`)
- Multi-cycle sequential engine using the **Restoring Shift-Subtract Division Algorithm**.
- Managed via an FSM controller with `start`, `busy`, and `ready` handshaking signals.
- Standard RISC-V operations supported:
  - **`DIV`:** Signed Quotient
  - **`DIVU`:** Unsigned Quotient
  - **`REM`:** Signed Remainder
  - **`REMU`:** Unsigned Remainder
- **Corner Cases Handled (as per RISC-V specification):**
  - **Division by Zero:** $A / 0 = -1$ (`0xFFFFFFFF`), $A \pmod 0 = A$
  - **Signed Overflow:** $-2^{31} / -1 = -2^{31}$, $-2^{31} \pmod {-1} = 0$

### 5. Datapath & Instruction Fetch Integration
- Integrated with a **32x32 Register File** (hardwired $x0 = 0$), **Program Counter (PC)**, **Instruction Decoder**, and **Instruction ROM** reading machine code from `.mem` files.

---

## 📂 Repository Directory Structure

```text
├── rtl/
│   ├── riscv_alu_top_m.v       # Master Top Module (Integrates Core ALU + Divider)
│   ├── riscv_alu_adv.v         # RV32I ALU + Barrel Shifter + 64-bit Multiplier
│   ├── barrel_shifter.v        # 5-stage Logarithmic Barrel Shifter
│   ├── riscv_divider.v         # 32-cycle Iterative Hardware Divider
│   ├── alu_decoder.v           # ALU Operation Decoder
│   ├── reg_file.v              # 32x32 Dual-Port Register File
│   ├── program_counter.v       # Program Counter (PC + 4)
│   ├── instruction_memory.v    # Instruction ROM
│   └── riscv_core.v            # Single-Cycle Datapath Top
│
├── sim/
│   ├── riscv_alu_top_m_tb.v    # Master Unit Verification Testbench
│   ├── riscv_alu_adv_tb.v      # Advanced Multiplier & Barrel Shifter TB
│   ├── riscv_divider_tb.v      # Divider Testbench (Corner Cases)
│   ├── riscv_core_tb.v         # CPU Datapath Testbench
│   └── instructions.mem        # Machine Code Instructions
│
├── docs/
│   ├── master_schematic.png    # Top-Level RTL Elaborated Schematic
│   ├── simulation_waveform.png # Verification Waveform
│   └── divider_waveform.png    # 32-cycle Handshake Waveform
│
└── README.md
