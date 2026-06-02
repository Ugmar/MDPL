.386

SSEG SEGMENT PARA STACK USE16 'STACK'
    dw 100h dup(?)
SSEG ENDS

DSEG SEGMENT PARA PUBLIC USE16 'DATA'
    PUBLIC number
    number dw 0

    newline db 0Dh, 0Ah, '$'

    menu    db 0Dh, 0Ah, 0Dh, 0Ah
            db '1. Input 16-bit signed octal number (8 s/s)', 0Dh, 0Ah
            db '2. Output unsigned hex (16 s/s)', 0Dh, 0Ah
            db '3. Output 8-bit signed binary (2 s/s)', 0Dh, 0Ah
            db '4. Output min power of 2 > number', 0Dh, 0Ah
            db '5. Exit', 0Dh, 0Ah
            db 'Choose action: $'

DSEG ENDS

CSEG SEGMENT PARA PUBLIC USE16 'CODE'
    ASSUME CS:CSEG, DS:DSEG

    EXTRN input_oct:NEAR
    EXTRN out_hex:NEAR
    EXTRN out_bin:NEAR
    EXTRN out_pow2:NEAR

    funcs dw input_oct, out_hex, out_bin, out_pow2, exit_prog

start:
    mov ax, DSEG
    mov ds, ax

menu_loop:
    mov ah, 09h
    mov dx, OFFSET menu
    int 21h

    mov ah, 01h
    int 21h
    
    push ax     ; выбор меню хранится в Al, сохраняем в стек, чтоб не потерять
    mov ah, 09h
    mov dx, OFFSET newline
    int 21h
    pop ax

    ; Проверка ввода [1: 5]
    sub al, '1'
    cmp al, 0
    jl menu_loop
    cmp al, 4
    jg menu_loop

    movzx bx, al
    shl bx, 1
    call word ptr cs:funcs[bx]

    jmp menu_loop

exit_prog:
    mov ax, 4C00h
    int 21h

CSEG ENDS
END start
