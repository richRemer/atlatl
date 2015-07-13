global test_case

extern Array.sliceb
extern Array.eachb
extern std.outb
extern std.outln
extern sys.error

%include "Array.inc"

section .text
test_case:
    mov     rax, test_arrayb        ; Array to slice
    mov     rbx, 4                  ; at offset 2
    call    Array.sliceb            ; slice into two arrays

    push    qword[rax+Array.length] ; preserve length
    mov     rbx, std.outb           ; fn to call
    call    Array.eachb             ; print values from array

    mov     rax, empty_str          ; empty message
    call    std.outln               ; end line

    pop     rax                     ; restore length
    call    sys.error               ; exit with array length

section .data
test_bytes: db  0x1, 0x2, 0x3, 0x4, 0x5, 0x6
empty_str:  db  0x0

test_arrayb:
istruc Array
    at Array.pdata,     dq  test_bytes
    at Array.length,    dq  6
iend
