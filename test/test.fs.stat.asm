global test_case

extern fs.stat
extern sys.error

%include "fs.inc"

section .text
test_case:
    lea     rax, [test_path]        ; test filesystem path
    call    fs.stat                 ; get file stats

    mov     rbx, rax                ; stat result

    mov     rax, [rbx+Stat.dev_id]  ; device
    cmp     rax, 0                  ; test value
    jz      .error                  ; should be non-zero

    mov     rax, [rbx+Stat.inode]   ; inode
    cmp     rax, 0                  ; test value
    jz      .error                  ; should be non-zero

    mov     rax, [rbx+Stat.nlinks]  ; nlinks
    cmp     rax, 0                  ; test value
    jz      .error                  ; should be non-zero

    mov     rax, [rbx+Stat.mode]    ; mode
    and     rax, 0x124              ; read bits
    jz      .error                  ; file statted; must be readable

    ret

    .error:
    mov     rax, -1
    call    sys.error

section .data
test_path:   db  "/tmp", 0x0
