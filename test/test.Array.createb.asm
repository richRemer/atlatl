global test_case

extern Array.createb
extern Array.eachb
extern std.outbln

%include "Array.inc"

section .text
test_case:
    mov     rax, 1          ; array length
    call    Array.createb   ; 1-Byte array
    mov     rbx, std.outbln ; function to call
    call    Array.eachb
    ret
