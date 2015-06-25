global zptrs.each
global zptrs.len

section .text

; zptrs.len(RAX) => RAX
; calculate length of null terminated array of pointers
zptrs.len:
	mov		rdi, rax		; beginning of scan
	mov		rax, 0			; scan for NULL
	mov		rcx, 0x1fffffff ; limit scan to 2GiB
	repne	scasq			; scan (RCX = limit - 1 - len)
	mov		rax, 0x1ffffffe	; limit - 1
	sub		rax, rcx		; length

	ret

; zptrs.each(RAX, RBX)
; call function for each pointer
zptrs.each:					; zptrs.each(zptrs, func)
	push	rax				; preserve
	call	zptrs.len		; calculate length
	lea		rcx, [rax+1]	; length + 1
	pop		rax				; restore address of first pointer

	.invoke:
	dec		rcx				; decrement counter
	jz		.exit			; break on counter reaching 0
	push	rcx				; preserve
	push	rax				; preserve
	push	rbx				; preserve
	mov		rax, [rax]		; current value
	call	rbx				; invoke callback
	pop		rbx				; restore
	pop		rax				; restore
	pop		rcx				; restore
	add		rax, 8			; adjust to next pointer
	jmp		.invoke			; loop

	.exit:
	ret
