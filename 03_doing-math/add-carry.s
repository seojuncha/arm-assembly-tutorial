	.text
	.global _start
_start:
	mvn r0, #0
	add r1, r0, #1
	adds r1, r0, #1
	b .