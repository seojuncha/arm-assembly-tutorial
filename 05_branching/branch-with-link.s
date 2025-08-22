	.text
	.global _start
_start:
	mov r0, #2        @ r0 = 2
	bl foo            @ branch to foo, and store return address in `lr`
	mov r1, r0        @ r1 = r0 = 5 after return
	b .
foo:
	add r0, r0, #3    @ r0 = 5
	mov pc, lr        @ return to caller
