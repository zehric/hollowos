print_hex:
	push ax
        push bx
	push cx
	push dx

	mov cx, 0
	mov bx, HEX_OUT + 5
.loop:
	cmp cx, 4
	je .done

	mov ax, dx
	and ax, 0x000f
	add al, 0x30
	cmp al, 0x3a
	jl .loopend
	add al, 7

.loopend:
	mov [bx], al
	shr dx, 4

	sub bx, 1
	add cx, 1
	jmp .loop

.done:
	mov bx, HEX_OUT
	call print_string
	
	pop dx
	pop cx
	pop bx
	pop ax ; TODO: check if this works
	ret

HEX_OUT:
	db '0x0000', 0
