bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll               ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dd 15
    format db "a=%d, a=%x",0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword [a] 
        push dword [a] ;ich habe das noch einmal im Stack fur die %x Operation gepuscht
        push dword format 
        call [printf] ;wir rufen die Funktion an
        add esp, 4*2 ; clean-up the stack
        ;4 fur dword und 2 anzahl der parametern
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
