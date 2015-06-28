global test_case

extern sys.error

section .text
test_case:
    mov     rax, 42
    call    sys.error
