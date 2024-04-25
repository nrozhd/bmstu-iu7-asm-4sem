; ******************************
; *   Лабораторная работа N5   *
; *      Обработка чисел       *
; ******************************
; ------------------------------
; Общее задание: Требуется составить программу, которая будет осуществлять:
; ● ввод 16-разрядного числа;
; ● вывод его в знаковом либо беззнаковом представлении в системе счисления по варианту;
; ● усечённое до 8 разрядов значение (аналогично приведению типа int к char в
; языке C) в знаковом либо беззнаковом представлении в системе счисления по
; варианту;
; ● задание на применение команд побитовой обработки: 1-й вариант - степень
; двойки, которой кратно введённое число; 2-й вариант - минимальная степень
; двойки, которая превышает введённое число в беззнаковой интерпретации.
;
; Вводимое число: беззнаковое в 8 с/с
; 1-е выводимое число: беззнаковое в 16 с/с
; 2-е выводимое число: знаковое в 2 с/с
; 3-е значение: 1-й вариант
;
EXTERN u_oct_num_input: near
EXTERN u_hex_num_output: near
EXTERN bin_num_output: near
EXTERN find_degree: near

SD1 SEGMENT para public use16 'DATA'
	MENU_MSG db 10, 13, 'Menu:', 10, 13
             db '0. Exit.', 10, 13
	         db '1. Enter unsigned octal 16-bit number (0 - 177777).', 10, 13
	         db '2. Print unsigned hexadecimal 16-bit number.', 10, 13
	         db '3. Print signed binary 8-bit number.', 10, 13
	         db '4. Find degree of 2 that is a multiple of the entered number (option 1).', 10, 13
             db 'Select action: $'
    WRONG_ACTION_MSG  db 10, 13, 'Error! Incorrect action entered. $', 10, 13
    FUNC_ARR dw exit, u_oct_num_input, u_hex_num_output, bin_num_output, find_degree
SD1 ENDS

STK SEGMENT para STACK use16 'STACK'
	db 100 dup(0)
STK ENDS

CSEG SEGMENT para public use16 'CODE'
	assume CS:CSEG, DS:SD1
print_menu:
	mov dx, OFFSET MENU_MSG
    mov ah, 09
    int 21h
    ret
read_action:
    mov ah, 01
    int 21h
    xor ah, ah
    sub al, '0'
    mov cl, 2
    mul cl
    mov si, ax
    ret
exit:
	mov ax, 4c00h
	int 21h
wrong_action_err:
	mov dx, OFFSET WRONG_ACTION_MSG
    mov ah, 09
    int 21h
    mov ax, 4c01h
	int 21h
main:
	mov ax, SD1
	mov ds, ax
    menu:
	    call print_menu
        call read_action
        call FUNC_ARR[si]
    jmp menu
CSEG ENDS
END main
