#ifndef DRIVERS_PORT_H
#define DRIVERS_PORT_H

char inb(short port);
void outb(short port, char data);
short inw(short port);
void outw(short port, short data);

#endif /* drivers/port.h */
