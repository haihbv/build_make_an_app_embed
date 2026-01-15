MEMORY
{
    FLASH (rx): ORIGIN = 0x08000000, LENGTH = 128K /* code và hằng số nằm ở đây không mất khi mất nguồn */
    RAM (rwx): ORIGIN = 0x20000000, LENGTH = 20K  /* mất khi reset */
}

_estack = ORIGIN(RAM) + LENGTH(RAM); /* top of stack */

ENTRY(Reset_Handler) /* báo cho linker biết hàm đầu tiên sẽ chạy sau reset */

SECTIONS
{
    /* vector ngat o dau FLASH */
    .isr_vector :
    {
        KEEP(*(.isr_vector))
    } > FLASH


    /* code */
    .text :
    {
        *(.text)
        *(.text*)
        *(.glue_7) *(.glue_7t)
        *(.eh_frame)
        . = ALIGN(4);
    } > FLASH

    /* read only data */
    .rodata :
    {
        *(.rodata)
        *(.rodata*)
        . = ALIGN(4);
    } > FLASH

    /* Đảm bảo .data không overlap .rodata */
    . = ALIGN(4);
    _etext = .; /* end of text+rodata, nơi copy .data từ flash */

    .preinit_array :
    {
        PROVIDE_HIDDEN(__preinit_array_start = .);
        KEEP(*(.preinit_array*))
        PROVIDE_HIDDEN(__preinit_array_end = .);
    } > FLASH

    .init_array :
    {
        PROVIDE_HIDDEN(__init_array_start = .);
        KEEP(*(SORT(.init_array.*)))
        KEEP(*(.init_array*))
        PROVIDE_HIDDEN(__init_array_end = .);
    } > FLASH

    .fini_array :
    {
        PROVIDE_HIDDEN(__fini_array_start = .);
        KEEP(*(SORT(.fini_array.*)))
        KEEP(*(.fini_array*))
        PROVIDE_HIDDEN(__fini_array_end = .);
    } > FLASH
    
    /* Data (copy từ FLASH xuống RAM ) */
    .data : AT(_etext)
    {
        _sdata = .;
        *(.data)
        *(.data*)
        . = ALIGN(4);
        _edata = .;
    } > RAM
    _sidata = LOADADDR(.data); /* địa chỉ nguồn trong FLASH */

    /* Bss: chứa biến toàn cục chưa được khởi tạo */
    .bss :
    {
        _sbss = .;
        *(.bss)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    } > RAM

    /* Heap + Stack */
    ._user_heap_stack :
    {
        . = ALIGN(8);
        PROVIDE(_sheap = .);
        . = . + 0x400; /* heap 1 KB */
        PROVIDE(_eheap = .);
        . = . + 0x400; /* stack 1 KB */
        PROVIDE(_estack_custom = .);
    } > RAM
}
