global test_case

extern std.outqln

section .text
test_case:
    mov     rax, 1          ; value
    call    std.outqln      ; print value
    ret
