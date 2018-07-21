ENTRY(main)

SECTIONS
{
	start = 0x20000;

	. = start;

	.text ALIGN(0x1000):
	{
		*(.text)
	}

	.rodata ALIGN(0x1000):
	{
		*(.rodata)
		*(.rodata.*)
	}

	.data ALIGN(0X1000):
	{
		*(.data)
	}

	.bss ALIGN(0x1000):
	{
		*(COMMON)
		*(.bss)
	}

	end = .;

	ASSERT (end - start <= 512K, "Kernel is too big")

}
