bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell   nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dd 32 ;a-(y+x)/(b*b-c/d+2)= 32-(7+13)/((-4)*(-4)-(6/(-2))+2)=32-20/(16+3+2)=32-20/21=32
    b db -4
    c db 6
    d db -2
    x dq 13
    y dq 7
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov al,[b] ;AL:=b=-4
        imul al ;AX:=Al*AL=(-4)*(-4)=16
        mov bx,ax ;BX:=AX=16
        mov al, [c] ;AL:=c=6
        cbw;ich habe c von Byte in Wort umgewandelt
        mov dl, [d] ;DL:=d=-2
        idiv dl ;AL:=AX/DL=6/(-2)=-3 und AH:=AX%DL=6%(-2)=0
        cbw
        sub bx,ax ;BX-=AX=16+3=19 (BX:=b*b-c/d)
        mov al, 2 
        cbw
        add bx,ax ;BX+=AX=19+2=21 (BX:=b*b-c/d+2)
        
        mov eax ,[x] 
        mov edx ,[x+4]
        
        add eax, dword [y]
        add edx, dword [y+4] ;EDX:EAX=x+y=7+13=20
        
        push 0
        push bx
        pop ebx ;EBX:=BX=21
        
        idiv ebx ;EAX:=(EDX:EAX)/EBX=20/21=0 und EDX:=(EDX:EAX)%EBX=20
        
        mov ecx,[a] ;ECX:=a=32
        sub ecx,eax ;ECX-=EAX=32-0=32
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
