global _start

extern zstr.len
extern std.outln
extern std.outqwln
extern zptrs.each

section .text
_start:
    mov     rax, app_id     ; zstring app id
    call    std.outln

    lea     rax, [rsp+16]   ; argv
    mov     rbx, std.outln  ; callable
    call    zptrs.each      ; std.outln each string in argv

    mov     rax, 60         ; sys_exit
    mov     rdi, 0          ; success
    syscall

section .data
app_id:     db  "atlatl v0.0.1α", 0x0
