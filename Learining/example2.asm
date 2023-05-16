section .data
    num db 5, 4, 2, 1
    eol db 0xa

section .text
global _start
_start: 
    mov eax, 4 ; sys_write command
    mov ebx, 1 ; stdout
    mov edx, 1
    add [num + 2], byte '0'
    mov ecx, num + 2
    int 0x80
    sub [num + 2], byte '0'

    mov eax, 4
    mov edx, 1
    mov ebx, 1
    add [num + 3], byte '0' ; get ascii of 4th item in list
    mov ecx, num + 3 ; mov value in num + 3 to ecx
    int 0x80
    sub [num + 3], byte '0'

    mov eax, 4
    mov ebx, 1
    mov edx, 1
    mov ecx, eol ; print end line
    int 0x80

    mov eax, 1
    int 0x80