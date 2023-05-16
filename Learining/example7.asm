; defining start of program
global _start:

_start:
    call func
    ; exit program
    mov eax, 1
    int 0x80

func:
    mov ebx, 43
    ; pops the location of the next line to call into eax
    ret
