bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    m dd 11101011001110011111000101011101b
    n dd 11011001010000111010011101010111b
    p dd 0 ;p soll 7561A17C als Ergebnis sein
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ebx ,0
        ;die Bits 7-20 von P sind die gleichen wie die Bits 7-20 von (M UND N)
        mov eax, [m]
        mov ecx, [n]
        and eax,ecx ;EAX wird (M UND N) sein
        and eax, 00000000000111111111111110000000b
        or ebx,eax ;ich fuge die Bits in das Ergebnis ein
         
        ;die Bits 0-6 von P sind die gleichen wie die Bits 10-16 von M
        mov eax, [m]
        sar eax, 10 ;ich verschibe 10 Positionen nach rechts
        and eax, 00000000000000000000000001111111b ;ich isoliere die Bits 0-6 von P
        or ebx ,eax ;ich fuge die Bits in das Ergebnis ein
        
        ;die Bits 21-31 von P sind gleich den Bits 1-11 von N
        mov eax,[n]
        sal eax,20 ;ich verschiebe 20 Positionen nach links
        and eax, 11111111111000000000000000000000b ;ich isoliere die Bits 21-31 von P
        or ebx,eax ;ich fuge die Bits in das Ergebnis ein
        
        mov [p],eax 
        ;exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
