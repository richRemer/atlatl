global mem.alloc
global mem.free
global mem.realloc
global mem.index
global mem.create_index

extern sys.error

%define ENOMEM  0x55
%define ENOIMP  0x11

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
    push    rbx                             ; preserve
    push    rdi                             ; preserve

    mov     rbx, rax                        ; save requested size

    mov     rax, 12                         ; sys_brk
    mov     rdi, 0                          ; get current brk
    syscall

    mov     rdi, rax                        ; current brk
    add     rdi, rbx                        ; + requested bytes
    mov     rax, 12                         ; sys_brk
    syscall

    cmp     rax, 0                          ; result should be new brk
    jge     .exit                           ; all good

    mov     rax, ENOMEM                     ; out of memory
    call    sys.error

    .exit:
    sub     rax, rbx                        ; ptr to new memory
    pop     rdi                             ; restore
    pop     rbx                             ; restore
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
mem.index:  resq    1
mem.zeros:  resq    1
