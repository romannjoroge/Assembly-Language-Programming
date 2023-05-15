section .text
global main
extern printf

section .data
    msg db "Testing %i...", 0xa, 0x0 ; 0x0 indicates the end of the string

main:
    ; prolog of function
    push ebp
    mov ebp, esp

    ; push arguements for printf
    push 123
    push msg

    call printf

    ; return value of the function
    mov eax, 0

    mov esp, ebp
    pop ebp
    ret