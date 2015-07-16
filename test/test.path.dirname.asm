global test_case

extern path.dirname
extern std.outsln

%include "String.inc"

section .text
test_case:
    mov     rax, fullpath_str   ; argument
    call    path.dirname        ; extract dirname
    call    std.outsln          ; print dirname
    ret

section .data
fullpath:       db  "/path/to/filename.ext"
fullpath_len:   equ $-fullpath

fullpath_str:
istruc String
    at String.pdata,    dq  fullpath
    at String.length,   dq  fullpath_len
iend
