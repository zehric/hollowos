[bits 32]

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f ; white color

print_string_pm:
	pusha
	mov edx, VIDEO_MEMORY

.loop:
	mov al, [ebx]
	mov ah, WHITE_ON_BLACK

	cmp al, 0 ; check if end of string
	je .done

	mov [edx], ax ; store character + attribute in video memory
	add ebx, 1 ; next char
	add edx, 2 ; next video memory position

	jmp .loop

.done:
	popa
	ret
