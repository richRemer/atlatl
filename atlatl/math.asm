global math.log2

extern sys.error

%include "err.inc"

; math.log2(RAX) => RAX
; calculate base 2 logarithm of an integer
math.log2:              ; math.log2(val)
    test    rax, rax    ; validate argument
    jnz     .valid      ; arg is good if not 0
    mov     rax, EUNDEF ; log2(0) is undefined
    call    sys.error

    .valid:
    push    rcx         ; preserve
    mov     rcx, -1     ; begin count

    .shift:
    inc     rcx         ; count shift
    shr     rax, 1      ; perform shift
    jnz     .shift      ; stop at 0

    mov     rax, rcx    ; return number of shifts
    pop     rcx         ; restore
    ret
