global Process.create

extern Array.createq
extern String.createz
extern zstr.lenq
extern zstr.lenb
extern mem.alloc

%include "Array.inc"
%include "String.inc"
%include "Process.inc"
%include "util.inc"

; Process.create(RAX, RBX) => RAX
; initialize process with argv (RBX reserved for future env arg)
Process.create:                     ; Process.create(zstr ptr) => Process
    prsv    rcx, rsi, rdi           ; preserve

    push    rax                     ; argv
    call    zstr.lenq               ; number of arguments
    call    Array.createq           ; Array to hold Strings

    mov     rcx, [rax+Array.length] ; number of zstr ptrs in argv
    pop     rsi                     ; argv is read buffer
    mov     rdi, [rax+Array.pdata]  ; array data is write buffer
    rep     movsq                   ; copy zstr ptrs

    push    rax                     ; preserve Array
    mov     rbx, [rax+Array.pdata]  ; start of data
    mov     rcx, 0                  ; start count
    mov     rdi, [rax+Array.length] ; end count
    cmp     rcx, rdi                ; check initial condition
    jz      .skip_loop              ; skip over loop

    .loop:
    mov     rax, [rbx+8*rcx]        ; current zstr ptr
    call    String.createz          ; create String from zstr
    mov     [rbx+8*rcx], rax        ; update current zstr ptr to String ptr
    inc     rcx                     ; adjust counter
    cmp     rcx, rdi                ; check against array length
    jnz     .loop                   ; next zstr ptr

    .skip_loop:
    pop     rbx                     ; restore Array
    mov     rax, Process.size       ; bytes for Process instance
    call    mem.alloc               ; allocate Process
    mov     [rax+Process.argv], rbx ; set String[]

    rstr    rcx, rsi, rdi           ; restore
    ret
