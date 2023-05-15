# Assembly Language Programming
## Basics
Assembly Language is a class of languages that offer no abstraction to the underlying machine code of a machine. This makes them very dependent on the underlying architecture of the machine making the assembly languages for Intel processor machines different than those for ARM processor machines.
To run assembly code you need an **assembler** that converts the assembly code to machine code. The assembler used in this repo is **nasm**. 

## Creating an asssembly program
### Starting the program
The first lines in our assembly program tell the linker where the start of the program is 
```assembly
global _start
_start:
    ; our code
```
### Making a system call
To switch control from our program to the interrupt handler i.e to create an interrupt we make an interrupt call with the **int** command. The interrupt command takes as an operand a hex number that specifies which interrupt handler to choose. One of the interrupt handlers is the **system call interrupt** handler (0x80). The system call interrupt handler has a list of system calls it can make e.g sys_exit or sys_write. In order to tell it what call to make we place a value in the **eax** register. A **value of 1 represents the sys_exit** command while a **value of 4 represents sys_write**. Different system calls take arguements from a different number of registers. For example the sys_write call takes the **message length arguement from the edx register, pointer to the message to write from ecx register and file descriptor from ebx register**.
```assembly
mov eax, 4
mov edx, 1
mov ecx, '1'
mov ebx, 1 ; stdout file descriptor
int 0x80 ; making sys_write call

mov eax, 1 
int 0x80 ; making a sys_exit call
```

Example code for printing a number:
```assembly
    mov [msg2], byte 4
    add [msg2], byte '0'
    mov edx, 1
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    int 0x80

    mov eax, 1
    mov ebx, 0  
    int 0x80
```

### Running the program
To tell nasm to assemble the assembly and create an output(o) file that is in a format(f) that can be executed in linux(elf) that is 32 bit (elf32) we run the command
```bash
nasm -f elf32 assemblyfile.asm -o outputfile.o
```
To tell the linker to create an executable from the outputted object file we run the command
```bash
ld -m elf_i386 outputfile.o  -o executable
```
You then run the executable
```bash
./executable
```
### Instructions 
The syntax for instructions is *operation [operand1, operand2, ...]* e.g mov ebx, 1
### Variables
To add variables to our assembly program we add a section .data to our file where we define our variables and initialize them i.e if we want a varaible called msg that holds the string "Hello World\n" we do
```assembly
section .data
    msg db "Hello World", 0x0a
```
When we do this we put our code in a section .text i.e
```assembly
section .text
    global _start
_start:
    ; commands
```

### Program Control Flow
This section deals with conditions and loops.
To understand this we need to look at how the machine executes instructions. As the machine executes an instruction it updates the value of the *instruction pointer (EIP)*. The EIP holds the location of the current instruction been executed and it's value can only be changed using the **jmp** operation. 
Program control flow leverages the **jmp** operation.

To tell jump what line of code to go to we pass it a **label**. A label is created by writting some text followed by a colon. An example
```assembly
section .text
global _start
_start: 
    mov eax, 1
    mov ebx, 42
    jmp skip
    mov ebx, 13 ; this command is skipped
skip:
    int 0x80
```

#### Conditional Branching
The **jmp** operation always jumps no matter what. We would want a way to jump to a label **based on whether a condition is true or not**. This can be achieved using the following operations:
1. jl - jump if less
1. je - jump if equal
1. jne - jump if not equal
1. jg - jump if greater
1. jge - jump if greater or equal
1. jle - jump if less or equal

Using the operations above we can make a comparison using the **cmp** operation and depending on the result of the comparison jump to a different part of the code. In effect this has allowed us to implement **conditional branching** in assembly.

An example using conditional branching:
https://github.com/romannjoroge/Assembly-Language-Programming/blob/ce7b923f3b61f18962c388bf29376cf2db7523ff/assignment2.asm#L1-L82
In the example a number from 0 to 9 is taken from the user. Depending on the value of the number something different is printed.

#### Looping
Looping has similar principles. We use a register to store the number of times the loop has run, or the value we will use to determine when to stop looping. On each iteration of the loop we decrement the value in the register. At the end of each iteration we check if the ending condition is made. If it is not we make a jump back to the beginning of the loop otherwise we exit the loop
```assembly
global _start
_start:
    mov ecx, 4 ; storing condition variable in ecx
loop:
    ; do something in each iteration
    dec ecx ; change the condition variable
    cmp ecx, 0 ; check if ending condition is reached
    jg loop ; loop again if condition not met
    mov eax, 1
    int 0x80 ; end loop
```
This process can be made easier using the **loop** operator that decrements ecx, compares it to zero and if greater than 0 repeats the loop for you. The loop command assumes that the control value is stored in the ecx register.

```assembly
section .text
global _start
_start:
    mov ecx, 2
    jmp looptrial

looptrial:
    mov esi, ecx

    mov eax, 4
    mov ecx, msg2
    mov ebx, 1
    mov edx, len2
    int 0x80

    mov ecx, esi
    loop looptrial

    mov eax, 1
    mov ebx, 0
    int 0x80 
```
The loop replaces what would have been dec eax, cmp eax, 0, jg looptrial.

### Memory Access and stack operations
Let's assume we have the following data section
```assembly
section .data
    addr db "yellow"
```
**addr is a pointer that points to a location that contains yellow**
When we want to move something to the address pointed at by addr we do *mov [addr], value*. We can add an offset to the memory location i.e *mov [addr + 5], value*
**db** means one byte
**dw** means a word or 2 bytes
**dd** means 4 bytes

The stack is a data structure that is LIFO. It is an array that has stack pointer(ESP) that **points to the top of the stack**. 
When we push a value to the stack e.g *push 1234* the following happens:
1. The stack pointer is decremented by 4
1. The value is placed in that memory location

```assembly
global _start:
    push 1234
    ; this is the same as
    sub esp, 4
    mov [esp], dword 1234
```

When we pop a value from the stack the following happens:
1. The value at the top of the stack will be moved at the location
1. The stack pointer is incremented by 4

```assembly
global _start
_start:
    pop eax
    ; this is the same as
    mov eax, dword [esp]
    add esp, 4
```


### Functions 
Functions allow us to reuse code where when a function is called the execution jumps to the code for the function and then after the function runs to completion it jumps back to the position where the function was called.
The **call** operation is used to call functions, it does the following:
1. Stores the location of the next instruction to be called to the stack
1. Performs a jump to the memory location of the function

Example function call:

The **ret** operation pops a value from the stack and jumps to said location. It *returns* us to whatever value was in the stack. It is equivalent to 
```asm
pop eax
jmp eax
```

What if your function uses the stack? To preserve the state of the stack so that we can use the ret operation we can do the following:
```asm
func:
    ; incase another function called this one and is also using ebp to keep track of where to go we can save ebp
    push ebp
    mov ebp, esp
    ; change stack
    mov esp, ebp
    pop ebp
    ret
```
What this does is that it uses a special register called the **base pointer register(ebp)** to store what was on the top of the stack i.e the next function to call. *esp points to the value at the top of the stack*

So how do we pass arguements to functions and use their return values? 

### Function Arguements And Return Values
In x86 functions get their arguements from the stack. So if you want to pass arguements to a function we push them to the stack. And the called function gets them from the stack. The return values of the function are stored in registers or memory locations.
Example Code:


When we want to run code from C in assembly we use the gcc linker instead of the ld linker. The command to use the gcc linker is: 
```bash
gcc -m32 object_file.o -o executable
```

C normally defines the _start label for you so when using C code in assembly there is no need to redefine a _start label. On the other hand C expects a main function or label in your code so a main label is defined. For the functions that we want to use from C we'll have to tell nasm that they have been defined externally. The arguements for the functions are pushed to the stack, the arguements are pushed in reverse order
```assembly
global main
extern printf

section .data
    msg "Testing %i...", 0xa, 0x0 ; 0x0 indicates the end of the string

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
```

### Macros
This is another way to reuse code. They are similar to functions.
The syntax for macro definition
```assembly
%macro<macro name> <number_of_parameters>
<macro-body>
%endmacro
```
An example of a macro that prints items to the screen:


### Common operations
SUB X, Y - subtracts X from Y and stores the result in X