void main() {
	char *video_memory = (char *) 0xb8000;
	*video_memory = 'H';
	*(video_memory + 2) = 'O';
	*(video_memory + 4) = 'L';
	*(video_memory + 6) = 'L';
	*(video_memory + 8) = 'O';
	*(video_memory + 10) = 'W';
}
