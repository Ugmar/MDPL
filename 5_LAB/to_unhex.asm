.386

DSEG SEGMENT PARA PUBLIC USE16 'DATA'

    EXTRN number:WORD
    msg DB 'Unsigned Hex: $'
    
DSEG ENDS

CSEG SEGMENT PARA PUBLIC USE16 'CODE'
    ASSUME CS:CSEG, DS:DSEG
    PUBLIC out_hex

out_hex PROC NEAR
    pusha
    
    mov ah, 09h
    mov dx, OFFSET msg
    int 21h

    mov bx, number
    mov cx, 4

hex_loop:
    rol bx, 4       ; Сдвигаем старшие 4 бита в младшие
    mov dl, bl
    and dl, 0Fh     ; Маска для младшей цифры
    
    cmp dl, 9
    jbe is_digit
    add dl, 'A' - 10
    jmp print_hex
is_digit:
    add dl, '0'

print_hex:
    mov ah, 02h
    int 21h
    loop hex_loop

    popa
    ret
out_hex ENDP
CSEG ENDS
END
