section .text
%macro printFlag 1
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 4
    mov ebx, 1
    mov edx, 1
    mov ecx, %1
    add [ecx], byte '0'
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
%endmacro

global _start:
_start:
    mov eax, 4
    add eax, eax
    printFlag cf

    mov eax, 1
    mov ebx, 0
    int 0x80