global test_case

extern std.outln

section .text
test_case:
    lea     rax, [test_str] ; message
    call    std.outln
    ret

section .data
test_str:   db  "Foo", 0x0
