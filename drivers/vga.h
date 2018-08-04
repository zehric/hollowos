#ifndef DEVICES_VGA_H
#define DEVICES_VGA_H

#define ROWS 25
#define COLS 80
#define VIDEO_MEMORY 0xb8000
#define WHITE_ON_BLACK 0x0f 

#define REG_CURSOR_CTRL 0x3d4
#define REG_CURSOR_DATA 0x3d5

void print(char *s);
void clear(void);

#endif /* devices/vga.h */
