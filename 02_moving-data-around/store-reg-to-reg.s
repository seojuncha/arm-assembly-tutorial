	.text
	.global _start
_start:
	mov r0, #2  @ r0 = 2
	mov r1, r0  @ r1 = r0 = 2
	b .         @ Infinite loop(halt)
