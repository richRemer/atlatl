global test_case

extern String.createz
extern std.outsln

%include "String.inc"

section .text
test_case:
    mov     rax, test_zstr  ; create arg
    call    String.createz  ; create new String
    call    std.outsln      ; print String
    ret

section .data
test_zstr:  db  "Bar", 0x0
junk_data:  db  "junk"
