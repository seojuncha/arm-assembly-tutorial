	.text
	.global _start
_start:
	mov r0, #2       @ r0 = 2
	rsb r0, r0, #0   @ r0 = 0-r0 = 0-2 = -2
	add r1, r0, #5   @ r1 = (-2)+5 = 3
	sub r2, r1, r0   @ r2 = 3-(-2) = 5
	rsb r3, r1, r0   @ r3 = (-2)-3 = -5
	b .