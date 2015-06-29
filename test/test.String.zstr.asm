global test_case

extern String.zstr
extern std.outln

%include "String.inc"

section .text
test_case:
    lea     rax, [test_str] ; message
    call    String.zstr
    call    std.outln
    ret

section .data
test_str_data:  db  "Foo"
junk_data:      db  "junk"

test_str:
istruc String
    at String.pdata,    dq  test_str_data
    at String.length,   dq  3
iend
