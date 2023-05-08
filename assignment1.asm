;ask the user to enter a number, 
;if it is less or equal than 5 small
;else print large number
;exercise
;if the number is equal or less than 3 print small number
;if the number is greater than 3 but less than 7 print average number
;else print large number
;end of exercise
section	.text
   global _start     ;must be declared for linker (ld)
_start:	            ;tells linker entry point 

   ;msg to write
   mov ecx, msg0    
   ;message 0 length
   mov	edx,len1     
   mov	ebx,1       ;file descriptor (stdout)
   mov	eax,4       ;system call number (sys_write)
   int	0x80        ;call kernel
   ;Reading
   mov	edx,4     ;expected length of input
   mov	ecx,num     ;address to store input
   mov	ebx,2       ;file descriptor (stdin)
   mov	eax,3       ;system call number (sys_read)
   int	0x80        ;call kernel

   ;comparing
   mov	eax,0     ;initialise eax so the higher 24 bits are zero
   mov al, [num]     ;
   sub al, '0';   ;it is the ascii code of the numbe that was entered. get the actual digit
   cmp eax,3; 
   jle small
   cmp eax, 7
   jle average
   jge greater; if eax is greater or equal to 5. Do the jump
   ;situation when number is small - no jump above

   small:
   mov edx, len2
   mov ecx,msg2     ;message to write 
   jmp printing ;go to the printing code- ensure the greater code is not executed
   ;end of smaller	

   ;situation when number is greater
   
   ;end of greater

   average:
   cmp eax, 7
   jge greater
   mov edx, len3
   mov ecx, msg3
   jmp printing
   
   printing:
   ;print the message that was selected. 
   ;some registers are already setup for the system call during the selection 
   mov	ebx,1       ;file descriptor (stdout)
   mov	eax,4       ;system call number (sys_write)
   int	0x80
   jmp end   
   
   greater:	
   mov edx, len1
   mov ecx, msg1 
   jmp printing; msg to write     ;call kernel	
   ;exit the program    	
   end:		
   mov	eax,1       ;system call number (sys_exit)
   int	0x80        ;call kernel

   section	.data
   msg0 db 'Enter a one digit number::'
   msg1 db 0xa,'Large number',0xa
   msg2 db 0xa,'Small number',0xa
   msg3 db 0xa,'Average number',0xa
   len3 equ $-msg3
   len2 equ msg3-msg2
   len1 equ msg1-msg2

   section .bss
   num resb 1
