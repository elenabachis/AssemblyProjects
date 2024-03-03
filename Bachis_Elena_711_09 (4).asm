bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
extern fopen,fprintf,fclose 
import fopen msvcrt.dll 
import fprintf msvcrt.dll 
import fclose msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    text db "Elena @ #$ %^& este o fata ^ minunata.",0
    len equ $-text; lange des textes was gegeben ist
    format db "%s",0
    file_name db "output.txt",0 
    file_descriptor dd -1 ;; variable to hold the file descriptor
 
    access_mode db "w",0 ;w-write fur schreiben, uberschreibt existente Datei
; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        mov esi,0 ;index fur den Text
        mov ecx,len ;die Lange von text wird in ecx gespeichert
        mov bl,'X' ;bl:X
        jecxz sfarsit
        repeta: 
            mov al,[text+esi] 
            ;Sonerzeichen (die Intervallen fur Sonderzeichen:33–47 / 58–64 / 91–96 / 123–126)
            ;ab hier prufe ich ob text[esi] ein Sonderzeichen ist
            cmp al,33 
            jl skip1 
            cmp al,47 
            jg skip1 
            mov [text+esi],bl ;ich ersetze test[esi] mit 'X' wenn es Sonderzeichen ist
            
            skip1:
            cmp al,58 
            jl skip2 
            cmp al,64 
            jg skip2 
            mov [text+esi],bl
            
            skip2:
            cmp al,91 
            jl skip3 
            cmp al,96
            jg skip3
            mov [text+esi],bl
            
            skip3:
            cmp al,123
            jl skip4 
            cmp al,126 
            jg skip4 
            mov [text+esi],bl
            
            skip4:
            inc esi ;ich inkrementiere esi,um das nachste Charakter zu prufen
        loop repeta
        sfarsit:
        
        
        ; call fopen() to create the file
        ; fopen() will return a file descriptor in the EAX or 0 in case of error
        ; eax = fopen(file_name, access_mode)
        push dword access_mode 
        push dword file_name
        call [fopen]
        add esp, 4*2 ; clean-up the stack
        ;4 fur dword und 2 anzahl der parametern
        mov [file_descriptor], eax ; store the file descriptor returned by fopen
 
        ; check if fopen() has successfully created the file (EAX != 0)
        cmp eax, 0
        je final
        
        push dword text 
        push dword [file_descriptor]
        call [fprintf] ;ich stelle die neue Satz vor 
        add esp,4*3
        
        ; call fclose() to close the file
        ; fclose(file_descriptor)
        push dword [file_descriptor]
        call [fclose]
        add esp, 4*1
        final:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]        ; call exit to terminate the program
