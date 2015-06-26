global _start

extern mem.create_index
extern std.outln
extern zstr.eachq
extern sys.exit

section .text
_start:
    ;; initialize dynamic memory; must be called before alloc and
    ;; friends
    call    mem.create_index

    mov     rax, app_id     ; zstring app id
    call    std.outln

    lea     rax, [rsp+16]   ; argv
    mov     rbx, std.outln  ; callable
    call    zstr.eachq      ; std.outln each string in argv

    call    sys.exit        ; exit with 0

section .data
app_id:     db  "atlatl v0.0.1α", 0x0
