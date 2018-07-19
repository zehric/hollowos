[bits 16]
switch_to_pm:

	cli			; Disable interrupts

	lgdt [GDT_DESCRIPTOR]	; Load the GDT descriptor

	mov eax, cr0
	or eax, 0x1		; Set 32-bit mode bit in cr0
	mov cr0, eax

	jmp CODE_SEG:init_pm	; far jump to init_pm

[bits 32]
init_pm:
	mov ax, DATA_SEG	; Update the segment registers
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

;	mov ebp, 0x90000	; Update stack
;	mov esp, ebp ; TODO: check if works

	call BEGIN_PM
