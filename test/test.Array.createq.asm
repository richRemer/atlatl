global test_case

extern Array.createq
extern Array.eachq
extern std.outqln

%include "Array.inc"

section .text
test_case:
    mov     rax, 1          ; array length
    call    Array.createq   ; 1-QWord array
    mov     rbx, std.outqln ; function to call
    call    Array.eachq
    ret
