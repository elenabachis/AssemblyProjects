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
    a dw 1010011110100110b
    b dw 0111110001101011b
    c dd 0      ;c soll nach der Anweisungen 11111111111111110011011000001101b
                ;also FFF360D
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        mov ebx, 0 ;ich berechne das Ergebnis in bx
        ;die Bits 4-7 von C haben automatisch den Wert 0
        ;die Bits 16-31 von C haben den Wert 1 
        or ebx, 11111111111111110000000000000000b  ;1 wird immer mit 0 vergleicht und 1 als Ergebnis fur die Positionen geben
        
        ;die Bits 8-10 von C haben den Wert 110 
        or ebx, 00000000000000000000011000000000b ; die jetzigen Bits,also 110 werden mit 000 vergleicht
        
        ;die Bits 0-3 von C sind die gleichen wie die Bits 3-6 von B
        mov ax, [b] 
        push 0
        push ax
        pop eax ;EAX:AX=b
        ror eax, 3 ;ich rotiere 3 Positionen nach rechts
        and eax, 00000000000000000000000000001111b ;ich isoliere die Bits 0-3 von b
        or ebx,eax ;ich fuge die Bits in das Ergebnis ein
        
        ;die Bits 11-15 von C haben den gleichen Wert wie die Bits 0-4 von A
        mov ax, [a]
        push 0
        push ax
        pop eax ;EAX:AX=a
        rol eax, 11 ;ich rotiere 11 Positionen nach links
        and eax, 00000000000000001111100000000000b ;ich isoliere die Bits 11-15 von a
        or ebx,eax ;ich fuge die Bits in das Ergebnis ein
        
        mov [c], bx ;ich verschiebe das Ergebnis aus dem Register in die Ergebnisvariable
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
