global main
extern printf

section .data
    msg db "Testing %i...", 0xa, 0x0 ; 0x0 indicates the end of the string
    debug_info db '1'
    space db 0xa

main:
    ; prolog of function
    push ebp
    mov ebp, esp

    ; Printing debug info
    mov eax, 4
    mov ebx, 1
    mov edx, 1
    mov ecx, debug_info
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov edx, 1
    mov ecx, space
    int 0x80

    ; push arguements for printf
    push 123
    push msg

    call printf

    ; return value of the function
    mov eax, 0

    mov esp, ebp
    pop ebp
    
    mov eax, 1
    mov ebx, 0
    int 0x80