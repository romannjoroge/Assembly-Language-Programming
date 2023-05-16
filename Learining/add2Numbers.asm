global _start:

_start:
    push 21
    push 2
    call add2Nums
    ; store result in ebx
    mov ebx, eax
    mov eax, 1
    int 0x80

add2Nums:
    mov ebp, esp
    mov eax, [esp+8]
    sub eax, [esp+4]
    mov esp, ebp
    ret