	.text
	.global _start
_start:
	mov r0, #2      @ r0 = 2
	mov r1, #5      @ r1 = 5
	add r0, r0, r1  @ r0 = r0+r1 = 2+5 = 7
	sub r1, r0, r1  @ r1 = r0-r1 = 7-5 = 2
	b .