bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
        
extern printf, scanf, exit ; add printf and scanf as extern functions
import printf msvcrt.dll
import exit msvcrt.dll ; tell the assembler that function
;printf is found in msvcrt.dll library
import scanf msvcrt.dll

extern operation
global a
global b ;diese Variablen benutze ich in function.asm auch
global c
global result
global format
; our data is declared here (the variables needed by our program)
segment data use32 class=data public
    ; ...
    a dd 0
    b dd 0
    c dd 0
    result dd 0 ;result=a-b+c
    
    m1 db " a= ",0
    m2 db " b= ",0
    m3 db " c= ",0
    format db "%u",0
; our code starts here
segment code use32 class=code public
    start:
        ; ... 
        
        ;ich habe die erste Variable gelesen
        push dword m1
        call [printf]
        add esp,4
        push dword a
        push dword format ;a im gegeben format
        call [scanf]
        add esp,4*2 ;clear up the stack 2-Variablen
        
        ;ich habe die zweite Variable gelesen
        push dword m2
        call [printf]
        add esp,4
        push dword b
        push dword format ;b im gegeben format
        call [scanf] 
        add esp,4*2 ;clear up the stack
        
        ;ich habe die dritte Variable gelesen
        push dword m3
        call [printf]
        add esp,4
        push dword c
        push dword format ;c im dem gegeben format
        call [scanf]
        add esp,4*2 ;clear up the stack
        
        call operation
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
