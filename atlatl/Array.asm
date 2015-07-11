global Array.createq
global Array.createb
global Array.eachq
global Array.eachb

extern mem.alloc
extern math.log2

%include "Array.inc"

; Array.createq(RAX) => RAX
; create new QWord array with specified length
Array.createq:                          ; Array.createq(int) => Array
    push    rax                         ; length
    shl     rax, 3                      ; 8B per item
    call    mem.alloc                   ; array data
    push    rax                         ; pdata

    mov     rax, Array.size             ; bytes for new array (no data)
    call    mem.alloc                   ; allocate array

    pop     qword[rax+Array.pdata]      ; set pdata
    pop     qword[rax+Array.length]     ; set length

    ret

; Array.eachq(RAX, RBX)
; call function for each item in QWord array
Array.eachq:                            ; Array.eachq(Array, fn)
    push    rcx                         ; preserve

    mov     rcx, [rax+Array.length]     ; iterations
    mov     rax, [rax+Array.pdata]      ; start of data
    inc     rcx                         ; offset for loop

    .loop:
    dec     rcx                         ; count down
    jz      .exit                       ; break on counter 0
    push    rax                         ; preserve
    mov     rax, [rax]                  ; current value
    call    rbx                         ; execute callback
    pop     rax                         ; restore
    add     rax, 8                      ; next ptr
    jmp     .loop

    .exit:
    pop     rcx                         ; restore
    ret

; Array.createb(RAX) => RAX
; create new Byte array with specified length
Array.createb:                          ; Array.createb(int) => Array
    push    rax                         ; length
    call    mem.alloc                   ; array data
    push    rax                         ; pdata

    mov     rax, Array.size             ; bytes for new array (no data)
    call    mem.alloc                   ; allocate array

    pop     qword[rax+Array.pdata]      ; set pdata
    pop     qword[rax+Array.length]     ; set length

    ret

; Array.eachb(RAX, RBX)
; call function for each item in Byte array
Array.eachb:                            ; Array.eachb(Array, fn)
    push    rcx                         ; preserve

    mov     rcx, [rax+Array.length]     ; iterations
    mov     rax, [rax+Array.pdata]      ; start of data
    inc     rcx                         ; offset for loop

    .loop:
    dec     rcx                         ; count down
    jz      .exit                       ; break on counter 0
    push    rax                         ; preserve
    mov     al, byte[rax]               ; current value
    call    rbx                         ; execute callback
    pop     rax                         ; restore
    inc     rax                         ; next ptr
    jmp     .loop

    .exit:
    pop     rcx                         ; restore
    ret
