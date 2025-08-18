.global _start

_start:
  mov sp, #0x10000
  bl main
  b .
