# ARMv4 Assembly Tutorial (32-bit)

Welcome to the **32-bit ARMv4 Assembly Language Tutorial** repository!

This tutorial is designed for those who want to understand low-level programming using real assembly code on the ARMv4 architecture. It’s hands-on, beginner-friendly, and pairs nicely with C code for comparison.


## What You'll Learn

- How to write, run, and debug assembly code for ARMv4
- The relationship between C and assembly at the binary level
- ARM's memory model, registers, calling conventions, and more
- How to use tools like `arm-none-eabi-gcc`, `as`, `objdump`, `qemu`, and `gdb`


## Tutorial Structure

Each directory covers a single concept with example code and explanations:

```
01_hello-assembly/           👉 Your first assembly run!
02_moving-data-around/       👉 Moving data between registers and immediates
03_store-to-memory/          👉 Store/load data to memory
04_making-decisions/         👉 Conditional branches and function calls
05_doing-math/               👉 Arithmetic operations (add, sub, neg)
06_comparing-values/         👉 Comparing values with CMP
07_advanced-topics/          👉 Loops, floating point, pointers, arrays, etc.
```

Each folder contains:
- Assembly and/or C code files
- A `README.md` with goals, explanations, and run instructions


## Getting Started

### Prerequisites

- `arm-none-eabi-gcc` toolchain
- `qemu-system-arm` and `gdb-multiarch` or `arm-none-eabi-gdb`
- Basic understanding of C (helpful but not required)

Install on Ubuntu:
```bash
$ sudo apt install gcc-arm-none-eabi qemu gdb-multiarch
```

## Who Is This For?
•	Students learning computer architecture or embedded systems
•	Developers curious about how C translates to machine code
•	Anyone who wants to really understand what’s happening under the hood

## Contributing

If you’d like to:
•	Add examples for new instructions
•	Improve explanations
•	Fix errors or typos

Feel free to submit a Pull Request or open an Issue!

## Recommended Reading
* [ARM Documents](https://github.com/ARM-software/abi-aa)

## License

This project is licensed under the MIT License.

Happy Hacking!
– seojuncha