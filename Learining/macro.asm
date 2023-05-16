section .data
    msg1 db 0xa,"This is the first message!",0xa
    len1 equ $ - msg1
    msg2 db 0xa,"This is the second message!",0xa
    len2 equ $ - msg2

%macro write_string 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

section .text
global _start
_start:
    write_string msg1, len1
    write_string msg2, len2
    mov eax, 1
    mov ebx, 0
    int 0x80