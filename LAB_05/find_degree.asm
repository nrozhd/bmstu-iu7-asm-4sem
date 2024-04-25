PUBLIC find_degree
EXTRN DEC_NUM: word
.386

SD1 SEGMENT para public use16 'DATA'
    FIND_MSG db 10, 13, 'Degree of 2 that is a multiple of the entered number: $'
SD1 ENDS


CSEG SEGMENT para public use16 'CODE'
	assume CS:CSEG, DS:SD1
find_degree proc near
    mov dx, OFFSET FIND_MSG
    mov ah, 09
    int 21h
    xor bx, bx
    mov ax, DEC_NUM
    bsf bx, ax ; поиск бита, равного 1 (от младшего к старшему)
    mov dx, bx
    add dx, '0'
    mov ah, 02
    int 21h
    ret
find_degree endp
CSEG ENDS
END