section .data
    array db 1, 2, 3, 4, 5    ; array of 8-bit integers
    array_format db "%d ", 0  ; format string for printing each array element
    array_len equ $-array     ; calculate the length of the array

section .text
    extern printf
    global _start

_start:
    ; set up the stack frame for calling printf
    push array_len          ; push the argument for the array length
    push array_format       ; push the format string for each array element
    push dword array        ; push the address of the array
    call printf             ; call the printf function
    add esp, 12             ; adjust the stack pointer to remove the arguments

    ; exit the program
    mov eax, 1              ; system call for exit
    xor ebx, ebx            ; exit code 0
    int 0x80