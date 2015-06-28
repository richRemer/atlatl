global test_case

extern std.outdln

section .text
test_case:
    mov     rax, 2          ; value
    call    std.outdln      ; print value
    ret
