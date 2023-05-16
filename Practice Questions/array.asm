section .data
    arr1 db 1, 2, 3, 4, 5
    arr2 db 2, 3, 4, 5, 6
    lenArr equ $-arr2
    msg db "The number is %d", 0xa, 0x0
    lenMsg equ $-msg

section .bss
    arr3 resb 5
    num1 resb 1
    num2 resb 1

%macro add2NumFromArray 3
    add [%1], %2
    add [%1], %3
%endmacro

%macro printArray 1
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, 1
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
%endmacro


section .text
    global _start:
_start:
    ; add all numbers in the array
    mov ecx, lenArr
    jmp addNumbers

addNumbers:
    mov ebx, ecx
    sub ebx, 4
    mov eax, arr3
    add eax, ebx
    mov edx, arr1
    add edx, ebx
    mov edx, [edx]
    add ebx, arr2
    mov ebx, [ebx]
    add2NumFromArray eax, edx, ebx
    loop addNumbers
    mov ecx, lenArr
    jmp printarray

printarray:
    mov ebx, ecx
    sub ebx, 4
    mov edx, arr3
    add edx, ebx
    add [edx], byte '0'
    printArray edx
    loop printarray
    jmp end

end:
    mov eax, 1
    mov ebx, 0
    int 0x80