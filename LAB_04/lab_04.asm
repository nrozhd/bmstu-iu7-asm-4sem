; ******************************
; *   Лабораторная работа N4   *
; *          Матрицы           *
; ******************************
; ------------------------------
; Общее задание: Требуется составить программу на языке ассемблера,
; которая обеспечит ввод матрицы, преобразование согласно индивидуальному
; заданию и вывод изменённой матрицы.
; Тип матрицы: прямоугольная цифровая
; Преобразование: заменить все значения в столбцах с нулевыми элементами 
; значениями из предыдущего столбца. Первый столбец не изменять.
;
SD1 SEGMENT para public 'DATA'
	INP_MSG_1 db 'Enter number of rows: $'
	INP_MSG_2 db 'Enter number of columns: $'
	INP_MSG_3 db 'Enter matrix elements: $'	
	INP_MSG_4 db 'Output matrix: $'	
	INP_MSG_5 db 'Output tranformed matrix: $'
	ERR_MSG db 'Transformation is impossible$'	
	N db 1 dup(?)
	M db 1 dup(?)
	MATRIX db 9 * 9 dup(0)
SD1 ENDS

STK SEGMENT para STACK 'STACK'
	db 100 dup(0)
STK ENDS

CSEG SEGMENT para public 'CODE'
	assume CS:CSEG, DS:SD1
input_num_row:
	; приглашение к вводу количества строк
	mov dx, OFFSET INP_MSG_1
	mov ah, 09
	int 21h
	; ввод количества строк
	mov ah, 01
	int 21h
	mov N, al
	sub N, '0'
	ret
input_num_column:
	; приглашение к вводу количества столбцов
	mov dx, OFFSET INP_MSG_2
	mov ah, 09
	int 21h
	; ввод количества столбцов
	mov ah, 01
	int 21h
	mov M, al
	sub M, '0'
	ret

input_matrix:
	; приглашение к вводу элементов матрицы
	mov dx, OFFSET INP_MSG_3
	mov ah, 09
	int 21h
	; ввод элементов матрицы
	mov si, 0 ; индекс строки
	mov cl, N
	input_string:
		mov cl, M
		mov ax, 9
		mul si
		mov bx, ax
		input_element:
			mov ah, 01
			int 21h
			mov MATRIX[bx], al
			add bx, 1
			call line_feed
			loop input_element
		mov cl, N
		sub cx, si 
		inc si
		loop input_string
	ret
exit:
	mov dx, OFFSET ERR_MSG
	mov ah, 09
	int 21h
	mov ax, 4c00h
	int 21h	
transformation_matrix:
	cmp M, 1
	je exit
	mov si, 1 ; индекс столбца
	mov cl, M
	find_zero_in_column:
		mov di, 0 ; индекс строки
		mov cl, N
		find_zero:
			mov ax, 9
			mul di
			mov bx, ax
			add bx, si
			cmp MATRIX[bx], '0'
			jne continue
			mov cl, N
			push di
			mov di, 0 ; индекс строки при обмене
			move_column:
				mov ax, 9
				mul di
				mov bx, ax
				add bx, si
				dec bx
				mov al, MATRIX[bx]
				inc bx
				mov MATRIX[bx], al
				inc di
				loop move_column
			pop di
			continue:
			xor cx, cx
			mov cl, N
			sub cx, di
			inc di
			loop find_zero
		xor cx, cx
		mov cl, M
		sub cx, si 
		inc si
		loop find_zero_in_column
	ret	

print_matrix:
	; вывод элементов матрицы
	mov si, 0 ; индекс строки
	mov cl, N
	print_string:
		mov cl, M
		mov ax, 9
		mul si
		mov bx, ax
		print_element:
			mov dl, MATRIX[bx]
			mov ah, 02
			int 21h
			;mov dx, bx
			;add dx, '0'
			;int 21h
			add bx, 1
			call print_space
			loop print_element
		call line_feed
		mov cl, N
		sub cx, si 
		inc si
		loop print_string
	ret

print_space:
	mov ah, 2
	mov dl, ' '
	int 21h
	ret
line_feed:
	mov ah, 02
	mov dl, 13
	int 21h	
	mov dl, 10
	int 21h	
	ret
main:
	mov ax, SD1
	mov ds, ax

	call input_num_row
	call line_feed

	call input_num_column
	call line_feed

	call input_matrix

	mov dx, OFFSET INP_MSG_4
	mov ah, 09
	int 21h
	call line_feed
	call print_matrix

	call transformation_matrix

	mov dx, OFFSET INP_MSG_5
	mov ah, 09
	int 21h
	call line_feed
	call print_matrix

	mov ax, 4c00h
	int 21h
CSEG ENDS
END main