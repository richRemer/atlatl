global _start

extern zstr.len
extern std.outln
extern std.outqwln

section .text
_start:
	mov		rax, app_id			; zstring app id
	call	std.outln

	mov		rbx, [rsp]			; argc
	mov		rcx, 0				; arg 0
print_args:
	inc		rcx					; next arg (skip first arg)
	cmp		rbx, rcx			; at end of args?
	jz		.break				; exit loop
	mov		rax, [rsp+rcx*8+8]	; current string arg
	push	rbx					; preserve before call
	push	rcx					; preserve before call
	call	std.outln			; print arg
	pop		rcx					; recall after call
	pop		rbx					; recall after call
	.break:

	; sys_exit
	mov     rax, 60
	mov     rdi, 0				; success
	syscall

section .data
app_id:		db		"atlatl v0.0.1α", 0x0
