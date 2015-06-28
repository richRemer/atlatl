global test_case

extern math.log2

section .text
test_case:
    mov     rax, 0          ; math.log2
    call    math.log2       ; should error
    ret
