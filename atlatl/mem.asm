global mem.alloc
global mem.free
global mem.realloc
global mem.create_index

extern sys.error

%include "err.inc"
%include "util.inc"

section .text

; mem.alloc(RAX) => RAX
; allocate memory
mem.alloc:                                  ; mem.alloc(size) => ptr
    test    rax, rax                        ; check allocation size
    jnz     .non_empty                      ; non-empty allocation
    inc     qword[mem.zeros]                ; empty allocation ref
    mov     rax, [mem.zeros]                ; count
    ret

    .non_empty:
    prsv    rcx, rdx, rsi, rdi, rsp         ; preserve for syscall
    prsv    r8, r9, r10, r11                ; preserve for syscall

    mov     rdx, rax                        ; save requested size
    mov     rax, 12                         ; sys_brk
    mov     rdi, 0                          ; get current brk
    syscall

    mov     rdi, rax                        ; current brk
    add     rdi, rdx                        ; + requested bytes
    mov     rax, 12                         ; sys_brk
    syscall

    cmp     rax, 0                          ; result should be new brk
    jge     .exit                           ; all good

    mov     rax, ENOMEM                     ; out of memory
    call    sys.error

    .exit:
    sub     rax, rdx                        ; ptr to new memory
    rstr    r8, r9, r10, r11                ; restore
    rstr    rcx, rdx, rsi, rdi, rsp         ; restore
    ret

; mem.free(RAX)
; free memory (ha!)
mem.free:                                   ; mem.free(ptr)
    ret

; mem.realloc(RAX, RBX) => RAX
; reallocate memory
mem.realloc:                                ; mem.free(ptr, size) => size
    mov     rax, rbx                        ; size
    call    mem.alloc                       ; just get new memory
    ret

section .bss
mem.zeros:  resq    1
