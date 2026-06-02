.386

DSEG SEGMENT PARA PUBLIC USE16 'DATA'
    EXTRN number:WORD
    msg DB 'Min power of 2 > number: $'

DSEG ENDS

CSEG SEGMENT PARA PUBLIC USE16 'CODE'
    ASSUME CS:CSEG, DS:DSEG
    PUBLIC out_pow2

out_pow2 PROC NEAR
    pusha
    
    mov ah, 09h
    mov dx, OFFSET msg
    int 21h

    mov ax, number
    xor si, si

find_pow:
    cmp ax, 0
    je print_dec
    shr ax, 1
    inc si
    jmp find_pow

print_dec:
    mov ax, si
    mov bx, 0Ah     ; 10-я СС
    xor cx, cx

div_loop:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne div_loop

print_loop:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop print_loop

    popa
    ret
out_pow2 ENDP
CSEG ENDS
END
