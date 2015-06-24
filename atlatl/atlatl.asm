global _start
extern zstr.len

section .text
_start:
	mov		rax, app_id			; zstring app id
	call	outln

	mov		rbx, [rsp]			; argc
	mov		rcx, 0				; arg 0
print_args:
	inc		rcx					; next arg (skip first arg)
	cmp		rbx, rcx			; at end of args?
	jz		print_args_break	; exit loop
	mov		rax, [rsp+rcx*8+8]	; current string arg
	push	rbx					; preserve before call
	push	rcx					; preserve before call
	call	outln				; print arg
	pop		rcx					; recall after call
	pop		rbx					; recall after call
	print_args_break:

	; sys_exit
	mov     rax, 60
	mov     rdi, 0				; success
	syscall

; out(RAX)
; echo null-terminated string to stdout
out:							; outln(ZSTRING)
	push	rax					; preserve arg
	call	zstr.len			; measure string

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
	mov		rsi, outln_endln	; message
	mov		rdx, 0x1			; length
	syscall

	ret
	outln_endln:	db	0xa

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

section .data
hexits:		db		"0123456789ABCDEF"
app_id:		db		"atlatl v0.0.1α", 0x0

section .bss
qwbuf:	resb	16
