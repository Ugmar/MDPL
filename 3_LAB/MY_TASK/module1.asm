EXTRN string: byte
EXTRN print_second: near

CSTK SEGMENT PARA STACK 'STACK'
	db 100 dup(0)
CSTK ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, SS:CSTK
main:
    mov AX, seg string
    mov DS, AX

    mov AH, 0Ah
    mov DX, OFFSET string
    int 21h

    CALL print_second

    mov AH, 4Ch
    int 21h

CSEG ENDS

END main

