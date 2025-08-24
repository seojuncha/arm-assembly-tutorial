# Chapter 3 - Doing Math

This chapter covers basic arithmetic instructions in ARM assembly and how they affect condition flags like carry and negative.  
You’ll also learn about reverse subtraction and multiplication instructions.

## Learning Goals
- Perform basic arithmetic operations: `add`, `sub`, `mul`
- Understand the difference between `add` vs `adds`, `sub` vs `subs`
- Observe how arithmetic instructions update **CPSR flags**:
	- `C`: Carry flag (for unsigned overflow)
	- `N`: Negative flag (for sign bit result)
	- `V`: Overflow flag
- Use GDB to inspect results and condition flags

## Included Files
| File Name           | Description                                                         |
|:--------------------|:--------------------------------------------------------------------|
| `add-and-sub.s`     | Demonstrates addition and subtraction with and without flag updates |
| `reverse-sub.s`     | Uses `rsb`/`rsbs` to reverse subtraction operands                   |
| `add-carry.s`       | Demonstrates carry-out from addition using `adds`                   |
| `mul-integer.s`     | Uses `mul` and `muls` to multiply integers and observe flags        |

## How to Run
### 1. Compile and Link
```bash
arm-none-eabi-gcc -O0 -nostdlib -march=armv4 -Ttext=0x10000 add-and-sub.s -o add-and-sub.elf
```
### 2. Run with QEMU
```bash
qemu-system-arm -machine versatilepb -nographic -kernel add-and-sub.elf -S -s
```
### 3. Debug with gdb
```bash
gdb-multiarch mul-integer.elf
(gdb) target remote :1234
(gdb) info registers r0 r1 r2
(gdb) p ($cpsr >> 29) & 1    # Carry flag
(gdb) p ($cpsr >> 28) & 1    # Overflow flag
(gdb) p ($cpsr >> 31) & 1    # Negative flag
```

## Explanation
### What this example does
-	`add r0, r1, r2`: Adds r1 + r2, no flags affected.
-	`adds r0, r1, r2`: Adds and updates flags (C, N, Z, V).
-	`sub`, `subs`: Subtracts r2 from r1, optionally updating flags.
-	`rsb`, `rsbs`: Reverse subtraction (r0 = r2 - r1)
-	`mul`, `muls`: Multiplies registers, optionally updating flags.

### Carry vs Overflow: What's the Difference?
ARM provides two different flags to indicate different kinds of overflow:

| Flag | When is it set? |
|:----:|:----------------|
| `C`  | Carry flag → Unsigned overflow (or borrow for subtraction) |
| `V`  | Overflow flag → Signed overflow (e.g. positive result wraps to negative) |

### Key ARM Arithmetic Instructions
| Instruction | Description                           |
|:------------|:--------------------------------------|
|`add`        | Add two registers                     |
|`adds`       | Add and update flags                  |
|`sub`        | Subtract one register from another    |
|`subs`       | Subtract and update flags             |
|`rsb`        | Reverse subtract (R2 - R1)            |
|`rsbs`       | Reverse subtract with flags           |
|`mul`        | Multiply two registers                |
|`muls`       | Multiply and update flags             |

> `s` suffix means CPSR flags will be updated.
> Use GDB to inspect C (carry) and N (negative) flag changes.

## ️ Next Step
Now that you've covered the basics of arithmetic operations in ARM,  
let’s move on to how we can **store and load values to and from memory** using instructions like `str` and `ldr`.

Go to [`04_store-to-memory`](../04_store-to-memory/README.md) to learn **how memory access works** in ARM assembly.
