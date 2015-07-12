global test_case

extern Process.create
extern Array.eachq
extern std.outsln

%include "Process.inc"

section .text
test_case:
    lea     rax, [rsp+16]           ; argv
    call    Process.create          ; initialize Process with argv
    mov     rax, [rax+Process.argv] ; String[] argv
    mov     rbx, std.outsln         ; callback for each String
    call    Array.eachq             ; print argv
    ret
