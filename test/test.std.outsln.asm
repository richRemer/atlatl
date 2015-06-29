global test_case

extern std.outsln

%include "String.inc"

section .text
test_case:
    lea     rax, [test_str] ; message
    call    std.outsln
    ret

section .data
test_str_data:  db  "Bar"
junk_data:      db  "junk"

test_str:
istruc String
    at String.pdata,    dq  test_str_data
    at String.length,   dq  3
iend
