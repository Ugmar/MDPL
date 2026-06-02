.intel_syntax noprefix
.text
.global Strcpy

Strcpy:
    # RDI = dst, RSI = src, RDX = len
    mov RCX, RDX
    
    cmp RDI, RSI
    je done
    jb forward

    std
    add RDI, RCX
    dec RDI

    add RSI, RCX
    dec RSI
    
    rep movsb
    cld
    ret

forward:
    cld
    rep movsb

done:
    ret
    
.section .note.GNU-stack,"",@progbits
