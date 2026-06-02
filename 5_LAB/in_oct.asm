.386

DSEG SEGMENT PARA PUBLIC USE16 'DATA'

    EXTRN number:WORD
    input DB 'Enter signed octal number: $'
    input_err DB 0Dh, 0Ah, 'Input error', 0Dh, 0Ah, '$'

DSEG ENDS

CSEG SEGMENT PARA PUBLIC USE16 'CODE'
    ASSUME CS:CSEG, DS:DSEG
    PUBLIC input_oct

input_oct PROC NEAR
    pusha
    
    mov ah, 09h
    mov dx, OFFSET input
    int 21h

    mov dx, 0
    mov bx, 0
    mov si, 0

read_loop:
    mov ah, 01h
    int 21h
    cmp al, 0Dh
    je done_read
    
    cmp al, '-'
    jne check_digit
    cmp si, 0
    jne error_exit  ; '-' разрешен только первым символом
    cmp dx, 0
    jne error_exit
    mov dx, 1       ; Флаг минуса
    jmp read_loop

check_digit:
    sub al, '0'
    cmp al, 7
    ja error_exit

    xor ah, ah
    mov cx, ax

    mov ax, bx
    shl ax, 1
    jc error_exit
    shl ax, 1
    jc error_exit
    shl ax, 1       ; AX = BX * 8
    jc error_exit

    add ax, cx      ; AX = BX * 8 + digit
    jc error_exit

    cmp dx, 1
    je check_neg_limit
    cmp ax, 7FFFh
    ja error_exit
    jmp save_acc

check_neg_limit:
    cmp ax, 8000h
    ja error_exit

save_acc:
    mov bx, ax
    inc si
    jmp read_loop

done_read:
    cmp si, 0
    je error_exit

    cmp dx, 1
    jne save_num
    neg bx       ; перевод в доп код   

save_num:
    mov number, bx

    popa
    ret

error_exit:
    mov ah, 09h
    mov dx, OFFSET input_err
    int 21h

    popa
    ret
input_oct ENDP
CSEG ENDS
END
