global Array.createq
global Array.eachq
global Array.sliceq
global Array.createb
global Array.eachb
global Array.sliceb

extern mem.alloc
extern math.log2

%include "Array.inc"
%include "util.inc"

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

; Array.sliceq(RAX, RBX) => RAX, RBX
; slice array into two at offset
Array.sliceq:                           ; Array.sliceq(Array,int)=>Array,Array
    prsv    rcx, rdx                    ; preserve
    push    rax                         ; preserve Array argument

    mov     rax, [rax+Array.length]     ; length
    cmp     rax, rbx                    ; compare to offset
    jge     .offset_ok                  ; check if offset is within length
    mov     rbx, rax                    ; move offset to end of array

    .offset_ok:
    pop     rcx                         ; restore Array argument

    mov     rax, 0                      ; empty
    call    Array.createq               ; create 'after' Array
    push    qword[rcx+Array.length]     ; copy Array argument length
    pop     qword[rax+Array.length]     ; into 'after' length
    push    qword[rcx+Array.pdata]      ; copy Array data pointer
    pop     qword[rax+Array.pdata]      ; to 'after' Array

    sub     [rax+Array.length], rbx     ; subtract offset from length
    push    rbx                         ; save offset
    shl     rbx, 3                      ; 8-Bytes per item offset
    add     [rax+Array.pdata], rbx      ; move 'after' pointer to offset
    pop     rdx                         ; restore offset
    mov     rbx, rax                    ; set 'after' result

    mov     rax, 0                      ; empty
    call    Array.createq               ; create 'before' Array result
    mov     [rax+Array.length], rdx     ; set 'before' length to offset
    push    qword [rcx+Array.pdata]     ; copy Array data pointer
    pop     qword [rax+Array.pdata]     ; to 'before' Array

    rstr    rcx, rdx                    ; restore
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

; Array.sliceb(RAX, RBX) => RAX, RBX
; slice array into two at offset
Array.sliceb:                           ; Array.sliceb(Array,int)=>Array,Array
    prsv    rcx, rdx                    ; preserve
    push    rax                         ; preserve Array argument

    mov     rax, [rax+Array.length]     ; length
    cmp     rax, rbx                    ; compare to offset
    jge     .offset_ok                  ; check if offset is within length
    mov     rbx, rax                    ; move offset to end of array

    .offset_ok:
    pop     rcx                         ; restore Array argument

    mov     rax, 0                      ; empty
    call    Array.createb               ; create 'after' Array
    push    qword[rcx+Array.length]     ; copy Array argument length
    pop     qword[rax+Array.length]     ; into 'after' length
    push    qword[rcx+Array.pdata]      ; copy Array data pointer
    pop     qword[rax+Array.pdata]      ; to 'after' Array

    sub     [rax+Array.length], rbx     ; subtract offset from length
    add     [rax+Array.pdata], rbx      ; move 'after' pointer to offset
    mov     rdx, rbx                    ; set offset
    mov     rbx, rax                    ; set 'after' result

    mov     rax, 0                      ; empty
    call    Array.createb               ; create 'before' Array result
    mov     [rax+Array.length], rdx     ; set 'before' length to offset
    push    qword [rcx+Array.pdata]     ; copy Array data pointer
    pop     qword [rax+Array.pdata]     ; to 'before' Array

    rstr    rcx, rdx                    ; restore
    ret
