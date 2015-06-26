global zstr.len
global zstr.lenq
global zstr.eachq

section .text

; zstr.len(RAX) => RAX
; calculate length of null-terminated string
zstr.len:                   ; zstr.len(ptr) => length
    mov     rdi, rax        ; beginning of scan
    mov     al, 0           ; scan for NULL
    mov     rcx, 0xffffffff ; limit scan to 2GiB
    repne   scasb           ; scan (RCX = limit-1-length)
    mov     rax, 0xfffffffe ; limit - 1
    sub     rax, rcx        ; length

    ret

; zstr.lenq(RAX) => RAX
; calculate length of null-terminated string of QWords
zstr.lenq:                  ; zstr.lenq(ptr) => length
    mov     rdi, rax        ; beginning of scan
    mov     rax, 0          ; scan for NULL
    mov     rcx, 0x1fffffff ; limit scan to 2GiB
    repne   scasq           ; scan (RCX = limit-1-length)
    mov     rax, 0x1ffffffe ; limit - 1
    sub     rax, rcx        ; length

    ret

; zstr.eachq(RAX, RBX)
; call subroutine for values in null-terminated string of QWords
zstr.eachq:                 ; zstr.eachq(ptr, fn)
    push    rax             ; preserve
    call    zstr.lenq       ; calculate length
    lea     rcx, [rax+1]    ; length + 1
    pop     rax             ; restore address of first value

    .invoke:
    dec     rcx             ; decrement counter
    jz      .exit           ; break on counter reaching 0
    push    rax             ; preserve
    push    rbx             ; preserve
    push    rcx             ; preserve
    mov     rax, [rax]      ; current value
    call    rbx             ; invoke callback
    pop     rcx             ; restore
    pop     rbx             ; restore
    pop     rax             ; restore
    add     rax, 8          ; adjust to next pointer
    jmp     .invoke         ; loop

    .exit:
    ret
