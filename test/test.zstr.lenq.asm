global test_case

extern sys.error
extern zstr.lenq

section .text
test_case:
    lea     rax, [strq]
    call    zstr.lenq
    cmp     rax, 3
    jnz     .error

    ret

    .error:
    mov     rax, -1
    call    sys.error

section .data
strq:   dq  0x1, 0x2, 0x3, 0x0
