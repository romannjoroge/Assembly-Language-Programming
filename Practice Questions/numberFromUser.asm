section .bss
    num resb 1

section .data
    small db 0x0a,"Small Number",0xa
    lenSmall equ $-small
    medium db 0xa,"Medium Number",0xa
    lenMedium equ $-medium
    large db 0xa,"Large Number",0xa
    lenLarge equ $-large
    enterNumberMsg db 0xa,"Enter a number: "
    lenMsg equ $-enterNumberMsg

%macro enterNumber 1
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 3
    mov ecx, %1
    mov edx, 1
    mov ebx, 1
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
%endmacro

%macro printMessage 2
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 4
    mov ebx, 1
    mov edx, %1
    mov ecx, %2
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
%endmacro


section .text
    global _start
_start:
    ; Ask user to enter a number
    printMessage lenMsg, enterNumberMsg

    ; enter a number from user
    enterNumber num

    ; convert number from ASCII to num
    sub [num], byte '0'

    ; if number is greater than 7 write large
    cmp [num],  byte 7
    jge print_large

    ; else if number is greater than 3 print medium
    cmp [num], byte 3
    jg print_medium

    ; else print smallecx
    jmp print_small

print_small:
    printMessage lenSmall, small
    jmp end

print_medium:
    printMessage lenMedium, medium
    jmp end

print_large:
    printMessage lenLarge, large
    jmp end

end:
    mov eax, 1
    mov ebx, 0 
    int 0x80
