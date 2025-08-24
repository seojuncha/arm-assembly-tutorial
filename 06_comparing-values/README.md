# Chapter 6 - Comparing Values
This chapter introduces how to compare values in ARM assembly using `cmp` and `cmn` instructions, and how to make decisions with conditional branches. You will learn the difference between signed and unsigned comparisons and how to detect equality, overflow, and carry using the condition flags in the CPSR register.

## Learning Goals
-	Understand how to compare two values using `cmp` and `cmn`.
-	Observe how comparison affects `CPSR` flags (especially `Z`, `N`, `C`, and `V`).
-	Learn how to use **conditional branches** based on those flags.
-	Distinguish between **signed** and **unsigned** comparisons in ARM.

## Included Files
| File Name          |  Description |
|:-------------------|:------------------------------------------------------------------------|
| `compare-basic.s`  | Basic comparison using cmp and conditional branches                     |
| `compare-signed.s` | Compare signed vs unsigned values using appropriate branch instructions |
| `compare-cmn.s`    | Use cmn instruction to simulate comparison via addition                 |


## How to Run
### 1. Compile/Assemble and Link
```bash
arm-none-eabi-as -march=armv4 compare-basic.s -o compare-basic.o
arm-none-eabi-ld -Ttext=0x10000 compare-basic.o -o compare-basic.elf
```
### 2. Run with QEMU
```bash
qemu-system-arm -machine versatilepb -nographic -kernel compare-basic.elf -S -s
```
### 3. Debug with gdb
```gdb
gdb-multiarch compare-basic.elf
(gdb) target remote :1234
(gdb) info registers
(gdb) p ($cpsr >> 31) & 1    # N flag
(gdb) p ($cpsr >> 30) & 1    # Z flag
(gdb) p ($cpsr >> 29) & 1    # C flag
(gdb) p ($cpsr >> 28) & 1    # V flag
```

## Explanation
### What this example does
**compare-basic.s**
-	Compares two integers using `cmp`.
-	Performs a conditional branch based on the result.
-	Demonstrates how **Z (zero)** and **N (negative)** flags are set after the comparison.

Example:
```armasm
cmp r0, r1       @ Sets flags based on r0 - r1
beq equal_label  @ Branch if r0 == r1 (Z == 1)
```

**compare-signed.s**
-	Tests behavior of signed comparisons (positive and negative numbers).
-	Uses `bge`, `blt`, `bgt`, `ble` to demonstrate control flow based on signed flag interpretation.
-	Also shows contrast with unsigned conditions using `bcs`, `bcc`.

**compare-cmn.s**
-	Uses `cmn` to demonstrate setting flags from addition instead of subtraction.
-	Highlights the use of `cmn` as an alternative to `cmp` in some conditional logic scenarios.

### key ARM instructions
| Instruction | Description
|:-:|:-|
| `cmp` | Subtracts two values and updates flags (no result stored)    |
| `cmn` | Adds two values and updates flags (no result stored)         |
| `beq` | Branch if equal (Z == 1)                                     |
| `bne` | Branch if not equal (Z == 0)                                 |
| `bgt` | Branch if greater than (signed)                              |
| `blt` | Branch if less than (signed)                                 |
| `bge` | Branch if greater or equal (signed)                          |
| `ble` | Branch if less or equal (signed)                             |
| `bcs` | Branch if carry set (unsigned ≥)                             |
| `bcc` | Branch if carry clear (unsigned <)                           |

## Next Step
Next chapter: **Chapter 7 – Advanced Topics**

In the next chapter, we move beyond the basics and explore more advanced ARM topics. You'll learn how to implement loops, handle C-style arrays and structures, use `static` and `extern` variables, manage function calls and the call stack, and even touch on heap memory management.
