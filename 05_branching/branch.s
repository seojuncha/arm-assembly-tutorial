	.text
	.global _start

_start:
	mov r0, #2     @ r0 = 2
	b foo          @ Jump to foo (pc = foo)
	mov r1, r0     @ never executed

foo:               @ Label foo
	add r0, r0, #3   @ r0 = 5
	b _start         @ infinite loop (pc = _start)
