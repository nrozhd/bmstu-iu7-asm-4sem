PUBLIC bin_num_output
EXTRN DEC_NUM: word

SD1 SEGMENT para public use16 'DATA'
    OUTP_MSG_2 db 10, 13, 'Signed binary 8-bit number: $'
    TOO_LARGE_NUM_MSG db 10, 13, 'Error! Entered number cannot be truncated to signed binary 8-bit number.$'
SD1 ENDS


CSEG SEGMENT para public use16 'CODE'
	assume CS:CSEG, DS:SD1
print_byte:
    mov bx, DEC_NUM
    mov dx, bx
    and dx, 10000000b
    cmp dx, 0
    je positive_number
    neg bx
    positive_number:
    mov cl, 8
    ROL bx, cl
    mov cx, 8
    print_bit:
        ROL bx, 1
        mov dx, bx
        AND dx, 00000001b
        mov ah, 02
        add dx, '0'
        int 21h
        loop print_bit
    ret
bin_num_output proc near
    mov dx, OFFSET OUTP_MSG_2
    mov ah, 09
    int 21h

    call print_byte
    ret
bin_num_output endp
CSEG ENDS
END