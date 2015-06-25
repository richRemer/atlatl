global zstr.len

section .text

; zstr.len(RAX) => RAX
; calculate length of null-terminated string
zstr.len:
	mov		rdi, rax			; beginning of scan
	mov		al, 0				; scan for NULL
	mov		rcx, 0xffffffff		; limit scan to 2GiB
	repne	scasb				; scan (RCX = limit - 1 - len)
	mov		rax, 0xfffffffe		; limit - 1
	sub		rax, rcx			; length

	ret
