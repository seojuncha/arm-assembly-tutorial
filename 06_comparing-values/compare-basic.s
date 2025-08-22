	.text
	.global _start
_start:
	mov r0, #42       @ r0 = 42
	mov r1, #42       @ r1 = 42

	cmp r0, r1        @ Z flag = 1, r0 - r1 = 0
	beq equal         @ taken
	mov r2, #0        @ not taken if r0 == r1

equal:
	mov r2, #1        @ r2 = 1, only if r0 == r1

	cmp r0, #100    @ r0 - 100 = negative → N=1, Z=0
	blt less_than     @ taken
	mov r3, #0        @ not taken if r0 < 100

less_than:
	mov r3, #2        @ r3 = 2

	b .               @ infinite loop
