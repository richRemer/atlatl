global _start

section .text
_start:
	mov     rax, 1				; sys_write
	mov     rdi, 1				; stdout
	mov     rsi, msg			; message
	mov     rdx, len			; length
	syscall

	mov		rax, [rsp]			; stack points to argc
	push	rax					; preserve argc
	call	qwoutln				; output number of arguments
	pop		rbx					; recall argc

	mov		rcx, 0				; start at arg 0
print_args:
	mov		rax, [rsp+rcx*8+8]	; current string arg
	push	rbx					; preserve before call
	push	rcx					; preserve before call
	call	outln				; print arg
	pop		rcx					; recall after call
	pop		rbx					; recall after call
	inc		rcx					; next arg
	cmp		rbx, rcx			; check if done
	jnz		print_args			; loop

	; sys_exit
	mov     rax, 60
	mov     rdi, 0				; success
	syscall

; out(RAX)
; echo null-terminated string to stdout
out:							; outln(ZSTRING)
	push	rax					; preserve arg
	call	zstrlen				; measure string

	pop		rsi					; message
	mov		rdx, rax			; length returned
	mov		rax, 1				; sys_write
	mov		rdi, 1				; stdout
	syscall

	ret

; outln(RAX)
; echo null-terminated string to stdout, followed by newline
outln:							; outln(ZSTRING)
	call	out					; echo string

	mov		rax, 1				; sys_write
	mov		rdi, 1				; stdout
	mov		rsi, endln			; message
	mov		rdx, 0x1			; length
	syscall

	ret

; qwout(RAX)
; echo 64 bit value to stdout
qwout:							; qwout(QWORD)

	mov		rcx, 0x10			; number of characters
qwout_char:
	mov		rbx, rax			; make copy
	and		rbx, 0xf 			; mask low bits
	mov		rsi, hexits			; read buffer
	mov		rdi, qwbuf			; write buffer
	mov		dl, [rbx+rsi]		; lookup hexit
	mov		[rcx+rdi-1], dl		; move hexit into buffer
	shr		rax, 4				; consume bits
	dec		rcx					; decrement character counter
	jnz		qwout_char			; loop

	mov		rax, 1				; sys_write
	mov		rdi, 1				; stdout
	mov		rsi, qwbuf			; message
	mov		rdx, 0x10			; number of characters
	syscall

	ret

; qwoutln(RAX)
; echo 64 bit value to stdout, followed by newline
qwoutln:						; qwoutln(QWORD)
	call	qwout				; echo value

	mov		byte[qwbuf], 0xa	; put newline in buffer
	mov		rax, 1				; sys_write
	mov		rdi, 1				; stdout
	mov		rsi, qwbuf			; message
	mov		rdx, 0x1			; number of characters
	syscall

	ret

; zstrlen(RAX) => RAX
; calculate length of null-terminated string
zstrlen:						; zstrlen(ZSTRING)
	mov		rdi, rax			; beginning of scan
	xor		al, al				; scan for NULL
	mov		rcx, 0xffffffff		; limit scan to 2GiB
	repne	scasb				; scan (RCX = limit - 1 - len)
	mov		rax, 0xfffffffe		; limit - 1
	sub		rax, rcx			; length

	ret

section .data
hexits:	db		"0123456789ABCDEF"
msg:    db      "Hello, foo!", 0xa
len:    equ     $ - msg
endln:	db		0xa

section .bss
qwbuf:	resb	16
