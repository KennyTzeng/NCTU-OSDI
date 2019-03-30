# OSDI Lab3
###### tags: `OSDI 2019`

## Objective:
+ The x86 system real/protected mode and memory segmentation mechanism.
+ The basic I/O mechanism.
+ How to write an x86 interrupt service routine(ISR).
+ Keyboard and timer interrupt implementation.

## Files' descriptions
| File | Description |
| -------- | -------- | 
| boot/boot.S     | A simple boot loader. It only changes CPU into protected mode and setup basic GDT.     | 
| boot/main.c | A simple ELF loader that will load the kernel image to expect memory address.
| kernel/entry.S|Kernel entry, there we just setup 8\*4096 bytes as kernel stack space and jump into C environment.
|kernel/main.c|Kernel initial function
|kernel/picirq.c|Programmable interrupt controller driver, it is used for setup external hardware interrupt.
|kernel/kbd.c|Keyboard driver, used for read character from keyboard.
|kernel/screen.c|Simple video driver, it allows you output string to screen.
|kernel/timer.c|Simple system clock driver
|kernel/trap.c|Trap handler
|kernel/trap_entry.S|The trap/interrupt entry, you need to define the interrupt entry point here.
|kernel/shell.c| A simple command shell, You can use it to debug your kernel.
|kernel/kern.ld| Kernel linker script, it tells linker how kernel memory placement is.
|lib/\*.c| In this folder, we prepared some useful library for you (Such as printf, memcpy, strlen…)

## Build and Run
```
make all
qemu-system-i386 -hda kernel.img
```

## Questions
### GDT setup

`SEG(type,base,lim)`
1. Explain what are the parameters `type` `base` `lim` for, and how did you decide the value of them.

SEG() is a macro to build GDT entries in assembly.</br>
`base`: the physical address of the segment's starting location.</br>
`lim`: length_of_segment - 1, also depends on G(Granularity) bit.</br>
`type`: the type of segment and how it can be accessed.</br>
More details on [here](https://0xax.gitbooks.io/linux-insides/content/Booting/linux-bootstrap-2.html).

```
#define SEG(type,base,lim)					\
    .word (((lim) >> 12) & 0xffff), ((base) & 0xffff);	\
    .byte (((base) >> 16) & 0xff), (0x90 | (type)),		\
        (0xC0 | (((lim) >> 28) & 0xf)), (((base) >> 24) & 0xff)
```

 2. How did you setup gdtdesc, what's the minimum value of `gdt limit` which still boot properly?
 
`gdtr` has 16-bit table limit and 32-bit linear base address, so I setup gdtdesc like below.</br>
The minimum value of `gdb limit` is `(end_gdt - gdt) - 1`.
 
 ```clike
 lgdt gdtdesc
 ...
 gdtdesc:
    .word    (8 * 3 - 1)    # gdt limit
    .long    gdt            # gdt base
 ```
 
 
 3. What do the below instructions do in boot/boot.S.

```clike
movl    %cr0, %eax
orl     $CR0_PE_ON, %eax
movl    %eax, %cr0
```

set PE bit in CR0 register to true, switching from real mode to protected mode.


### IDT setup

`SETGATE(gate, istrap, sel, off, dpl)`
1. What are the 1st and 4th parameters of `SETGATE` for?</br>
`gate`: the interrupt gate descriptor.</br>
`off`: interrupt handler.

```=
// Set up a normal interrupt/trap gate descriptor.
// - istrap: 1 for a trap (= exception) gate, 0 for an interrupt gate.
    //   see section 9.6.1.3 of the i386 reference: "The difference between
    //   an interrupt gate and a trap gate is in the effect on IF (the
    //   interrupt-enable flag). An interrupt that vectors through an
    //   interrupt gate resets IF, thereby preventing other interrupts from
    //   interfering with the current interrupt handler. A subsequent IRET
    //   instruction restores IF to the value in the EFLAGS image on the
    //   stack. An interrupt through a trap gate does not change IF."
// - sel: Code segment selector for interrupt/trap handler
// - off: Offset in code segment for interrupt/trap handler
// - dpl: Descriptor Privilege Level -
//	  the privilege level required for software to invoke
//	  this interrupt/trap gate explicitly using an int instruction.
#define SETGATE(gate, istrap, sel, off, dpl)			\
{								\
    (gate).gd_off_15_0 = (uint32_t) (off) & 0xffff;		\
    (gate).gd_sel = (sel);					\
    (gate).gd_args = 0;					\
    (gate).gd_rsv1 = 0;					\
    (gate).gd_type = (istrap) ? STS_TG32 : STS_IG32;	\
    (gate).gd_s = 0;					\
    (gate).gd_dpl = (dpl);					\
    (gate).gd_p = 1;					\
    (gate).gd_off_31_16 = (uint32_t) (off) >> 16;		\
}
```

2. After `lidt`, is data structure `Pseudodesc` still used for other purpose, or we can just discard it? Why?</br>
After `lidt`, `idtr` has the address of idt, so we don't need `Pseudodesc` anymore.


### ELF kernel image loading

`readseg((uint32_t) ELFHDR, SECTSIZE*8, 0);`
1. What the above code is for?
2. It loads data from which location of disk to what address of memory

```
// Read 'count' bytes at 'offset' from kernel into physical address 'pa'
void readseg(uint32_t pa, uint32_t count, uint32_t offset);
```

Read SECTSIZE*8 bytes at 0 from kernel(sector 2 of hard disk, sector 1 is MBR) into physical address ELFHDR.

3. Which file decides the kernel elf image's e_entry value?

`ENTRY(_start)` in kernel/kern.ld


### Keyboard and Screen
1. Describe the entire procedure from a keystroke to the console print the character. You should show TA the code rather than just oral speaking.

trap_init() in kernel/main.c will set up idt and idtr.

After that, when there is a keystroke, $PC will go to the interrupt service routine(by hardware), the interrupt handler(kbd_intr() -> kbd_proc_data() -> cons_intr() in kernel/kbd.c) put the input character into buffer.

On the other hand, many function call like readline() or cprintf() will call putch() defined in kernel/screen.c to put a character on the screen, some of them call getc() -> cons_getc() in kernel/kbd.c to get a character from buffer.

2. Uncomment kbd.c:199 `kbd_intr()` and comment out your keyboard handler function call. Everything works as if the same. What's the difference of the original one's mechanism and modified one's mechanism?

It's about performance, the original one is you press a key -> interrupt service routine, but the modified one will keep polling for any pending input characters, even though there is no keystroke.


## Reference
+ https://github.com/fatsheep9146/6.828mit/tree/master/lab
+ https://github.com/allenwhale/2017-NCTU-OSDI/tree/master/lab3
