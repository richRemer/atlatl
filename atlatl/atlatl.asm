global _start

extern zstr.len
extern std.outln
extern std.outqwln
extern zptrs.each
extern sys.exit

section .text
_start:
    mov     rax, app_id     ; zstring app id
    call    std.outln

    lea     rax, [rsp+16]   ; argv
    mov     rbx, std.outln  ; callable
    call    zptrs.each      ; std.outln each string in argv

    call    sys.exit        ; exit with 0

section .data
app_id:     db  "atlatl v0.0.1α", 0x0
