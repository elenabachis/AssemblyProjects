bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global operation

import printf msvcrt.dll
extern printf
; our data is declared here (the variables needed by our program)
extern a ,b ,c, result, format
; our code starts here
segment code use32 class=code public
        ; ...
       operation:
          mov eax,[a] ;eax:=a
          mov ebx,[b] ;ebx:=b
          sub eax,ebx ;eax:=a-b
          mov ecx,[c] ;ecx:=c
          add eax,ecx ;eax:=a-b+c
          mov [result],eax ;result=a-b+c
          push dword [result] 
          push dword format
          call [printf] ;ich zeige result im unsigned Format an
          add esp,4*2 ;clear up the stack :2 Variablen 
        ; return from function
        ; (it removes the Return Address from the stack ; and jumps to the Return Address)
        ret