# Topic: Moving Data Around

This section focuses on how to move data between ARM registers and how to use shifted operands in data-processing instructions.

## Learning Goals
- Understand how to move immediate values and register values using `mov`
- Learn how ARM’s **shifted operand** mechanism works in `mov`, `add`, and other instructions
- Practice using shift operations like `lsl`, `lsr`, `asr`, `ror`, and `rrx`
- Examine how flags (e.g. carry) are affected using the `s` suffix
- Learn how GDB can be used to inspect flags and results in registers

## Included Files
| File Name | Description |
|:---|:---|
| `store-imm-to-reg.s`   | Store an immediate value directly into a register |
| `store-reg-to-reg.s`   | Copy the contents of one register into another |
| `shift-operand.s`      | Use shifted operand syntax with `mov` and inspect flag effects |

## How to Run
### 1. Assemble and Link
```bash
arm-none-eabi-as -march=armv4 shift-operand.s -o shift-operand.o
arm-none-eabi-ld -A armv4 -Ttext=0x10000 shift-operand.o -o shift-operand.elf
```

### 2. Run with QEMU
```bash
qemu-system-arm \
  -machine versatilepb \
  -nographic \
  -kernel shift-operand.elf \
  -S -s
```

### 3. Debug with gdb
```bash
gdb-multiarch shift-operand.elf
(gdb) target remote :1234
(gdb) info registers r0 r1 r2
(gdb) stepi
```

## Explanation
### What this example does
-	`mov r0, #2`
	- Loads the immediate value `2` into register `r0`. The `#` symbol means it’s an *immediate literal*.
-	`mov r1, r0`
	- Copies the value in `r0` into `r1`. **This is copy, not move in the destructive sense**.
-	`movs r2, r0, lsl #1`
	- Loads `r0 << 1` into `r2`, and updates condition flags (e.g. carry, zero, negative).
-	`mov r0, #-32`
	- This is encoded as `mvn r0, #31` because ARM immediate encoding uses 8-bit values rotated right.
-	ARM allows many instructions to include shifted operands, not just mov.
Example:
```armasm
add r2, r1, r0, lsr #2   @ r2 = r1 + (r0 >> 2)
```

### Checking Flags in GDB
Use the following expressions to manually inspect CPSR flags:
```bash
(gdb) p ($cpsr >> 29) & 1   # Carry flag (C)
(gdb) p ($cpsr >> 31) & 1   # Negative flag (N)
(gdb) p ($cpsr >> 30) & 1   # Zero flag (Z)
(gdb) p ($cpsr >> 28) & 1   # Overflow flag (V)
```

> The s suffix (e.g. `movs`, `adds`) is required to update the flags.

### Key ARM Instructions & Shift Operations
| Instruction | Description |
|:---:|:---|
|`mov`| Move immediate or register value |
|`movs`| Same as mov but updates CPSR flags |
|`mvn`| Move bitwise NOT of immediate value |
|`lsl`| Logical Shift Left |
|`lsr`| Logical Shift Right |
|`asr`| Arithmetic Shift Right |
|`ror`| Rotate Right |
|`rrx`| Rotate Right with Extend (uses carry) |


## Related References
-	ARM Data Processing Instruction Encoding
-	Shift Operations in ARM
-	ARMv4 Architecture Manual

## Appendix: Sample Output
You can use objdump to disassemble the binary:
```bash
arm-none-eabi-objdump -d shift-operand.elf
```

<details>
<summary> Expected output snippet: </summary>

```
shift-operand.elf:     file format elf32-littlearm


Disassembly of section .text:

00010000 <_start>:
   10000:       e3a00003        mov     r0, #3
   10004:       e1a01000        mov     r1, r0
   10008:       e3a020ff        mov     r2, #255        @ 0xff
   1000c:       e1a00101        lsl     r0, r1, #2
   10010:       e1a02132        lsr     r2, r2, r1
   10014:       e3e0001f        mvn     r0, #31
   10018:       e1a010c0        asr     r1, r0, #1
   1001c:       e1a020a0        lsr     r2, r0, #1
   10020:       e3a00096        mov     r0, #150        @ 0x96
   10024:       e1a01260        ror     r1, r0, #4
   10028:       e3a00069        mov     r0, #105        @ 0x69
   1002c:       e1b01060        rrxs    r1, r0
   10030:       eafffffe        b       10030 <_start+0x30>
```
</details>

Then use GDB to verify:
```bash
(gdb) info registers
(gdb) p ($cpsr >> 29) & 1
```

## Next Step

Now that you've learned how to move data between registers and use shift operations in ARM,
let’s move on to **basic arithmetic instructions** like `add`, `sub`, and `neg`.

Go to [`03_doing-math`](../03_doing-math/README.md) to **learn how arithmetic works at the instruction level**.