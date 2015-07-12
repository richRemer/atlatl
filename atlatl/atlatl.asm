global _start

extern Process.create
extern Array.eachq
extern Array.sliceq
extern std.outln
extern std.outsln
extern zstr.eachq
extern sys.exit

%include "Process.inc"

section .text
_start:
    mov     rax, app_id             ; zstring app id
    call    std.outln

    lea     rax, [rsp+16]           ; argv
    call    Process.create          ; initialize Process object
    mov     rax, [rax+Process.argv] ; get arguments
    mov     rbx, std.outsln         ; callback for args
    call    Array.eachq             ; print argv[1:]

    call    sys.exit                ; exit with 0

section .data
app_id:     db  "atlatl v0.0.1α", 0x0
