org 100h

msg1 db 'Enter first number: $'
msg2 db 13,10,'Enter second number: $'
msg3 db 13,10,'Choose operation (+ - * /): $'
msg4 db 13,10,'Result: $'
msgErr db 13,10,'Error: Division by zero.$'
buf db 6 dup(0)

start:
mov dx, offset msg1
call print
call readnum
mov bx, ax

mov dx, offset msg2
call print
call readnum
mov cx, ax

mov dx, offset msg3
call print
call readch

cmp al,'+'
je add_op
cmp al,'-'
je sub_op
cmp al,'*'
je mul_op
cmp al,'/'
je div_op
jmp endp

add_op:
mov ax,bx
add ax,cx
jmp show

sub_op:
mov ax,bx
sub ax,cx
jmp show

mul_op:
mov ax,bx
mul cx
jmp show

div_op:
cmp cx,0
je div_err
mov ax,bx
xor dx,dx
div cx
jmp show

div_err:
mov dx, offset msgErr
call print
jmp endp

show:
mov dx, offset msg4
call print
call printnum
jmp endp

print:
mov ah,09h
int 21h
ret

readch:
mov ah,01h
int 21h
ret

readnum:
xor ax,ax
xor bx,bx
rn1:
mov ah,01h
int 21h
cmp al,13
je rn2
cmp al,'0'
jb rn1
cmp al,'9'
ja rn1
mov bl,al
sub bl,'0'
mov dx,ax
shl ax,1
mov si,ax
shl ax,2
add ax,si
add ax,bx
jmp rn1
rn2:
ret

printnum:
push ax
push bx
push cx
push dx
mov cx,0
mov bx,10
cmp ax,0
jne pn1
mov dl,'0'
mov ah,02h
int 21h
jmp pn4
pn1:
pn2:
xor dx,dx
div bx
add dl,'0'
push dx
inc cx
cmp ax,0
jne pn2
pn3:
pop dx
mov ah,02h
int 21h
loop pn3
pn4:
pop dx
pop cx
pop bx
pop ax
ret

endp:
mov ah,4Ch
int 21h
