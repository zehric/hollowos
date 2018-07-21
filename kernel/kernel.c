#define VIDEO_MEMORY 0xb8000
#define WHITE_ON_BLACK 0x0f 

static char * const vmem = (char *) VIDEO_MEMORY;

void print(char *s) {
	int i = 0;
	do {
		vmem[i] = *s;
		vmem[i + 1] = WHITE_ON_BLACK;
		i += 2;
	} while (*++s);
}

void main() {
	print("Welcome home, Ashen One. Speak thine heart's desire.");
}
