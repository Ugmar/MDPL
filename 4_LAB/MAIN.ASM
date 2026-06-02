STK SEGMENT PARA STACK "STACK"
    db 200h dup(?)
STK ENDS

DataSeg SEGMENT WORD PUBLIC 'DATA'
    matrix  db 81 dup(?)
    M   db ?
    N   db ?

    msg_error_size db 0Dh, 0Ah, 'Invalid matrix $'
    msg_empty_matrix db 0Dh, 0Ah, 'Matrix is empty $'

DataSeg ENDS

PUBLIC matrix, N, M
EXTRN input_matrix: near
EXTRN print_matrix: near
EXTRN delete_col: near


CodeSeg SEGMENT WORD PUBLIC 'CODE'
    ASSUME DS: DataSeg, CS: CodeSeg

MAIN:
    mov AX, DataSeg
    mov DS, AX

    call input_matrix
    cmp al, 0
    jne show_size_error

    call delete_col

    cmp N, 0
    je empty_matrix

    call print_matrix

    mov ax, 4c00h
    int 21h

empty_matrix:
    mov dx, offset msg_empty_matrix
    mov ah, 09h
    int 21h

    mov ax, 4c00h
    int 21h

show_size_error:
    mov dx, offset msg_error_size
    mov ah, 09h
    int 21h

    mov ax, 4c01h
    int 21h

CodeSeg ENDS
END MAIN
