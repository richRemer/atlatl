global path.filename
global path.basename
global path.ext
global path.dirname

extern String.create
extern String.slice
extern String.rfind
extern String.after
extern Array.createb
extern Array.sliceb
extern Array.rfindb
extern Array.afterb

%include "String.inc"

; path.filename(RAX) => RAX
; strip directory information from filesystem path
path.filename:                          ; path.filename(String) => String
    push    rbx                         ; preserve
    mov     rbx, 47                     ; '/'
    call    String.after                ; after '/' is filename
    pop     rbx                         ; restore
    ret

; path.slice_ext(RAX) => RAX, RBX
; slice filename into two parts at extension
path.slice_ext:                         ; path.slice_ext(String) => String
    push    rax                         ; preserve filename
    mov     rbx, 46                     ; '.'
    call    String.rfind                ; search for last '.'
    mov     rbx, rax                    ; offset within filename
    pop     rax                         ; restore filename

    test    rbx, rbx                    ; check offset
    jz      .no_ext                     ; ensure extension was found
    call    String.slice                ; slice at offset
    ret                                 ; return slices

    .no_ext:
    push    rax                         ; preserve filename
    mov     rax, 0                      ; empty
    call    String.create               ; empty extension
    mov     rbx, rax                    ; extension in 'after' slice
    pop     rax                         ; restore filename as 'before' slice
    ret

; path.ext(RAX) => RAX
; strip everything but the extension from filesystem path (w/ dot)
path.ext:                               ; path.ext(String) => String
    push    rbx                         ; preserve
    call    path.filename               ; strip directory info
    call    path.slice_ext              ; slice at extension
    mov     rax, rbx                    ; result
    pop     rbx                         ; restore
    ret

; path.basename(RAX) => RAX
; strip directory information and extension from filesystem path
path.basename:                          ; path.basename(String) => String
    push    rbx                         ; preserve
    call    path.filename               ; strip directory info
    call    path.slice_ext              ; slice at extension
    pop     rbx                         ; restore
    ret

; path.dirname(RAX) => RAX
; strip file from path, leaving directory info only
path.dirname:                           ; path.dirname(String) => String
    push    rbx                         ; preserve
    push    rax                         ; preserve argument
    mov     rbx, 47                     ; '/'
    call    String.rfind                ; search from right
    mov     rbx, rax                    ; offset
    pop     rax                         ; restore argument
    call    String.slice                ; slice before last '/'
    pop     rbx                         ; restore
    ret
