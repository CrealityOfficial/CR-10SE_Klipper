OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)
MEMORY
{
  rom (rx) : ORIGIN = 0x8003000 , LENGTH = 0x00020000
  ram (rwx) : ORIGIN = 0x20000000 , LENGTH = 0x8000
}
SECTIONS
{
    .text : {
        . = ALIGN(4);
        _text_vectortable_start = .;
        KEEP(*(.vector_table))
        _text_vectortable_end = .;
        . = _text_vectortable_start + 0x200;
        KEEP(*(SV_SECTION))
        *(.text .text.*)
        *(.rodata .rodata*)
    } > rom
    . = ALIGN(4);
    _data_flash = .;
    .data : AT (_data_flash)
    {
        . = ALIGN(4);
        _data_start = .;
        *(.ramfunc .ramfunc.*);
        *(.data .data.*);
        . = ALIGN(4);
        _data_end = .;
    } > ram
    .bss (NOLOAD) :
    {
        . = ALIGN(4);
        _bss_start = .;
        *(.bss .bss.*)
        *(COMMON)
        . = ALIGN(4);
        _bss_end = .;
    } > ram
    _stack_start = 0x20000000 + 0x8000 - 512 ;
    .stack _stack_start (NOLOAD) :
    {
        . = . + 512;
        _stack_end = .;
    } > ram
    /DISCARD/ : {
        *(.init)
        *(.fini)
    }
}
