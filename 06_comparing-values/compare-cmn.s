	.text
	.global _start
_start:
	mov r0, #10
	mov r1, #-10

	cmn r0, r1        @ r0 + r1 = 0 → Z = 1
	beq sum_is_zero   @ taken

	mov r2, #0        @ not executed

sum_is_zero:
	mov r2, #42       @ executed

	mov r0, #0x7fffffff
	mov r1, #1

	cmn r0, r1        @ r0 + r1 = overflow → V = 1
	bvs overflow_detected

	mov r3, #0        @ not executed

overflow_detected:
	mov r3, #99       @ executed

	b .