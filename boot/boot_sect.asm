[org 0x7c00]
KERNEL_OFFSET equ 0x1000

mov [BOOT_DRIVE], dl

; xor ax, ax
; mov ss, ax
; mov ds, ax
mov bp, 0xf000 ; set the stack
mov sp, bp

mov bx, MSG_REAL_MODE
call print_string ; This will be written after the BIOS messages

call load_kernel


call switch_to_pm
jmp $ ; this will actually never be executed

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

	mov bx, KERNEL_OFFSET
	mov dh, 15
	mov dl, [BOOT_DRIVE]
	call disk_load

	ret

[bits 32]
BEGIN_PM: ; after the switch we will get here
	mov ebx, MSG_PROT_MODE
	call print_string_pm ; Note that this will be written at the top left corner

	call KERNEL_OFFSET

	jmp $

BOOT_DRIVE db 0
MSG_REAL_MODE db "Started in 16-bit real mode", 0
MSG_PROT_MODE db "Loaded 32-bit protected mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory.", 0

; bootsector
times 510-($-$$) db 0
dw 0xaa55
