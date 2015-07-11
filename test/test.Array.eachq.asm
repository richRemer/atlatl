global test_case

extern Array.eachq
extern std.outqln

%include "Array.inc"

section .text
test_case:
    mov     rbx, std.outqln ; function to call
    lea     rax, [test_arr] ; array
    call    Array.eachq
    ret

section .data
test_arr_data:  dq  0x0102030405060708

test_arr:
istruc Array
    at Array.pdata,     dq  test_arr_data
    at Array.length,    dq  1
iend
