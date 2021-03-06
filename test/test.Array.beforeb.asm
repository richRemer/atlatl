global test_case

extern Array.beforeb
extern Array.eachb
extern std.outb
extern std.outln
extern sys.error

%include "Array.inc"

section .text
test_case:
    mov     rax, test_array         ; Array to split
    mov     rbx, 3                  ; delimit with value 3
    call    Array.beforeb           ; split into two arrays

    push    qword[rbx+Array.length] ; preserve leftover length
    mov     rbx, std.outb           ; fn to call
    call    Array.eachb             ; print values from array

    mov     rax, empty_str          ; empty message
    call    std.outln               ; end line

    pop     rax                     ; restore length
    call    sys.error               ; exit with array length

section .data
test_bytes: db  0x1, 0x2, 0x3, 0x4
empty_str:  db  0x0

test_array:
istruc Array
    at Array.pdata,     dq  test_bytes
    at Array.length,    dq  4
iend
