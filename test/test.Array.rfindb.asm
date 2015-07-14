global test_case

extern Array.rfindb
extern sys.error

%include "Array.inc"

section .text
test_case:
    mov     rax, test_array         ; Array to search
    mov     rbx, 0x5                ; search for 0x5
    call    Array.rfindb            ; find offset
    call    sys.error               ; exit with offset

section .data
test_bytes: db  0x1, 0x2, 0x3, 0x4, 0x5, 0x6

test_array:
istruc Array
    at Array.pdata,     dq  test_bytes
    at Array.length,    dq  6
iend
