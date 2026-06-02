; ******************************
; * Лабораторная работа N1 *
; * Изучение отладчика AFD *
; ******************************
; ------------------------------
; Примечание: Программа выводит на дисплей сообщение и
; и ожидает нажатия клавиши , код символа
; помещается в регистр AL
; Справка...: DS:DX - адрес строки;
; Функции DOS :
; 09h выдать на дисплей строку,
; 07h ввести символ без эха,
; 4Ch завершить процесс ;
; INT 21h - вызов функции DOS
StkSeg SEGMENT PARA STACK 'STACK'
    DB 200h DUP (?)
StkSeg ENDS
;

DataS SEGMENT WORD 'DATA'
HelloMessage    DB 13
                DB 10
                DB 'Hello, world !'
                DB '$'
DataS ENDS
;

Code SEGMENT WORD 'CODE'
        ASSUME CS:Code, DS:DataS
DispMsg:
        mov AX, DataS
        mov DS, AX
        mov DX, OFFSET HelloMessage
        mov CX, 3
        mov AH, 9

        PRINT:
            int 21h
            loop PRINT

        mov AH, 7
        int 21h
        mov AH, 4ch
        int 21h
Code    ENDS
        END DispMsg
