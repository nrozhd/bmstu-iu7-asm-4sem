PUBLIC u_hex_num_output
EXTRN DEC_NUM: word

SD1 SEGMENT para public use16 'DATA'
    OUTP_MSG_1 db 10, 13, 'Unsigned hexadecimal 16-bit number: $'
SD1 ENDS


CSEG SEGMENT para public use16 'CODE'
	assume CS:CSEG, DS:SD1
print_hex:
    mov bx, DEC_NUM
    mov cx, 4
    print_tetrad:
        push cx
        mov cl, 4
        ROL bx, cl
        mov dx, bx
        AND dx, 1111b ; dx - результат побитового И - получили тетраду
        mov ah, 02
        cmp dx, 10
        jl continue ; если dx < 10 
        add dx, 7 ; сдвигаемся в ascii таблице
        continue:
        add dx, '0'
        int 21h
        pop cx
        loop print_tetrad
    ret
u_hex_num_output proc near
    mov dx, OFFSET OUTP_MSG_1
    mov ah, 09
    int 21h

    call print_hex
    ret
u_hex_num_output endp
CSEG ENDS
END