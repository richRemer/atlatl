global sys.exit

section .text

; sys.exit()
; exit with status 0
sys.exit:
    mov     rax, 60     ; sys_exit
    mov     rdi, 0      ; success
    syscall
