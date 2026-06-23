# Digital System Design with HDL

This repository contains coursework, laboratory exercises, testbenches, and final project materials for the **Digital System Design with HDL** course.

The course focuses on implementing fundamental digital circuits using **Verilog HDL**. Topics include combinational circuits, sequential circuits, registers, counters, finite state machines, memory modules, datapath design, control units, and simple processor implementation.

Each design is accompanied by a testbench used to simulate its operation, verify its functionality, and evaluate its outputs under different input conditions.

Through laboratory exercises and a final project, students gain practical experience in HDL coding, RTL design, functional simulation, waveform analysis, debugging, and digital system verification.

---

## Course Information

| Item | Details |
|---|---|
| Course | Digital System Design with HDL |
| Course Code | CE213 |
| Class Code | CE213.Q21 |
| Semester | Semester II, 2025–2026 |
| Instructor | Dr. Tran Thi Diem |

---

## Repository Structure

```text
CE213-Digital-System-Design-with-HDL/
│
├── LAB01/
│   └── Introduction to Verilog HDL and ModelSim
│
├── LAB02/
│   ├── Synchronous Counter
│   └── Register File
│
├── LAB03/
│   ├── Moore FSM 010 Sequence Detector
│   └── SRAM-based Data Memory
│
├── LAB04/
│   ├── 32-bit ALU
│   └── 32-bit 2-to-1 Multiplexer
│
├── LAB05/
│   └── Simple MIPS Datapath
│
├── LAB06/
│   ├── Main Control Unit
│   └── ALU Control
│
├── LAB07/
│   └── Simple Processor
│
├── Final_Project/
│   └── 2D Gaussian Image Filter
│
└── README.md
```

---

## Laboratory Exercises

### LAB01 – Introduction to Verilog HDL and ModelSim

This lab introduces the basic workflow of creating, compiling, simulating, and verifying Verilog HDL designs using **ModelSim**.

This lab is tutorial-based and does not include a separate implementation.

---

### LAB02 – Synchronous Counter and Register File

This lab includes the implementation of:

- A synchronous counter with preset and clear functions.
- A 32 × 32-bit register file using Verilog HDL.

The objective is to understand sequential circuit design, clocked behavior, register storage, and basic data access operations.

---

### LAB03 – Finite State Machine and Data Memory

This lab includes the implementation of:

- A Moore finite state machine for detecting the `010` sequence.
- An SRAM-based data memory module.

The objective is to practice FSM design, state transition logic, output logic, and memory read/write operations.

---

### LAB04 – Arithmetic Logic Unit and Multiplexer

This lab includes the implementation of:

- A 32-bit Arithmetic Logic Unit.
- A 32-bit 2-to-1 multiplexer.

The ALU supports arithmetic and logical operations, while the multiplexer is used for selecting between two 32-bit data inputs.

---

### LAB05 – Simple MIPS Datapath

This lab focuses on designing a simple MIPS datapath by integrating previously implemented modules.

The datapath is designed to support the execution of basic instructions, including:

- `add`
- `lw`
- `sw`

The objective is to understand how registers, ALU, memory, and multiplexers are connected to form a processor datapath.

---

### LAB06 – Simple Control Unit

This lab includes the implementation of:

- Main Control Unit.
- ALU Control module.

These modules generate control signals required to operate the simple MIPS datapath correctly.

The objective is to understand how instruction decoding is used to control datapath components.

---

### LAB07 – Simple Processor

This lab integrates the datapath, Main Control Unit, and ALU Control module to implement a simple processor.

The processor supports the following instructions:

- `add`
- `lw`
- `sw`

The objective is to understand the basic organization of a processor and how datapath and control logic work together.

---

## Final Project

### 2D Gaussian Image Filter

The final project focuses on the implementation and verification of a hardware-based **2D Gaussian Image Filter** using Verilog HDL and ModelSim.

The design supports:

- 3 × 3 Gaussian kernel.
- 5 × 5 Gaussian kernel.
- Hardware-based image filtering.
- Functional simulation.
- Output verification.

This project demonstrates the application of digital system design concepts to image processing using HDL-based hardware implementation.

---

## Tools and Technologies

- Verilog HDL
- ModelSim
- RTL Design
- Functional Simulation
- Waveform Analysis
- Digital System Verification

---

## Learning Outcomes

After completing this coursework, students are able to:

- Design combinational and sequential circuits using Verilog HDL.
- Implement registers, counters, FSMs, memory modules, and ALU components.
- Build and verify datapath and control unit designs.
- Develop testbenches for functional simulation.
- Analyze simulation waveforms to debug and verify digital circuits.
- Integrate multiple RTL modules into a simple processor.
- Apply HDL design techniques to a hardware-based image processing project.

---

## Author

**Van Nhat Tan**  
Computer Engineering Student  
University of Information Technology – VNU-HCM

---

## License

This repository is created for academic and educational purposes.
