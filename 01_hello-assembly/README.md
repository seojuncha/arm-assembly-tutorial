# Topic: Hello Assembly!
This is the first step in our ARMv4 assembly tutorial series.  
We'll start by writing a minimal assembly program, compile it using a cross-compiler, run it with QEMU, and debug it using GDB.

## Learning Goals
- Cross-compile a C/Assembly program for the ARMv4 architecture
- Run an ELF binary on QEMU with `-kernel`
- Debug the program using GDB while QEMU is paused
- Understand the required components of an assembly source file (e.g., `.text`, `_start`)
- Inspect ELF files using `readelf` and `objdump`

## Included Files
| File Name | Description |
|:---|:---|
| `call-only-main.c`  | C file that defines `main()` and is called from `_start` using `start.s` |
| `only-main.s`       | A minimal assembly file that defines `_start` as the entry point |
| `start.s` *(outside)* | Defines `_start` and calls `main()` (used with `call-only-main.c`) |
| `link.ld` *(outside)* | Minimal linker script to define memory layout |


> `start.s` and `link.ld` are assumed to be in the parent directory (`../`).

## How to Run
### 1. Compile and Link 
#### Option A. C + Assembly
```bash
arm-none-eabi-gcc \
	-O0 \
	-fomit-frame-pointer \
	-nostdlib \
	-march=armv4 \
	-T ../link.ld \
	../start.s call-only-main.c \
	-o call-only-main.elf
```

#### Option B. Assembly Only
```bash
arm-none-eabi-gcc -O0 -nostdlib -march=armv4 -Ttext=0x10000 only-main.s -o only-main.elf
```
Or using `as` and `ld` manually:
```bash
arm-none-eabi-as -march=armv4  only-main.s -o only-main.o
arm-none-eabi-ld -A armv4 -Ttext=0x10000 only-main.o -o only-main.elf
```

### 2. Run with QEMU
```bash
qemu-system-arm \
	-machine versatilepb \
	-nographic \
	-kernel only-main.elf \
	-S -s
```
-	`-S`: freeze CPU at startup (wait for debugger)
-	`-s`: shorthand for -gdb tcp::1234 (opens GDB server on port 1234)

### 3. Debug with gdb
```bash
gdb-multiarch only-main.elf
(gdb) target remote :1234
(gdb) info registers r0 r1
(gdb) stepi
```
-	`target remote :1234`: Connect to QEMU’s GDB server
-	`info registers`: Inspect register values
-	`stepi`: Execute one instruction at a time

## Explanation
### What this example does
-	Defines `_start` as the program entry point
-	Optionally calls a `main()` function from C
-	Shows how to link and run a minimal ELF binary on QEMU
-	Serves as the foundation for all following tutorials

### Key ARM Directives & Instructions
| Directive / Instruction | Description |
|:---|:---|
| .text          | Start of the code section |
| .global _start | Make _start visible to linker as entry point |
| _start:        | Label used as the program’s entry point |
| bl main        | Branch with link (used to call C main()) |

## Related References
-	QEMU Documentation
-	ARM Architecture Reference Manual (v4)
-	arm-none-eabi-gcc Toolchain
-	readelf and objdump usage


## Appendix. ELF Analysis Examples
Here are examples of how to inspect your ELF binary using `readelf` and `objdump`.
This helps verify that your program entry point, sections, and instructions are all in place.

### arm-none-eabi-readelf -h (ELF Header)
```bash
arm-none-eabi-readelf -h only-main.elf
```

<details>
<summary>Sample Output</summary>

```
ELF Header:
  Magic:   7f 45 4c 46 01 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF32
  Data:                              2's complement, little endian
  Machine:                           ARM
  Entry point address:               0x10000
  Start of program headers:          52 (bytes into file)
  Start of section headers:          4560 (bytes into file)
```
</details>

Check that:
-	Entry point address is 0x10000 (as set in link.ld)
-	Machine is ARM
-	Class is ELF32

### arm-none-eabi-readelf -S (Section Header)
```bash
arm-none-eabi-readelf -S only-main.elf
```

<details>
<summary>Sample Output</summary>

```
Section Headers:
  [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            00000000 000000 000000 00      0   0  0
  [ 1] .text             PROGBITS        00010000 001000 000004 00  AX  0   0  4
```

</details>

Verify:
-	`.text` starts at `0x10000`


### arm-none-eabi-objdump -d (Disassembly)
```bash
arm-none-eabi-objdump -d only-main.elf
```
<details>
<summary> Sample Output </summary>

```
call-only-main.elf:     file format elf32-littlearm

Disassembly of section .text:

00010000 <_start>:
   10000:       e3a0d801        mov     sp, #65536      @ 0x10000
   10004:       eb000000        bl      1000c <main>
   10008:       eafffffe        b       10008 <_start+0x8>

0001000c <main>:
   1000c:       e3a03009        mov     r3, #9
   10010:       e1a00003        mov     r0, r3
   10014:       e1a0f00e        mov     pc, lr
```

</details>

What’s going on:
| Address | Instruction | Explanation |
|:--|:--|:--|
| 0x10000 | mov sp, #0x10000 | Set stack pointer to top of RAM |
| 0x10004 | bl main | Branch with link (call main) |
| 0x10008 | b . | Inifinite loop (halt) |



## Next Steps
Go to [`02_moving-data-around`](../02_moving-data-around/README.md) to learn how to __move data between registers__ using `mov` and other basic instructions.