# Chapter 2 - Moving Data Around

This section focuses on how to move data between ARM registers and how to use shifted operands in **data-processing instructions**.

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
-	ARM allows many instructions to include shifted operands, not just `mov`.
Example:
```armasm
add r2, r1, r0, lsr #2   @ r2 = r1 + (r0 >> 2)
```

### Checking Flags in GDB
Use the following expressions to manually inspect CPSR flags:
```bash
(gdb) p ($cpsr >> 31) & 1   # Negative flag (N)
(gdb) p ($cpsr >> 30) & 1   # Zero flag (Z)
(gdb) p ($cpsr >> 29) & 1   # Carry flag (C)
(gdb) p ($cpsr >> 28) & 1   # Overflow flag (V)
```

> The s suffix (e.g. `movs`, `adds`) is required to update the flags.

### Arithmetic vs Logical Shift
ARM provides both logical and arithmetic shifts:
| Instruction | Name                    | Keeps Sign | Fills With | Typical Use     |
|:-----------:|:------------------------|:----------:|:----------:|:----------------|
| `lsl`       | Logical Shift Left      | No         | Zero       | Multiply by 2ⁿ  |
| `lsr`       | Logical Shift Right     | No         | Zero       | Unsigned divide |
| `asr`       | Arithmetic Shift Right  | Yes        | Sign bit   | Signed divide   |


### Key ARM Instructions & Shift Operations
| Instruction | Description                           |
|:-----------:|:--------------------------------------|
| `mov`       | Move immediate or register value      |
| `movs`      | Same as mov but updates CPSR flags    |
| `mvn`       | Move bitwise NOT of immediate value   |
| `lsl`       | Logical Shift Left                    |
| `lsr`       | Logical Shift Right                   |
| `asr`       | Arithmetic Shift Right                |
| `ror`       | Rotate Right                          |
| `rrx`       | Rotate Right with Extend (uses carry) |

Use `asr` when working with signed values to maintain correct sign propagation.

## Appendix A: Sample Output
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

## Appendix B: ARM Immediate Encoding (`mov` / `mvn`)

### ARM Encoding Rule Summary
ARM data-processing instructions support only a limited set of immediate values.  
These are encoded as **8-bit values rotated right by even numbers of bits**:

imm = imm8 ROR (2 * rot), where rot ∈ [0, 15]

This allows for **many**, but not all, 32-bit constants.

### Common Examples

| Source               | Assembled As       | Encodable? | Notes                       |
|:---------------------|:-------------------|:----------:|:----------------------------|
| `mov r0, #0`         | `imm8=0x00`        | Yes        | All zero                    |
| `mov r0, #255`     | `imm8=0xFF`        | Yes        | Max 8-bit                   |
| `mov r0, #0x80000000`| `0x80 ROR #28`     | Yes        | Rotated value               |
| `mov r0, #-1`        | `mvn r0, #0`       | Yes        | Bitwise NOT of 0            |
| `mov r0, #-32`       | `mvn r0, #31`      | Yes        | ~31 = 0xFFFFFFE0            |
| `mov r0, #0x100`     | —                  | No         | Not encodable               |
| `mov r0, #0x12345678`| —                  | No         | Too complex                 |

## Next Step

Now that you've learned how to move data between registers and use shift operations in ARM,
let’s move on to **basic arithmetic instructions** like `add`, `sub`, and `neg`.

Go to [`03_doing-math`](../03_doing-math/README.md) to **learn how arithmetic works at the instruction level**.


## Bonus: Python Shift Simulator
You can experiment with ARM-style shift and rotate operations using the following Python script.  
This allows you to simulate `lsr`, `asr`, `ror`, and `rrx` instructions without running QEMU or GDB.

<details>
<summary>Click to expand sample script (scripts/shift-simulator.py)</summary>

```python
def logical_shift_right(val, n, bits=32):
    mask = (1 << bits) - 1
    return (val & mask) >> n

def arithmetic_shift_right(val, n, bits=32):
    if val & (1 << (bits - 1)):   # Negative
        return ((val >> n) | ((1 << n) - 1) << (bits - n)) & ((1 << bits) - 1)
    else:   # Positive
        return val >> n

def ror(val, n, bits=32):
    n %= bits
    return ((val >> n) | (val << (bits - n))) & ((1 << bits) - 1)

def rrx(val, carry_in, bits=32):
    lsb = val & 1
    result = (carry_in << (bits - 1)) | (val >> 1)
    carry_out = lsb
    return result, carry_out

nums = [26, -32]
for x in nums:
    print(f"\n=== {x} (0x{x & 0xffffffff:08X}) ===")
    lsr = logical_shift_right(x, 1)
    asr = arithmetic_shift_right(x, 1)
    print(f"LSR 1: {lsr} [{hex(lsr)}]")
    print(f"ASR 1: {asr} [{hex(asr)}]")

x = 0x68  # 0b01101000
rot = 4
print(f"\nROR #{rot}:", hex(ror(x, rot)))

res, cout = rrx(x, 1)
print(f"RRX (carry=1): result={hex(res)}, carry_out={cout}")
```

</details>

**Example Output**
```
=== 26 (0x0000001A) ===
LSR 1: 13 [0xd]
ASR 1: 13 [0xd]

=== -32 (0xFFFFFFE0) ===
LSR 1: 2147483632 [0x7ffffff0]
ASR 1: 4294967280 [0xfffffff0]

ROR #4: 0x80000006
RRX (carry=1): result=0x80000034, carry_out=0
```

You can edit values or shift amounts and observe how results change, just like in GDB or on actual hardware.