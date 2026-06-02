.386
.MODEL FLAT, C
.CODE

Strcpy proc
    push EBP
    mov EBP, ESP
    push EDI
    push ESI

    mov EDI, [EBP + 8]
    mov ESI, [EBP + 12]
    mov ECX, [EBP + 16]

    cmp EDI, ESI
    je done
    jb forward_copy

    std            
    add EDI, ECX
    dec EDI

    add ESI, ECX
    dec ESI

    rep movsb
    cld
    jmp done


forward_copy:
    cld
    rep movsb

done:
    pop ESI
    pop EDI
    mov ESP, EBP
    pop EBP
    ret

Strcpy endp
end
