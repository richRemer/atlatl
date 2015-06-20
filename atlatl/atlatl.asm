global _start

section .text
_start:
    ; sys_write
    mov     rax, 1
    mov     rdi, 1      ; stdout
    mov     rsi, msg
    mov     rdx, len
    syscall

    ; sys_exit
    mov     rax, 60
    mov     rdi, 0      ; success
    syscall

section .data
    msg     db      "Hello, foo!", 0xa
    len     equ     $ - msg
