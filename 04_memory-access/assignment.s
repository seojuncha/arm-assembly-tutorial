	.arch armv4
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"assignment.c"
	.text
	.align	2
	.global	main
	.syntax unified
	.arm
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	sub	sp, sp, #8       @ Allocate 8 bytes on the stack (stack grows down)
											 @ sp = sp - 8
											 @ Assume SP starts at 0x7FFFFFC: Now SP = 0x7FFFFF4

	mov	r3, #9           @ r3 = 9 (value to store)

	str	r3, [sp, #4]     @ Store r3 at address (SP + 4) → [0x7FFFFF4 + 4] = 0x7FFFFF8
											 @ This simulates: int a = 9;

	ldr	r3, [sp, #4]     @ Load back value from 0x7FFFFF8 into r3

	mov	r0, r3           @ Return a → move r3 (which is 9) into r0 (return value)

	add	sp, sp, #8       @ Deallocate stack frame (SP = SP + 8 → back to original SP)

	@ sp needed
	mov	pc, lr           @ Return from main()
	.size	main, .-main
	.ident	"GCC: (Arm GNU Toolchain 14.2.Rel1 (Build arm-14.52)) 14.2.1 20241119"
