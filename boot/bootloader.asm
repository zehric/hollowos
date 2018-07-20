[org 0x7c00]

KERNEL_SEG equ 0x2000

mov [BOOT_DRIVE], dl

xor ax, ax
mov ss, ax
mov ds, ax

; Set up the stack
mov bp, 0xf000
mov sp, bp

mov bx, MSG_REAL_MODE
call print_string

call load_kernel

call switch_to_pm

jmp $ ; never reached

%include "print.asm"
%include "print_hex.asm"
%include "disk_load.asm"
%include "gdt.asm"
%include "print_pm.asm"
%include "switch.asm"

[bits 16]
load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print_string

        ; Put kernel at ES:BX -> 0x20000
        mov bx, KERNEL_SEG
	mov es, bx
        mov bx, 0  

	mov dh, 15 ; TODO: make this more robust or increase as kernel grows
	mov dl, [BOOT_DRIVE]
	call disk_load

	ret

[bits 32]
KERNEL_OFFSET equ 0x20000

BEGIN_PM: ; Entry point of protected mode
	mov ebx, MSG_PROT_MODE
	call print_string_pm

	call KERNEL_OFFSET

	jmp $

BOOT_DRIVE db 0
MSG_REAL_MODE db "Init bootloader. ", 0
MSG_PROT_MODE db "Loaded 32-bit protected mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory.", 0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55
