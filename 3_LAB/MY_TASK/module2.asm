PUBLIC string
PUBLIC print_second

DSEG SEGMENT PARA PUBLIC 'DATA'
    string  DB 10
            DB ?
            DB 10 dup(?)
DSEG ENDS


CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS: DSEG

print_second proc near
    mov DL, 0Dh
    mov AH, 2
    int 21h

    mov DL, 0Ah
    int 21h

    mov DL, string + 3
    int 21h

    ret
print_second ENDP

CSEG ENDS
END
