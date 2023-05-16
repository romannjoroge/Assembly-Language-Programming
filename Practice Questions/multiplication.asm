section .text
global _start
_start:
    ; multiply 2 by 4
    mov al, 2
    mov bl, 4
    mul bl

    push ax
    add [esp], byte '0'

    mov eax, 4
    mov ebx, 1
    mov ecx, esp
    mov edx, 1
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80

    