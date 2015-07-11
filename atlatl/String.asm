global String.createz
global String.zstr

extern mem.alloc
extern zstr.len

%include "String.inc"
%include "util.inc"

; String.createz(RAX) => RAX
; create a String object from a null-terminated string buffer
String.createz:                         ; String.createz(ptr) => String
    push    rax                         ; preserve ptr to buffer
    call    zstr.len                    ; calculate length
    push    rax                         ; save length
    mov     rax, String.size            ; bytes for new String
    call    mem.alloc                   ; create instance
    pop     qword[rax+String.length]    ; set String.length
    pop     qword[rax+String.pdata]     ; set String.pdata
    ret

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
