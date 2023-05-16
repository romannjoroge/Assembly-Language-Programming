section .data
msg db "Hello World", 0xa


section .text
global _start
extern printf
_start:

; push in stact
mov eax, msg
push eax
call printf

mov	eax,1       ;system call number (sys_exit)
int	0x80