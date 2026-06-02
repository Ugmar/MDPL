.386

DSEG SEGMENT PARA PUBLIC USE16 'DATA'

    EXTRN number:WORD
    msg DB '8-bit Signed Binary: $'

DSEG ENDS

CSEG SEGMENT PARA PUBLIC USE16 'CODE'
    ASSUME CS:CSEG, DS:DSEG
    PUBLIC out_bin

out_bin PROC NEAR
    pusha
    
    mov ah, 09h
    mov dx, OFFSET msg
    int 21h

    mov ax, number
check_sign:
    test al, 80h    ; Проверка знака
    jz positive_bin
    
    ; Если отрицательное, печатаем минус и берем модуль
    push ax
    mov dl, '-'
    mov ah, 02h
    int 21h
    pop ax

    neg al

positive_bin:
    mov cx, 8
bin_loop:
    shl al, 1
    mov dl, '0'
    adc dl, 0       ; Добавляем флаг переноса (CF)
    
    push ax
    mov ah, 02h
    int 21h
    pop ax
    
    loop bin_loop

    popa
    ret
out_bin ENDP
CSEG ENDS
END
