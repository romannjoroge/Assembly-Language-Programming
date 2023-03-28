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
To switch control from our program to the interrupt handler i.e to create an interrupt we make an interrupt call with the **int** command. The interrupt command takes as an operand a hex number that specifies which interrupt handler to choose. One of the interrupt handlers is the **system call interrupt** handler (0x80). The system call interrupt handler has a list of system calls it can make e.g sys_exit or sys_write. In order to tell it what call to make we place a value in the **eax** register. A **value of 1 represents the sys_exit** command while a **value of 4 represents sys_write**. Different system calls take arguements from a different number of registers. For example the sys_write call takes the **message length arguement from the edx register, message to write from ecx register and file descriptor from ebx register**.
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
The syntax for instructions is *operation [operand1, operand2, ...]* e.g moc ebx, 1
### Variables
To add variables to our assembly program we add a section .data to our file where we define our variables and initialize them i.e if we want a varaible called msg that holds the string "Hello World\n" we do
```assembly
section .data
    msg db "Hello World", 0x0a
```
When we do this we put our code in a section .text i.e
```assembly
section .data
_start:
    ; commands
```
