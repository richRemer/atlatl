global _start

section .text
_start:
	; sys_write
	mov     rax, 1
	mov     rdi, 1				; stdout
	mov     rsi, msg
	mov     rdx, len
	syscall

	; output RAX value
	mov		rax, 32
	call	qwoutln

	; sys_exit
	mov     rax, 60
	mov     rdi, 0				; success
	syscall

; qwout(RAX)
; echo 64 bit value to stdout
qwout:							; qwout(value)

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
qwoutln:						; qwoutln(value)
	call	qwout				; echo value

	mov		byte[qwbuf], 0xa	; put newline in buffer
	mov		rax, 1				; sys_write
	mov		rdi, 1				; stdout
	mov		rsi, qwbuf			; message
	mov		rdx, 0x1			; number of characters
	syscall

	ret

section .data
hexits:	db		"0123456789ABCDEF"
msg:    db      "Hello, foo!", 0xa
len:    equ     $ - msg

section .bss
qwbuf:	resb	16
