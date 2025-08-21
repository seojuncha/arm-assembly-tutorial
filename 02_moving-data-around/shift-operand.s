	.text
	.global _start
_start:
	@ Basic data moves (mov)
	mov r0, #3           @ r0 = 3
	mov r1, r0           @ r1 = r0 = 3
	mov r2, #0xff        @ r2 = 255

	@ Logical Shift (lsl, lsr)
	mov r0, r1, lsl #2   @ r0 = r1<<2 = 3<<2 = 12
	mov r2, r2, lsr r1   @ r1 = r2>>r1 = 255>>3 = 31

	@ Arithmetic Shift (asr)
	mov r0, #-32         @ r0 = 0xffffffe0 = -32 (signed) 
	mov r1, r0, asr #1   @ r1 = r0 >> 1 (signed) = -16 (0xfffffff0) 
	mov r2, r0, lsr #1   @ r2 = r0 >> 1 (unsigned) = 0x7ffffff0

	@ Rotate Shift (ror)
	mov r0, #0x96          @ r0 = 0x96 = 0b00000000_00000000_00000000_10010110
	mov r1, r0, ror #4     @ r1 = r0 rotated right 4 bits = 0x60000009
												 @ 0b0...0_1001_0110
												 @ 0b0...0_1011
												 @ 0b10...0_0101
												 @ 0b110...0_0010
												 @ 0b0110...0_1001 = 0x6000_0009

	@ Rotate right with extend (rrx)
	mov r0, #0x69       @ 0x69 = 0b0...0110_1001
	movs r1, r0, rrx    @ 0b0...0011_0100 = 0x34 (carry set to 1)

	b .
