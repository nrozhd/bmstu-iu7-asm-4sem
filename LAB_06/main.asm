; ******************************
; *   Лабораторная работа №6   *
; *    Перехват прерываний.    *
; *   Резидентные программы.   *
; *   Ввод-вывод через порты.  *
; ******************************
; ------------------------------
; Написать резидентную программу под DOS, которая будет каждую секунду
; менять скорость автоповтора ввода символов в циклическом режиме, от
; самой медленной до самой быстрой. 
; Вариант вызова предшествующего обработчика прерывания: 
; Через машинный код EA команды far JMP, сохранив адрес перехода напрямую
; в непосредственный операнд команды.
;
.MODEL tiny ; один сегмент на все

.data
org 100h ; 256 байт под префикс программного сегмента (PSP)

.code
.startup

jmp change_autorepeat_handler

speed db 0
counter db 0

jmp_old_handler:
    db 0EAh
old_autorepeat_handler dw 0,0


new_autorepeat_handler:
inc counter

cmp counter, 18
jge change_speed_autorepeat_handler ; counter >= 18
jmp jmp_old_handler

;jmp dword ptr cs:old_autorepeat_handler

change_speed_autorepeat_handler:
cmp speed, 11111b
jle continue; speed <= 11111b 
mov speed, 0
continue:
mov al, 0f3h
out 60h, al
mov al, speed
out 60h, al
inc speed
mov counter, 0

jmp jmp_old_handler
;dword ptr cs:old_autorepeat_handler


change_autorepeat_handler:
mov ax, 3508h ; ah: 35h - функция отправляет в ES сегмент и в BX смещение обработчика прерывания 08h отвечает за таймер
int 21h
mov old_autorepeat_handler, bx
mov old_autorepeat_handler + 2, es ; смещение на 2 байта
mov ax, 2508h ; ah: 25h - функция устанавливает новый обработчик прерывания
lea dx, new_autorepeat_handler ; адрес new_autorepeat_handler кладется в dx
int 21h
; завершение программы с оставлением резидентной программы в оперативной памяти
lea dx, change_autorepeat_handler ; адрес change_autorepeat_handler в dx
int 27h
end