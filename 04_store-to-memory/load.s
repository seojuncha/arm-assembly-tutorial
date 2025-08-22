	.text
	.global _start
_start:
	mov r0, #0x7fffffc    @ r0 points to RAM boundary (top addressable memory)
	mov r1, #32						@ r1 = 32
	mov r2, #16						@ r2 = 16
	mov r3, #4						@ r3 = 4

	str r1, [r0]					@ Store 32 at address r0 → 0x7fffffc

	str r2, [r0, -r3]			@ Store 16 at address (r0 - r3) → 0x7fffff8

	ldr r1, [r0], -r3			@ Load r1 from [r0] = 0x7fffffc → r1 = 32
												@ Then subtract r3 from r0 → r0 = 0x7fffff8 (post-indexed)

	ldr r2, [r0, r3]!			@ Pre-increment r0 by r3 → r0 = 0x7fffffc
												@ Then load r2 from [r0] = 0x7fffffc → r2 = 32

	b .
