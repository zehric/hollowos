#include "drivers/port.h"

char inb(short port) {
	char byte;
	__asm__("in %%dx, %%al" : "=a" (byte) : "d" (port));
	return byte;
}

void outb(short port, char data) {
	__asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}

short inw(short port) {
	short word;
	__asm__("in %%dx, %%ax" : "=a" (word) : "d" (port));
	return word;
}
 
void outw(short port, short data) {
	__asm__("out %%ax, %%dx" : : "a" (data), "d" (port));
}
