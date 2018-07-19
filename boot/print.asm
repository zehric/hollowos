print_string:
	push ax
        push bx

	mov ah, 0x0e

.loop:
	mov al, [bx]
	cmp al, 0
	je .done
	int 0x10
	add bx, 1
	jmp .loop

.done:
	pop bx
        pop ax
	ret
