global mem.alloc
global mem.free
global mem.realloc
global mem.index
global mem.create_index

extern sys.error

%define ENOMEM  0x55
%define ENOIMP  0x11

struc Entry
    .capacity:  resq    1
    .index:     resq    1
    .size:
endstruc

struc Index
    .entries:   resb    Entry.size*64
    .size:
endstruc

section .text

; mem.create_index()
; create the memory index
mem.create_index:
    push    rax             ; preserve
    push    rdi             ; preserve

    mov     rax, 12         ; sys_brk
    mov     rdi, 0          ; get current brk
    syscall

    push    rax             ; current brk
    pop     qword[mem.index]; set global index
    mov     rdi, rax        ; current brk
    add     rdi, Index.size ; add space for index
    mov     rax, 12         ; sys_brk
    syscall

    cmp     rax, 0          ; result should be new brk
    jge     .exit           ; all good

    mov     rax, ENOMEM     ; out of memory error
    call    sys.error

    .exit:
    pop     rdi             ; restore
    pop     rax             ; restore
    ret

; mem.alloc(RAX) => RAX
; allocate memory
mem.alloc:                  ; mem.alloc(size) => ptr

; mem.free(RAX)
; free memory
mem.free:                   ; mem.free(ptr)

; mem.realloc(RAX, RBX) => RAX
; reallocate memory
mem.realloc:                ; mem.free(ptr, size) => size

; unimplemented
    mov     rax, ENOIMP     ; not implemented
    call    sys.error

section .bss
mem.index:  resq    1
