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
There is also the dedicated **loop** instruction that performs the same operations above. It assumes that the value of the control variable is at the ecx register and that the loop will end when the value in the ecx register is 0. 

An example using the loop command



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
    mov ebp, esp
    ; change stack
    mov esp, ebp
    ret
```
What this does is that it uses a special register called the **base pointer register(ebp)** to store what was on the top of the stack i.e the next function to call. *esp points to the value at the top of the stack*

So how do we pass arguements to functions and use their return values? 

### Function Arguements And Return Values
Functions get their arguements from the stack. So we access the values from their
Example Code:

