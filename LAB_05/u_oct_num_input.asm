PUBLIC u_oct_num_input

SD1 SEGMENT para public 'DATA'
    INP_MSG db 10, 13, 'Enter unsigned octal 16-bit number (0 - 177777): $'
    WRONG_NUM_MSG  db 10, 13, 'Error! Entered number is too large!$'
    MAX_SIZE db 7
    NUM_SIZE db 0
    NUM db 8 dup('$')
    DEC_NUM dw 1
SD1 ENDS


CSEG SEGMENT para public use16 'CODE'
	assume CS:CSEG, DS:SD1

wrong_num:
	mov dx, OFFSET WRONG_NUM_MSG
    mov ah, 09
    int 21h
    mov ax, 4c01h
	int 21h
u_oct_num_to_bin:
    xor cx, cx
    mov cl, NUM_SIZE
    mov ax, 0 
    mov bx, 0
    cycle:
        mov si, 8
        mul si
        xor dx, dx
        mov dl, NUM[bx]
        sub dl, '0'
        add ax, dx
        inc bx
        loop cycle
    mov DEC_NUM, ax    
    ret

u_oct_num_input proc near
    mov dx, OFFSET INP_MSG
    mov ah, 09
    int 21h

    mov ah, 0ah
    mov dx, OFFSET MAX_SIZE
    int 21h

    cmp NUM_SIZE, 6
    jg wrong_num
    jne continue
    cmp NUM[0], '0'
    je continue
    cmp NUM[0], '1'
    je continue
    jmp wrong_num
    continue:
    call u_oct_num_to_bin
    ret
u_oct_num_input endp

PUBLIC DEC_NUM

CSEG ENDS
END