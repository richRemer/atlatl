global test_case

extern Array.sliceq
extern Array.eachq
extern std.outq
extern std.outln
extern sys.error

%include "Array.inc"

section .text
test_case:
    mov     rax, test_arrayq        ; Array to slice
    mov     rbx, 2                  ; at offset 2
    call    Array.sliceq            ; slice into two arrays

    push    qword[rax+Array.length] ; preserve length
    mov     rbx, std.outq           ; fn to call
    call    Array.eachq             ; print values from array

    mov     rax, empty_str          ; empty message
    call    std.outln               ; end line

    pop     rax                     ; restore length
    call    sys.error               ; exit with array length

section .data
test_qwords:    dq  0x1, 0x2, 0x3
empty_str:      db  0x0

test_arrayq:
istruc Array
    at Array.pdata,     dq  test_qwords
    at Array.length,    dq  3
iend
