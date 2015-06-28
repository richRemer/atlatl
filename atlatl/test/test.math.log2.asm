global test_case

extern math.log2
extern sys.error

test_case:
    mov     rax, 1          ; argument
    call    math.log2       ; calculate
    cmp     rax, 0          ; should return 0
    jnz     .error          ; failed test

    mov     rax, 2          ; argument
    call    math.log2       ; calculate
    cmp     rax, 1          ; should return 1
    jnz     .error          ; failed test

    mov     rax, 3          ; argument
    call    math.log2       ; calculate
    cmp     rax, 1          ; should return 1
    jnz     .error          ; failed test

    mov     rax, 4          ; argument
    call    math.log2       ; calculate
    cmp     rax, 2          ; should return 2
    jnz     .error          ; failed test

    mov     rax, 73         ; argument
    call    math.log2       ; calculate
    cmp     rax, 6          ; should return 6
    jnz     .error          ; failed test

    ret

    .error:
    mov     rax, -1
    call    sys.error
