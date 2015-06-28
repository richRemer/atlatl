global _start

extern test_case
extern sys.exit

section .text
_start:
    call    test_case
    call    sys.exit
