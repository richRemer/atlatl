global test_case

extern std.outbln

section .text
test_case:
    mov     rax, 3          ; value
    call    std.outbln      ; print value
    ret
