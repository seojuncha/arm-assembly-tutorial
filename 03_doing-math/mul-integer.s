	.text
	.global _start
_start:
	mov r0, #3       @ r0 = 3
	mov r1, #5       @ r1 = 5
	mvn r2, r0       @ r2 = ~r0 = -4
	mul r3, r0, r1   @ r3 = r0xr1 = 3x5 = 15
	muls r1, r0, r2  @ r1 = r0xr2 = 3x(-4) = -12
	b .