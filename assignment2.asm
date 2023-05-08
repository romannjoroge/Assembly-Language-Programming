section	.text
   global _start     ;must be declared for linker (ld)
_start:	            ;tells linker entry point 

   ;msg to write
   mov ecx, msg0    
   ;message 0 length
   mov	edx,msg_small
   sub edx, ecx	     
   mov	ebx,1       ;file descriptor (stdout)
   mov	eax,4       ;system call number (sys_write)
   int	0x80        ;call kernel
   
   ;Reading
   mov	edx,1     ;expected length of input
   mov	ecx,num     ;address to store input
   mov	ebx,0       ;file descriptor (stdin)
   mov	eax,3       ;system call number (sys_read)
   int	0x80        ;call kernel

   ;comparing
   mov eax,0     ;initialise eax so the higher 24 bits are zero
   mov al, [num]     ;
   sub al, '0'   ;it is the ascii code of the number that was entered. get the actual digit

   ;compare the input with 2
   cmp eax, 2
   jle very_small_number ; if <= 2, jump to print very_small_number

   ;compare the input with 5
   cmp eax, 5
   jle small_number ; if <= 5, jump to print small_number
;compare the input with 7
   cmp eax, 7
    jle average_number; if <= 7, jump to print average_number

   ;print large number otherwise
   mov edx, len_large
   mov ecx, msg_large ;message to write
   jmp printing

   ;print small number
   small_number:
   mov edx, len_small
   mov	ecx, msg_small     ;message to write
   jmp printing

    ;very_small_number
   very_small_number:
   mov edx, len_very_small
   mov	ecx, msg_very_small     ;message to write
   jmp printing

   ;print average number
   average_number:
   mov edx, len_average
   mov ecx, msg_average ;message to write
   jmp printing

   printing:
   ;print the message that was selected. 
   ;some registers are already setup for the system call during the selection 
   mov	ebx,1       ;file descriptor (stdout)
   mov	eax,4       ;system call number (sys_write)
   int	0x80        ;call kernel	
   ;exit the program    			
   mov	eax,1       ;system call number (sys_exit)
   int	0x80        ;call kernel

   section	.data
   msg0 db 'Enter a one digit number: '
   msg_small db 0xa,'Small number',0xa
   len_small equ $-msg_small
   msg_average db 0xa,'Average number',0xa
   len_average equ $-msg_average
   msg_large db 0xa,'Large number',0xa
   len_large equ $-msg_large
   msg_very_small db 0xa,'Very Small Number',0xa
   len_very_small equ $-msg_very_small

   section .bss
   num resb 1