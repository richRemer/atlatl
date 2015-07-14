global test_case

extern Array.lfindq
extern sys.error

%include "Array.inc"

section .text
test_case:
    mov     rax, test_array         ; Array to search
    mov     rbx, 0x2                ; search for 0x2
    call    Array.lfindq            ; find offset
    call    sys.error               ; exit with offset

section .data
test_qwords:    dq  0x1, 0x2, 0x3, 0x4, 0x5, 0x6

test_array:
istruc Array
    at Array.pdata,     dq  test_qwords
    at Array.length,    dq  6
iend
