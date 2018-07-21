; The following code is public domain licensed
 
[bits 16]
 
; Returns: 0 in CF if the a20 line is disabled (memory wraps around)
;          1 in CF if the a20 line is enabled (memory does not wrap around)
 
check_a20:
    push ds
    push es
 
    cli
 
    xor ax, ax ; ax = 0
    mov es, ax
 
    not ax ; ax = 0xFFFF
    mov ds, ax
 
    mov di, 0x0500
    mov si, 0x0510
 
    mov al, byte [es:di]
    push ax
 
    mov al, byte [ds:si]
    push ax
 
    mov byte [es:di], 0x00
    mov byte [ds:si], 0xFF
 
    cmp byte [es:di], 0xFF
 
    pop ax
    mov byte [ds:si], al
 
    pop ax
    mov byte [es:di], al
 
    clc ; CF := 0
    je .done
 
    stc ; CF := 1
 
.done:
    pop es
    pop ds

    ret

set_a20_keyboard:
        cli
 
        call .wait_cmd
        mov al, 0xAD
        out 0x64, al
 
        call .wait_cmd
        mov al, 0xD0
        out 0x64, al
 
        call .wait_data
        in al, 0x60
        push eax
 
        call .wait_cmd
        mov al, 0xD1
        out 0x64, al
 
        call .wait_cmd
        pop eax
        or al, 2
        out 0x60, al
 
        call .wait_cmd
        mov al, 0xAE
        out 0x64, al
 
        call .wait_cmd
        sti
        ret
 
.wait_cmd:
        in al, 0x64
        test al, 2
        jnz .wait_cmd
        ret
 
.wait_data:
        in al, 0x64
        test al, 1
        jz .wait_data
        ret

set_a20_bios:
	mov ax, 0x2401
	int 0x15
	ret

set_a20_fastgate:
	in al, 0x92
	or al, 2
	out 0x92, al
	ret

set_a20:
	call check_a20
	jc .done
	call set_a20_keyboard
	call check_a20
	jc .done
	call set_a20_bios
	xchg bx, bx ; nop
	call check_a20
	jc .done
	call set_a20_fastgate
	xchg bx, bx ; nop
	call check_a20
	jc .done

	; Error
	mov bx, A20_ERROR
	call print_string
	jmp $

.done:
	sti
	ret

A20_ERROR db "Could not enable A20", 0
