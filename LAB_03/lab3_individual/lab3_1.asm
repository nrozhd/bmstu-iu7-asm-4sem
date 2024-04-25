; Требуется написать программу с двумя сегментами данных. 
; В первый ввести букву и цифру M, затем в переменную второго 
; сегмента записать новую букву, сдвинутую на M позиций
; влево в алфавите относительно исходной, и вывести её на экран.

SD1 SEGMENT para public 'DATA'
	L1 db 1 dup(?)
	M db 1 dup(?)
SD1 ENDS

SD2 SEGMENT para public 'DATA'
	L2 db 1 dup(?)
SD2 ENDS

STK SEGMENT para STACK 'STACK'
	db 100 dup(0)
STK ENDS

CSEG SEGMENT para public 'CODE'
	assume CS:CSEG, DS:SD1
main:
	mov ax, SD1
	mov ds, ax
	mov ah, 01
	int 21h
	mov L1, al
	int 21h
	mov M, al
assume ES:SD2
	mov dl, 13
	mov ah, 02
	int 21h	
	mov dl, 10
	int 21h	
	mov ax, SD2
	mov es, ax
	mov bh, L1
	mov L2, bh
	mov ch, L2
	mov cl, M
	sub cl, 48
	sub ch, cl
	mov L2, ch
	mov dl, L2
	mov ah, 02
	int 21h
	mov ax, 4c00h
	int 21h
CSEG ENDS
END main