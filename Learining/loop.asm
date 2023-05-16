;Exercise
;have two arrays of digits
;have another array that stores the result of adding the two elements at similar positions
;in the above two arrays
;print the two arrays and the result array i.e. array one 1st line, array 2 2nd line; result 3rd line

section .data
    arr1 db 1,2,3,4,5
    arr2 db 6,7,8,9,10
    len equ $-arr2
    msg db 0xa,'a',0xa
    msg2 db 0xa,'We have gone through a loop', 0xa
    len2 equ $-msg2

section .bss
    answ resb 1
    msg3 resb 3
    addition resb 1
    arr3 resb 5

section .text
global _start
_start:
    mov ecx, len
    jmp print_array


print_array:
    mov esi, ecx

    sub ecx, len
    mov edi, ecx
    mov [answ], edi

    mov eax, 4
    mov ebx, 1
    mov edx, 1
    mov ecx, answ
    int 0x80

    ; mov eax, 4
    ; mov ebx, 2
    ; mov ecx, arr1
    ; add ecx, edi
    ; add [arr1 + edi], byte '0'
    ; mov edx, 1
    ; int 0x80

    ; mov ecx, esi
    loop print_array

    mov eax, 1
    mov ebx, 0
    int 0x80

adding:
    mov esi, ecx

    ; get index of item to add
    sub ecx, 4

    mov ebx, [arr1 + ecx]
    mov eax, [arr2 + ecx]
    add ebx, eax
    mov [arr3 + ecx], ebx

    mov ecx, esi
    loop adding

end:
    mov eax, 1
    mov ebx, [adding]
    int 0x80
