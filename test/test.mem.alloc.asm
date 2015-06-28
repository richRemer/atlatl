global test_case

extern mem.alloc
extern sys.error

section .text
test_case:
    mov     rax, 0x10       ; 16 bytes
    call    mem.alloc       ; allocate memory
    cmp     rax, 0          ; check result
    jz      .error          ; null result is an error
    mov     byte[rax], 65   ; ensure memory is writable
    mov     rbx, rax        ; save ptr

    mov     rax, 0x20       ; 32 more bytes
    call    mem.alloc       ; allocate memory
    cmp     rax, 0          ; check result
    jz      .error          ; null result is an error
    mov     byte[rax], 65   ; ensure memory is writable
    cmp     rax, rbx        ; check against previous result
    jz      .error          ; should not match

    mov     rax, 0          ; 0 bytes
    call    mem.alloc       ; empty allocation
    cmp     rax, 0          ; check result
    jz      .error          ; shouldn't return null even for empty
    mov     rbx, rax        ; save 'ptr'

    mov     rax, 0          ; 0 bytes
    call    mem.alloc       ; second empty allocation
    cmp     rax, 0          ; check result
    jz      .error          ; shouldn't return null even for empty
    cmp     rax, rbx        ; check previous empty result
    jz      .error          ; should not match

    ret

    .error:
    mov     rax, -1
    call    sys.error
