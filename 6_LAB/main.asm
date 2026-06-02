.model tiny

.code
ORG 100h

start:
    jmp INIT

old_vec     dd ?        
ticks       db 0
cur_speed   db 1Fh

my_int PROC far
    pushf
    call dword ptr cs:[old_vec]

    push ax
    
    inc cs:ticks
    cmp cs:ticks, 18
    jb exit
    mov cs:ticks, 0

    mov al, cs:cur_speed
    dec al
    jns save
    mov al, 1Fh
save:
    mov cs:cur_speed, al

    mov al, 0F3h
    out 60h, al

    mov al, cs:cur_speed
    out 60h, al

exit:
    pop ax
    iret
my_int ENDP

INIT:
    mov ax, 351Ch
    int 21h
    mov word ptr [old_vec], bx
    mov word ptr [old_vec + 2], es

    mov ax, 251Ch
    mov dx, OFFSET my_int
    int 21h

    mov dx, OFFSET INIT 
    int 27h

END start
