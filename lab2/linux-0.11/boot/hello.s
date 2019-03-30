    .code16
    .global _start
    .text
_start:
    mov %cs, %ax
    mov %ax, %ds
    mov %ax, %es

    mov $0x03, %ah      # read cursor pos
    xor %bh, %bh
    int $0x10

    mov $20, %cx
    mov $0x0004, %bx        # page 0, attribute 4 (font color:red)
    #lea    msg1, %bp
    mov     $msg1, %bp
    mov $0x1301, %ax        # write string, move cursor
    int $0x10
end_hello:
    jmp end_hello

msg1:
    .byte 13,10
    .ascii "Hello OSDI Lab2!"
    .byte 13,10
