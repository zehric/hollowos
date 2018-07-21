; load DH sectors to ES:BX from drive DL
disk_load:
	push dx

	mov ah, 0x42 		; bios read sector function code
	mov [DAP.sectors], dh 	; update number of sectors to read
	mov si, DAP 		; DS:SI -> DAP

	int 0x13
	jc .error

	pop dx
	ret

.error:
	mov bx, DISK_ERROR_MSG
	call print_string
	jmp $


DISK_ERROR_MSG:
	db 'Disk read error', 0

DAP:
        db 0x10		; DAP size
        db 0		; unused
.sectors:
        dw 0		; number of sectors
        dw 0		; offset register
        dw 0x2000	; segment register
        dq 1		; number of sectors to read

