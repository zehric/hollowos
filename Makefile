all: os-image

run: all
	qemu-system-i386 --curses os-image

os-image: boot_sect.bin kernel.bin
	cat $^ > $@
	dd if=/dev/zero bs=8192 count=1 >> $@ # TODO: remove if kernel gets larger

kernel.bin: kernel_entry.o kernel.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary --entry main

kernel.o: kernel.c
	gcc -fno-pie -m32 -ffreestanding -c $< -o $@

kernel_entry.o: kernel_entry.asm
	nasm $< -f elf -o $@

boot_sect.bin: boot_sect.asm
	nasm $< -f bin -o $@

clean:
	rm -rf *.bin *.dis *.o os-image *.map

kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@
