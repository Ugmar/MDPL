PUBLIC input_matrix, print_matrix, delete_col

EXTRN matrix: byte
EXTRN N: byte
EXTRN M: byte
EXTRN input_digit: near
EXTRN calc_col_sum: near

DataSeg SEGMENT WORD PUBLIC 'DATA'
    msg_input  db 0Dh, 0Ah, 'Enter M and N (max 9): $'
    msg_output db 0Dh, 0Ah, 'Matrix result:', 0Dh, 0Ah, '$'
    cur_col    db 0
DataSeg ENDS

CodeSeg SEGMENT WORD PUBLIC 'CODE'
    ASSUME DS:DataSeg, CS:CodeSeg

input_matrix PROC
    mov dx, offset msg_input
    mov ah, 09h
    int 21h

    lea ax, M
    push ax
    call input_digit
    cmp al, 0FFh
    je input_fail_error

    cmp M, 0
    je input_fail_error

    lea ax, N
    push ax
    call input_digit
    cmp al, 0FFh
    je input_fail_error

    cmp N, 0
    je input_fail_error
    
    lea bx, matrix
    xor ch, ch
    mov cl, M
row_in:
    push cx
    mov cl, N
col_in:
    push bx
    call input_digit
    cmp al, 0FFh
    je elem_error
    inc bx
    loop col_in
    
    mov al, 9
    sub al, N
    xor ah, ah
    add bx, ax 
    
    pop cx
    loop row_in
    xor al, al
    ret

elem_error:
    pop cx
input_fail_error:
    mov al, 1
    ret
input_matrix ENDP

print_matrix PROC
    mov dx, offset msg_output
    mov ah, 09h
    int 21h

    lea bx, matrix
    xor ch, ch
    mov cl, M
row_out:
    push cx
    mov cl, N
col_out:
    mov al, [bx]
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    mov dl, ' '
    int 21h
    inc bx
    loop col_out

    mov al, 9
    sub al, N
    xor ah, ah
    add bx, ax

    mov dl, 0Dh
    mov ah, 02h
    int 21h
    mov dl, 0Ah
    int 21h
    pop cx
    loop row_out
    ret
print_matrix ENDP

delete_col PROC
    push es
    mov ax, ds
    mov es, ax
    cld
    mov cur_col, 0
delete_loop:
    mov al, cur_col
    cmp al, N
    jae delete_done

    call calc_col_sum
    test al, 1
    jnz keep_column

    mov cl, M
    lea bx, matrix
repack_loop:
    push cx
    xor ah, ah
    mov al, cur_col
    mov di, bx
    add di, ax
    mov si, di
    inc si
    
    mov al, N
    sub al, cur_col
    dec al
    xor ch, ch
    mov cl, al
    rep movsb
    add bx, 9
    pop cx
    loop repack_loop

    dec N
    jmp delete_loop
keep_column:
    inc cur_col
    jmp delete_loop
delete_done:
    pop es
    ret
delete_col ENDP

CodeSeg ENDS
END
