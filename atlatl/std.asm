global std.out
global std.outln
global std.outq
global std.outqln
global std.endln

extern zstr.len

%include "util.inc"

section .text

; std.out(RAX)
; print null-terminated string to stdout
std.out:
    prsv    rcx, rdx, rsi, rdi, rsp ; preserve for syscall
    prsv    r8, r9, r10, r11        ; preserve for syscall

    mov     rsi, rax                ; message
    call    zstr.len                ; measure string
    mov     rdx, rax                ; message length
    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    syscall

    rstr    r8, r9, r10, r11        ; restore
    rstr    rcx, rdx, rsi, rdi, rsp ; restore
    ret

; std.outln(RAX)
; print null-terminated string to stdout, followed by newline
std.outln:
    call    std.out                 ; echo string

    prsv    rcx, rdx, rsi, rdi, rsp ; preserve for syscall
    prsv    r8, r9, r10, r11        ; preserve for syscall

    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, std.endln          ; message
    mov     rdx, 1                  ; length
    syscall

    rstr    r8, r9, r10, r11        ; restore
    rstr    rcx, rdx, rsi, rdi, rsp ; restore
    ret

; std.outq(RAX)
; print QWord in hex to stdout
std.outq:
    prsv    rcx, rdx, rsi, rdi, rsp ; preserve for syscall
    prsv    r8, r9, r10, r11        ; preserve for syscall

    mov     rcx, 16                 ; number of characters
    .char:
    mov     rdx, rax                ; make copy
    and     rdx, 0xf                ; mask low bits
    mov     rsi, hexits             ; read buffer
    lea     rdi, [rsp-16]           ; write buffer
    mov     dl, [rsi+rdx]           ; lookup hexit
    mov     [rdi+rcx-1], dl         ; move hexit into buffer
    shr     rax, 4                  ; consume bits
    dec     rcx                     ; decrement character counter
    jnz     .char                   ; loop to next character

    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    lea     rsi, [rsp-16]           ; message
    mov     rdx, 16                 ; number of characters
    syscall

    rstr    r8, r9, r10, r11        ; restore
    rstr    rcx, rdx, rsi, rdi, rsp ; restore
    ret

; std.outqln(RAX)
; print QWord in hex to stdout, followed by newline
std.outqln:
    call    std.outq                ; echo value

    prsv    rcx, rdx, rsi, rdi, rsp ; preserve for syscall
    prsv    r8, r9, r10, r11        ; preserve for syscall

    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, std.endln          ; message
    mov     rdx, 1                  ; number of characters
    syscall

    rstr    r8, r9, r10, r11        ; restore
    rstr    rcx, rdx, rsi, rdi, rsp ; restore
    ret

section .data
hexits:     db  "0123456789ABCDEF"
std.endln:  db  0xa, 0x0
