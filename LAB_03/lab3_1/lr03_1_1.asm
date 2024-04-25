EXTRN output_X: near ;идентификатор output_X определен в другом модуле

STK SEGMENT PARA STACK 'STACK'
	db 100 dup(0)
STK ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
	X db 'R'
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:DSEG, SS:STK
main:
	mov ax, DSEG
	mov ds, ax

	call output_X ;call выполняет jmp прыжок на адрес, в стек записывает адрес возврата(адрес следующей инструкции) и уменьшает на единицу SP (стек поинтер)

	mov ax, 4c00h
	int 21h
CSEG ENDS

PUBLIC X

END main