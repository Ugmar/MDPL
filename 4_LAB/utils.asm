PUBLIC input_digit, calc_col_sum
EXTRN matrix: byte
EXTRN N: byte
EXTRN M: byte

CodeSeg SEGMENT WORD PUBLIC 'CODE'
    ASSUME CS:CodeSeg

input_digit PROC
    push bp
    mov bp, sp
read_char:
    mov ah, 01h
    int 21h
    
    cmp al, ' '
    je read_char

    cmp al, 0Dh
    je read_char
    
    cmp al, '0'
    jb err_digit
    cmp al, '9'
    ja err_digit

    sub al, '0'
    mov bx, [bp + 4]
    mov [bx], al
    jmp end_digit
err_digit:
    mov al, 0FFh
    jmp end_digit
end_digit:
    pop bp
    ret 2
input_digit ENDP

calc_col_sum PROC
    push bx
    push cx
    push dx

    xor ah, ah
    mov dx, ax
    lea bx, matrix
    add bx, dx

    xor al, al
    xor ch, ch
    mov cl, M
    jcxz sum_done
sum_loop:
    add al, [bx]
    add bx, 9
    loop sum_loop
sum_done:
    pop dx
    pop cx
    pop bx
    ret
calc_col_sum ENDP

CodeSeg ENDS
END
