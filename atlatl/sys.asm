global sys.exit
global sys.error

section .text

; sys.exit()
; exit with status 0
sys.exit:
    mov     rax, 60     ; sys_exit
    mov     rdi, 0      ; success
    syscall

; sys.error(RAX)
; exit with status
sys.error:              ; sys.error(status)
    mov     rdi, rax    ; status
    mov     rax, 60     ; sys_exit
    syscall
