global std.out
global std.outln
global std.outqw
global std.outqwln
global std.endln

extern zstr.len

section .text

; std.out(RAX)
; print null-terminated string to stdout
std.out:
    push    rax             ; preserve arg
    call    zstr.len        ; measure string

    pop     rsi             ; message
    mov     rdx, rax        ; length returned
    mov     rax, 1          ; sys_write
    mov     rdi, 1          ; stdout
    syscall

    ret

; std.outln(RAX)
; print null-terminated string to stdout, followed by newline
std.outln:
    call    std.out         ; echo string

    mov     rax, 1          ; sys_write
    mov     rdi, 1          ; stdout
    mov     rsi, std.endln  ; message
    mov     rdx, 1          ; length
    syscall

    ret

; std.outqw(RAX)
; print QWord in hex to stdout
std.outqw:
    mov     rcx, 16         ; number of characters
    .char:
    mov     rbx, rax        ; make copy
    and     rbx, 0xf        ; mask low bits
    mov     rsi, hexits     ; read buffer
    lea     rdi, [rsp-16]   ; write buffer
    mov     dl, [rbx+rsi]   ; lookup hexit
    mov     [rcx+rdi-1], dl ; move hexit into buffer
    shr     rax, 4          ; consume bits
    dec     rcx;            ; decrement character counter
    jnz     .char           ; loop to next character

    mov     rax, 1          ; sys_write
    mov     rdi, 1          ; stdout
    lea     rsi, [rsp-16]   ; message
    mov     rdx, 16         ; number of characters
    syscall

    ret

; std.outqwln(RAX)
; print QWord in hex to stdout, followed by newline
std.outqwln:
    call    std.outqw       ; echo value

    mov     rax, 1          ; sys_write
    mov     rdi, 1          ; stdout
    mov     rsi, std.endln  ; message
    mov     rdx, 1          ; number of characters
    syscall

    ret

section .data
hexits:     db  "0123456789ABCDEF"
std.endln:  db  0xa, 0x0
