	.text
	.global _start
_start:
	mov r1, #0x7000000   @ r1 points to base address 0x7000000
	mov r2, #32          @ r2 = 32
	mov r3, #16          @ r3 = 16

	str r2, [r1, #4]     @ tore 32 at address (r1 + 4) → 0x7000004

	str r2, [r1], #8     @ Store 32 at address 0x7000000
											 @ Then increment r1 by 8 → r1 = 0x7000008 (post-indexed)

	str r3, [r1, #-8]!   @ Pre-decrement r1 by 8 → r1 = 0x7000000
											 @ Then store 16 at address 0x7000000

	b .
 