global Array.createq
global Array.createb
global Array.eachq
global Array.eachb
global Array.sliceq
global Array.sliceb
global Array.lfindq
global Array.lfindb
global Array.rfindq
global Array.rfindb
global Array.splitq
global Array.splitb
global Array.beforeq
global Array.beforeb
global Array.afterq
global Array.afterb

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

; Array.lfindq(RAX, RBX) => RAX
; find offset of QWord value starting from left
Array.lfindq:                           ; Array.lfindq(Array, qword) => int
    prsv    rcx, rdi                    ; preserve

    mov     rdi, [rax+Array.pdata]      ; beginning of scan
    mov     rcx, [rax+Array.length]     ; elements to scan
    mov     rax, rbx                    ; scan for value
    mov     rbx, rcx                    ; save initial length
    repne   scasq                       ; scan (RCX = length-1-offset)
    dec     rbx                         ; length-1
    sub     rbx, rcx                    ; offset

    rstr    rcx, rdi                    ; restore
    mov     rax, rbx                    ; return offset
    ret

; Array.rfindq(RAX, RBX) => RAX
; find offset of QWord value starting from right
Array.rfindq:                           ; Array.rfindq(Array, qword) => int
    prsv    rcx, rdi                    ; preserve
    std                                 ; set direction flag

    mov     rcx, [rax+Array.length]     ; elements to scan
    mov     rdi, [rax+Array.pdata]      ; first item in Array
    mov     rax, rbx                    ; scan for value
    mov     rbx, rcx                    ; number of elements
    lea     rdi, [rdi+rbx*8-8]          ; start at last item in Array
    repne   scasq                       ; reverse scan (RCX = offset)

    cld                                 ; clear direction flag
    mov     rax, rcx                    ; return value
    rstr    rcx, rdi                    ; restore
    ret

; Array.splitq(RAX, RBX) => RAX, RBX, RCX
; split Array on QWord value
Array.splitq:                           ; Array.splitq(Array, qword) => 3-Array
    mov     rcx, rax                    ; store Array argument
    call    Array.lfindq                ; find offset of delimiter
    mov     rbx, rax                    ; offset for split
    mov     rax, rcx                    ; Array argument
    call    Array.sliceq                ; get before slice
    push    rax                         ; preserve before slice

    mov     rax, rbx                    ; delimiter/after slice
    mov     rbx, 1                      ; slice off delimiter
    call    Array.sliceq                ; slice after from delimiter

    mov     rcx, rbx                    ; after
    mov     rbx, rax                    ; delimiter
    pop     rax                         ; before

    ret

; Array.beforeq(RAX, RBX) => RAX, RBX
; split Array into part before QWord value and rest
Array.beforeq:                          ; Array.beforeq(Array,qword) => 2-Array
    push    rax                         ; preserve Array argument
    call    Array.lfindq                ; find offset of value
    mov     rbx, rax                    ; offset for slice
    pop     rax                         ; restore Array argument
    call    Array.sliceq                ; slice before/rest
    ret

; Array.afterq(RAX, RBX) => RAX, RBX
; split Array into part after QWord value and rest
Array.afterq:                           ; Array.afterq(Array,qword) => 2-Array
    push    rax                         ; preserve Array argument
    call    Array.lfindq                ; find offset of value
    inc     rax                         ; move offset after the value
    mov     rbx, rax                    ; offset for slice
    pop     rax                         ; restore Array argument
    call    Array.sliceq                ; slice rest/after
    push    rax                         ; preserve rest
    mov     rax, rbx                    ; after
    pop     rbx                         ; restore rest
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

; Array.lfindb(RAX, RBX) => RAX
; find offset of Byte value starting from left
Array.lfindb:                           ; Array.lfindb(Array, byte) => int
    prsv    rcx, rdi                    ; preserve

    mov     rdi, [rax+Array.pdata]      ; beginning of scan
    mov     rcx, [rax+Array.length]     ; elements to scan
    mov     al, bl                      ; scan for value
    mov     rbx, rcx                    ; save initial length
    repne   scasb                       ; scan (RCX = length-1-offset)
    dec     rbx                         ; length-1
    sub     rbx, rcx                    ; offset

    rstr    rcx, rdi                    ; restore
    mov     rax, rbx                    ; return offset
    ret

; Array.rfindb(RAX, RBX) => RAX
; find offset of Byte value starting from right
Array.rfindb:                           ; Array.rfindb(Array, byte) => int
    prsv    rcx, rdi                    ; preserve
    std                                 ; set direction flag

    mov     rcx, [rax+Array.length]     ; elements to scan
    mov     rdi, [rax+Array.pdata]      ; first item in Array
    mov     al, bl                      ; scan for value
    mov     rbx, rcx                    ; number of elements
    lea     rdi, [rdi+rbx-1]            ; start at last item in Array
    repne   scasb                       ; reverse scan (RCX = offset)

    cld                                 ; clear direction flag
    mov     rax, rcx                    ; return value
    rstr    rcx, rdi                    ; restore
    ret

; Array.splitb(RAX, RBX) => RAX, RBX, RCX
; split Array on Byte value
Array.splitb:                           ; Array.splitb(Array, byte) => 3-Array
    mov     rcx, rax                    ; store Array argument
    call    Array.lfindb                ; find offset of delimiter
    mov     rbx, rax                    ; offset for split
    mov     rax, rcx                    ; Array argument
    call    Array.sliceb                ; get before slice
    push    rax                         ; preserve before slice

    mov     rax, rbx                    ; delimiter/after slice
    mov     rbx, 1                      ; slice off delimiter
    call    Array.sliceb                ; slice after from delimiter

    mov     rcx, rbx                    ; after
    mov     rbx, rax                    ; delimiter
    pop     rax                         ; before

    ret

; Array.beforeb(RAX, RBX) => RAX, RBX
; split Array into part before Byte value and rest
Array.beforeb:                          ; Array.beforeb(Array,byte) => 2-Array
    push    rax                         ; preserve Array argument
    call    Array.lfindb                ; find offset of value
    mov     rbx, rax                    ; offset for slice
    pop     rax                         ; restore Array argument
    call    Array.sliceb                ; slice before/rest
    ret

; Array.afterb(RAX, RBX) => RAX, RBX
; split Array into part after Byte value and rest
Array.afterb:                           ; Array.afterb(Array,byte) => 2-Array
    push    rax                         ; preserve Array argument
    call    Array.lfindb                ; find offset of value
    inc     rax                         ; move offset after the value
    mov     rbx, rax                    ; offset for slice
    pop     rax                         ; restore Array argument
    call    Array.sliceb                ; slice rest/after
    push    rax                         ; preserve rest
    mov     rax, rbx                    ; after
    pop     rbx                         ; restore rest
    ret
