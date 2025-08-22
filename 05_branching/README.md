# Chapter 5 - Branching

In this chapter, we learn how to use labels and branch instructions to control program flow.  
We’ll explore how the program counter (`pc`) changes with unconditional branch (`b`) and function-like branch with link (`bl`), including how the link register (`lr`) is used.

## Learning Goals
- Understand how to use labels and the `b` (branch) instruction
- Observe how the program counter (`pc`) changes during branching
- Learn how `bl` stores the return address in the link register (`lr`)
- Use `mov pc, lr` to return from a function-style call

## Included Files
| File Name            | Description |
|:---------------------|:------------|
| `branch.s`           | Demonstrates unconditional branch (`b`) and label-based jumps       |
| `branch-with-link.s` | Demonstrates function-style branching using `bl` and `mov pc, lr`   |

## How to Run
### 1. Compile/Assemble and Link
```bash
arm-none-eabi-as -march=armv4 branch.s -o branch.o
arm-none-eabi-ld -A armv4 -Ttext=0x10000 branch.o -o branch.elf

arm-none-eabi-as -march=armv4 branch-with-link.s -o branch-with-link.o
arm-none-eabi-ld -A armv4 -Ttext=0x10000 branch-with-link.o -o branch-with-link.elf
```

### 2. Run with QEMU
```bash
qemu-system-arm -machine versatilepb -nographic -kernel branch.elf -S -s
# or
qemu-system-arm -machine versatilepb -nographic -kernel branch-with-link.elf -S -s
```

### 3. Debug with gdb
```gdb
gdb-multiarch branch.elf
(gdb) target remote :1234

# Step into instructions and observe program flow
(gdb) disas _start
(gdb) info registers pc lr
(gdb) stepi         # Step into 'b' or 'bl'
(gdb) x/i $pc       # Show current instruction
```

## Explanation
### What These Examples Do
This chapter demonstrates how to change program control flow using labels and branch instructions.  
You will learn the difference between a simple jump (`b`) and a function-style call (`bl`), and how the program counter (`pc`) and link register (`lr`) are affected.

- **`branch.s`**  
  Shows how `b` (unconditional branch) jumps to a label and how instructions after a `b` are skipped.  
  It also demonstrates an infinite loop formed with a self-branch.

- **`branch-with-link.s`**  
  Shows how `bl` (branch with link) behaves like a function call.  
  The return address is stored in `lr`, and the subroutine returns using `mov pc, lr`.  
  This allows code to return to the instruction after `bl`.

These examples help you understand:
- How program control moves to a label
- How `bl` is used to implement function-like behavior
- How `lr` and `pc` work together in subroutine calls and returns

### key ARM instructions
| Instruction  | Description |
|:------------:|:--------------------------------------------------------|
| `b`          | Unconditional branch (jump) to a label                  |
| `bl`         | Branch with link: jump and save return address in lr    |
| `mov pc, lr` | Return from subroutine (manual function return)         |

## Related References


## Next Step
Next, we’ll explore how to compare values and make decisions using conditional execution and the `cmp` instruction.

Go to [`06_comparing-values`](../06_comparing-values/README.md) to learn how ARM handles **conditional branching and comparisons**.