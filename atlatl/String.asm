global String.zstr

extern mem.alloc

%include "String.inc"
%include "util.inc"

; String.zstr(RAX) => RAX
; generate a null-terminated string buffer
String.zstr:                            ; String.zstr(String) => ptr
    prsv    rbx, rcx, rsi, rdi          ; preserve

    mov     rbx, rax                    ; instance
    mov     rax, [rbx+String.length]    ; string data length in bytes
    mov     rcx, rax                    ; bytes to copy
    inc     rax                         ; extra byte for null
    call    mem.alloc                   ; allocate memory
    push    rax                         ; save result

    mov     rdi, rax                    ; write buffer
    mov     rsi, [rbx+String.pdata]     ; read buffer
    rep     movsb                       ; copy string data
    mov     byte[rdi], 0x0              ; null terminator

    pop     rax                         ; recall result
    rstr    rbx, rcx, rsi, rdi          ; restore
    ret
