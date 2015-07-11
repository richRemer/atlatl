global test_case

extern Array.eachb
extern std.outbln

%include "Array.inc"

section .text
test_case:
    mov     rbx, std.outbln ; function to call
    lea     rax, [test_arr] ; array
    call    Array.eachb
    ret

section .data
test_arr_data:  dq  0x0102030405060708

test_arr:
istruc Array
    at Array.pdata,     dq  test_arr_data
    at Array.length,    dq  8
iend
