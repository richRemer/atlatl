global  fs.stat

extern mem.alloc

%include "util.inc"
%include "fs.inc"

; fs.stat(RAX) => RAX
; get statistics about a file path
fs.stat:                            ; fs.stat(zstr) => Stat
    mov     rdi, rax                ; file path
    mov     rax, Stat.size          ; buffer
    call    mem.alloc               ; allocate memory

    push    rax                     ; preserve buffer
    prsv    rcx, rdx, rsi, rdi, rsp ; preserve for syscall
    prsv    r8, r9, r10, r11        ; preserve for syscall

    mov     rsi, rax                ; buffer target
    mov     rax, 4                  ; sys_stat
    syscall

    rstr    r8, r9, r10, r11        ; restore
    rstr    rcx, rdx, rsi, rdi, rsp ; restore
    pop     rax                     ; stat ptr

    ret
