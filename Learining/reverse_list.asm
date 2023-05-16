section .data
num db 5,7, 9, 3, 2
len equ $-num

section .text
global _start
_start:
    mov ecx, len
    dec ecx
print_loop:
    mov eax, 4
    mov ebx, 1
    lea ecx, [num + ecx]
    mov edx, 1
    int 0x80
    sub ecx, 1
    cmp ecx, -1
    jne print_loop

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

