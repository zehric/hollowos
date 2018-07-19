; load DH sectors to ES:BX from drive DL
disk_load:
	push dx

	mov ah, 0x02 ; bios read sector function code
	mov al, dh ; read DH sectors
	mov ch, 0 ; cylinder 0
	mov dh, 0 ; head 0
	mov cl, 2 ; sector 2

	int 0x13
	jc disk_error

	pop dx
	cmp dh, al ; check if sectors read == sectors expected
	jne disk_error
	ret

disk_error:
	mov bx, DISK_ERROR_MSG
	call print_string
	jmp $


DISK_ERROR_MSG:
	db 'Disk read error!', 0
