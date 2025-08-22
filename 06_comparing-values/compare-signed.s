	.text
	.global _start
_start:
	mov r0, #-10      @ r0 = -10
	mov r1, #20       @ r1 = 20

	cmp r0, r1        @ -10 < 20 → N=1, Z=0
	bge signed_ge     @ not taken
	blt signed_lt     @ taken

signed_ge:
	mov r2, #100      @ not executed

signed_lt:
	mov r2, #200      @ executed

	mov r0, #250      @ r0 = 250 (unsigned large)
	mov r1, #10         @ r1 = 10

	cmp r0, r1        @ 250 > 10 (unsigned)
	bcs carry_set     @ taken (C = 1)
	bcc carry_clear   @ not taken

carry_set:
	mov r3, #1

carry_clear:
	mov r3, #0        @ not executed

	b .
