.global _start

_start:
  mov sp, #0x7FFFFFC
  bl main
  b .
