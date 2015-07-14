global test_case

extern Array.afterq
extern Array.eachq
extern std.outq
extern std.outln
extern sys.error

%include "Array.inc"

section .text
test_case:
    mov     rax, test_array         ; Array to split
    mov     rbx, 2                  ; delimit with value 2
    call    Array.afterq            ; split into two arrays

    push    qword[rbx+Array.length] ; preserve leftover length
    mov     rbx, std.outq           ; fn to call
    call    Array.eachq             ; print values from array

    mov     rax, empty_str          ; empty message
    call    std.outln               ; end line

    pop     rax                     ; restore length
    call    sys.error               ; exit with array length

section .data
test_qwords:    dq  0x1, 0x2, 0x3, 0x4
empty_str:      db  0x0

test_array:
istruc Array
    at Array.pdata,     dq  test_qwords
    at Array.length,    dq  4
iend
