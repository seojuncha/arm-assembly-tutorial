# Chapter 4 - Store to Memory

In this chapter, we learn how to store and load data between registers and memory using ARM’s `str` and `ldr` instructions.  
We also explore how C variable assignments are translated into assembly, and how stack memory grows and shrinks during function calls.

## Learning Goals
- Understand how the stack grows and shrinks from a memory layout perspective
- Learn how `str` and `ldr` instructions interact with memory and registers
- Practice various addressing modes (immediate, register offset, pre/post index)
- See how variable assignment in C translates into assembly

## Included Files
| File Name      | Description                                                                       |
|:---------------|:----------------------------------------------------------------------------------|
| `assignment.c` | A simple C program to observe how local variables are stored on the stack         |
| `assignment.s` | Assembly version of the C code, manually or via compiler (`-S`)                   |
| `store.s`      | Demonstrates multiple addressing modes for `str` (store register to memory)       |
| `load.s`       | Demonstrates multiple addressing modes for `ldr` (load from memory into register) |

## How to Run
### 1. Compile/Assemble and Link
#### For `assignment.c` (with C to ASM conversion)
```bash
arm-none-eabi-gcc -O0 -fomit-frame-pointer -nostdlib -march=armv4 -S assignment.c    # generate assignment.s
arm-none-eabi-as -march=armv4 assignment.s -o assignment.o
arm-none-eabi-as -march=armv4 ../start.s -o start.o
arm-none-eabi-ld -A armv4 -T ../link.ld start.o assignment.o -o assignment.elf
```

#### For assembly-only examples
```bash
arm-none-eabi-gcc -O0 -nostdlib -march=armv4 -Ttext=0x10000 store.s -o store.elf
arm-none-eabi-gcc -O0 -nostdlib -march=armv4 -Ttext=0x10000 load.s -o load.elf
```


### 2. Run with QEMU
```bash
qemu-system-arm -machine versatilepb -nographic -kernel assignment.elf -S -s
```

### 3. Debug with gdb
```gdb
(gdb) target remote :1234

# Check values stored on the stack
(gdb) x/1x 0x7fffff8+4     # Examine memory at SP + 4 (from assignment.s)

# Check register values from memory load
(gdb) x/1d $r0             # Check value loaded into r0
```

## Explanation
### What this example does
-	`assignment.s` shows how local variables in C are stored using `str`, retrieved with `ldr`, and returned via `mov r0, r3`.
-	`store.s` demonstrates various `str` addressing modes:
	-	[r1, #offset]
	-	[r1], #offset (post-index)
	-	[r1, #-offset]! (pre-index with write-back)
-	`load.s` mirrors this with `ldr` and shows how to read from memory using similar address modes.

### VersatilePB Memory Map (Simplified)
```
                Higher Address
  0xFFFF_FFFF  +--------------+ ← End of 32-bit address space
               |              |
               |    MMIO      |
  0x1000_0000  +--------------+
               |              |
               |              |
  0x0800_0000  +--------------+
               |              |
  0x07FF_FFFC  +--------------+ ← Top of usable RAM (128MB)
               |   Stack ↓    |
               |              |
               |              |
               |   RAM Area   |
               |              |
  0x0001_0000  +--------------+ ← .text
  0x0000_0000  +--------------+ ← Start of RAM
                Lower Address
```

-	Default RAM size is 128MB for `-m 128M`, ranging from `0x0000_0000` to `0x07FF_FFFF`.
-	Stack usually starts from the top (`0x08000000`) and **grows downward**.
-	You (the programmer) decide where to place the stack, as long as it doesn’t overlap with MMIO or `.text` sections.

### key ARM instructions
| Instruction | Description                           |
|:-----------:|:--------------------------------------|
|    `str`    | Store register value into memory      |
|    `ldr`    | Load value from memory into register  |

Use them with flexible addressing modes such as:
-	[Rn, #offset]        : immediate offset
-	[Rn], #offset        : post-indexed
-	[Rn, #-offset]!      : pre-indexed with write-back
-	[Rn, Rm], [Rn, Rm]!  : register offset with optional write-back

## Related References
-	[QEMU VersatilePB Source (C)](https://github.com/qemu/qemu/blob/master/hw/arm/versatilepb.c)
-	[QEMU Boot Implementation](https://github.com/qemu/qemu/blob/master/hw/arm/boot.c)


##  Next Step
Now that you’ve learned how to access memory using `ldr` and `str`,
we’ll move on to how to **control program flow using branches, labels, and conditional instructions**.

Go to [`05_branching`](../05_branching/README.md) to explore conditional branching.

## Bonus. GDB Memory Debugging Tips
When using `str` and `ldr`, you're moving data between registers and memory.  
Here’s how you can observe and debug memory changes directly with GDB:

### View Stack Pointer and Memory
```gdb
(gdb) info registers sp     # or "i r sp"
sp             0x7fffff4    # Current stack pointer

(gdb) x/1wx $sp             # View 1 word at address in SP
(gdb) x/1wx $sp+4           # View the memory where local variable is stored
```

You should see:
```
0x7fffff8:     0x00000009   # value of variable 'a' from assignment.s
```

### Use Decimal View
```gdb
(gdb) x/1d $sp+4
0x7fffff8:     9
```

### Watch Memory During LDR/STR
You can single-step and examine memory before and after:
```gdb
(gdb) stepi         # Execute next instruction (e.g. str)
(gdb) x/4xw $sp     # See how memory changes

(gdb) stepi         # Execute ldr
(gdb) info registers r3
```

