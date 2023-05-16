section .text
global _start
_start:
    mov ax, 10
    mov bl, 2
    div bl

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