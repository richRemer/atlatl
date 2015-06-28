global test_case

extern sys.error
extern zstr.len

section .text
test_case:
    lea     rax, [str]
    call    zstr.len
    cmp     rax, 7
    jnz     .error

    ret

    .error:
    mov     rax, -1
    call    sys.error

section .data
str:    db  "1234567", 0x0
