section .data
    msg db 0xa,"Hello World!",0xa
    len equ $ - msg

section .text
global _start
_start:
    ; push a word to the stack
    push msg

    ; print it
    mov eax, 4
    mov ebx, 1
    mov ecx, [esp]
    mov edx, len

    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80