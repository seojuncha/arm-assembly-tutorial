	.text
	.global _start
_start:
	@ C = 1, V = 0 (unsigned overflow, no signed overflow)
	mov     r0, #0xFFFFFFFF
	adds    r1, r0, #1        @ r1 = 0, C=1, V=0

	@ C = 0, V = 1 (signed overflow: positive wraps to negative)
	mov     r2, #0x7FFFFFFF   @ Max positive signed int
	adds    r3, r2, #1        @ r3 = 0x80000000, interpreted as negative

	@ C = 1, V = 0 (subtraction with borrow)
	mov     r4, #0
	subs    r5, r4, #1        @ r5 = 0xFFFFFFFF = -1

	b .
