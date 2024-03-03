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
    s1 db '+','2',' 2','b','8','6','X','8'
    l1 equ $-s1
    s2 db 'a','4','5'
    l2 equ $-s2
    ld equ $-s1
    d times ld db 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ecx, l2; wir setzen die Lange l2 in ecx
        mov esi, ecx; wir setzen l2 in esi
        dec esi; esi gilt als index und von 0 soll es beginnen 
        mov edi,0; edi gilt als index fur d
        jecxz sfarsit_1; jump to sfarsit_1 wenn ecx null ist
        repeta_1:
            mov al,[s2+esi]; al:=s2[esi] 
            mov [d+edi],al ;d[edi]=s2[esi]
            inc edi 
            dec esi ;ich mache die Zeichenkette aufsteigend durch
        loop repeta_1
        sfarsit_1:; ende der ersten For-loop
        
        mov ecx, l1; wir setzen die Lange l1 in ecx
        mov esi,0
        jecxz sfarsit_2 ;jump to sfarsit_2 wenn ecx null ist
        repeta_2:
            mov al,[s1+esi] ;al:=s1[esi]
            test esi,1 
            jz dacapar; jump to dacapar wenn null
            mov [d+edi],al ;al:=d[edi]
            inc edi 
            dacapar:
            inc esi ;ich mache die Zeichenkette ansteigend durch
            
        loop repeta_2
        sfarsit_2: ;ende des 2-ten for-loops und auch ende des Programms 
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
