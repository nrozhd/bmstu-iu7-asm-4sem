PUBLIC output_X ;идентификатор output_X доступен из другого модуля
EXTRN X: byte ;идентификатор x определен в другом модуле

DS2 SEGMENT AT 0b800h ;сегмент ds2 расположен по фиксированному адресу 0b800h
	CA LABEL byte
	ORG 80 * 2 * 2 + 2 * 2 ;Видеопамять текстового режима доступна по адресу B8000
	SYMB LABEL word
DS2 ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, ES:DS2
output_X proc near
	mov ax, DS2
	mov es, ax
	mov ah, 10
	mov al, X 
	mov symb, ax
	ret
output_X endp
CSEG ENDS
END