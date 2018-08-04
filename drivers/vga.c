#include "drivers/vga.h"
#include "drivers/port.h"

static char *const vga = (char *) VIDEO_MEMORY;
static unsigned short cursor_pos = 0; // TODO: Change to uint16_t

static void update_cursor(void)
{
	unsigned short cursor = cursor_pos / 2;
	outb(REG_CURSOR_CTRL, 14);
	outb(REG_CURSOR_DATA, (char) (cursor >> 8));
	outb(REG_CURSOR_CTRL, 15);
	outb(REG_CURSOR_DATA, (char) (cursor & 0xff));
}

static inline void clear_cell(unsigned short cell)
{
	vga[cell] = ' ';
	vga[cell + 1] = WHITE_ON_BLACK;
}

static void scroll(void)
{
	unsigned short i;
	for (i = 2 * COLS; i < ROWS * COLS * 2; i++)
		vga[i - 2 * COLS] = vga[i];
	cursor_pos -= 2 * COLS;
	for (i = cursor_pos; i < ROWS * COLS * 2; i += 2)
		clear_cell(i);

}

void print(char *s)
{
	char c;
	while ((c = *s++)) {
		if (c == '\n') {
			cursor_pos += (2 * COLS) - (cursor_pos % (2 * COLS));
		} else {
			vga[cursor_pos] = c;
			vga[cursor_pos + 1] = WHITE_ON_BLACK;
			cursor_pos += 2;
		}
		if (cursor_pos >= ROWS * COLS * 2)
			scroll();
	}
	update_cursor();
}

void clear(void)
{
	unsigned short i;
	for (i = 0; i < ROWS * COLS * 2; i += 2)
		clear_cell(i);
	cursor_pos = 0;
	update_cursor();
}
