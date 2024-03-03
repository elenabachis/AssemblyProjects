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
    a db 4  ; x-(a+b+c*d)/(9-a)=16-(4+6+3*5)/(9-4)
    b dd 6  ; => 16-(10+15)/5=16-25/5=16-5=11
    c db 3
    d db 5
    x dq 16
; our code starts here
segment code use32 class=code
    start:
        ; ...
           mov al, [c] ;AL:=c=3
           mul byte [d] ;AX:=c*d=3*5=15
           mov bx, ax ;ich habe ax in bx gespeichert,da ich ax fur das Addition mit a verwenden will
           mov al, [a] ;AL:=a=4
           mov ah, 0 ;ich habe a von Byte in Wort umgewandelt, um das Addition durchzufuhren
           add bx, ax ;BX:=4+15=19
           push 0 
           push bx ;ich stelle BX im Stapel 
           pop ebx ; der Wert wird von Wort in Doublewort umgewandelt
           add ebx, dword [b] ;EBX:=6+19=25 
           
           mov al, 9 ;AL:=9
           mov ah, 0 ;ich habe 9 von Byte in Wort umgewandelt, um die Subtraktion durchzufuhren
           mov cx, ax ;CX:=AX=9
           mov al ,[a]
           mov ah, 0
           sub cx,ax
           
           push ebx ;EBX -> DX:AX
           pop ax 
           pop dx 
           
           div cx ; AX:=DX:AX/CX=25/5=5 und DX:=DX:AX%CX=0
           push dx 
           push ax 
           pop ebx ;EBX:=DX:AX=5 
           
           mov ecx,0 ;EBX ->ECX:EBX=5
           mov eax, dword [x]
           mov edx, dword [x+4] ; EDX:EAX=x=16
           sub eax, ebx 
           sub edx, ecx ;EDX:EAX-=ECX:EBX=16-5=11
           
           
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
