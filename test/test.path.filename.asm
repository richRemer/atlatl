global test_case

extern path.filename
extern std.outsln

%include "String.inc"

section .text
test_case:
    mov     rax, fullpath_str   ; argument
    call    path.filename       ; extract filename
    call    std.outsln          ; print filename
    ret

section .data
fullpath:       db  "/path/to/filename.ext"
fullpath_len:   equ $-fullpath

fullpath_str:
istruc String
    at String.pdata,    dq  fullpath
    at String.length,   dq  fullpath_len
iend
