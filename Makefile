SOURCES = $(wildcard **/*.c)
HEADERS = $(wildcard **/*.h)
OBJ = $(SOURCES:.c=.o)

CC = /usr/bin/gcc -fno-pie -m32
LD = /usr/bin/ld -m elf_i386

OUTPUT = os-image

all: $(OUTPUT)

run: all
	qemu-system-i386 --curses $(OUTPUT)

$(OUTPUT): boot/bootloader.bin kernel/kernel.bin
	cat $^ > $@
	dd if=/dev/zero bs=8192 count=1 >> $@ # TODO: remove if kernel gets larger

kernel/kernel.bin: kernel/kernel_entry.o $(OBJ) 
	$(LD) -T kernel/kernel.ld -o $@ --oformat binary $^

%.o: %.c $(HEADERS)
	$(CC) -ffreestanding -c $< -o $@

%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -I './boot/' -o $@

.PHONY: clean
clean:
	rm -rf **/*.bin **/*.dis **/*.o os-image

disassemble: kernel/kernel.bin
	ndisasm -b 32 $<
