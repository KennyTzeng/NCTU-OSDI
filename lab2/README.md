# OSDI Lab2
###### tags: `OSDI 2019`

## Objective:
*	Learn how to build a customized BIOS and show some message on system startup.
*	Understand kernel booting flow and boot a 'hello world' program.
*	Learn how to use BIOS interrupt call to do I/O tasks.
*	Learn how to modify linux-0.11 bootsect.s and the build system to create a multiboot kernel image.

## Lab2.1 - Build SEABIOS, add some message before system startup

1. Download the SeaBIOS source code.
2. Switch to 1.10-stable branch because my gcc version(4.5.1) is too old to build the HEAD version of SeaBIOS(will encounter some problems).
3. Enable General Features -> Bootmenu -> Graphical boot splash screen in `make menuconfig` and save.
4. Open 'src/bootsplash.c' and add the print message code in 'enable_vga_console' function.
5. Build SeaBIOS.

```
$ git clone https://git.seabios.org/seabios.git seabios
$ cd seabios/
$ git checkout -b 1.10 origin/1.10-stable
$ make clean
$ make menuconfig
$ vim src/bootsplash.c
$ make
```

```clike=
void
enable_vga_console(void)
{
    dprintf(1, "Turning on vga text mode console\n");
    struct bregs br;

    /* Enable VGA text mode */
    memset(&br, 0, sizeof(br));
    br.ax = 0x0003;
    call16_int10(&br);

    printf("This is B062515's OSDI lab2.\n");
    // Write to screen.
    printf("SeaBIOS (version %s)\n", VERSION);
    display_uuid();
}
```

## Lab2.2 - Add image before system startup

1. When launch qemu-emulator, add `menu=on,splash=/path/to/image.jpg` in `-boot` option to enable boot menu and the image will show during bootup.
2. Make sure the dimensions of the image exactly correspond to an available video mode (eg, 640x480, or 1024x768), otherwise it will not be displayed.

```
$ qemu-system-i386 -m 16M -boot a,menu=on,splash=/home/osdi/osdi/bootsplash.jpg
-fda Image -hda ../osdi.img -bios seabios/out/bios.bin
```

## Lab2.3 & 2.4 - Boot the hello world program and Multiboot support
+ Press ‘1’, it boots the linux-0.11 Image(just like lab1).
+ Press ‘2’, it boots the hello world program.

1. `git merge origin/lab2` and we got hello.s

```
[osdi@localhost osdi]$ git branch -a
  lab1
* lab2
  master
  remotes/github/lab1
  remotes/github/lab2
  remotes/origin/HEAD -> origin/master
  remotes/origin/lab1
  remotes/origin/lab2
  remotes/origin/master
  remotes/osdi/lab1
  remotes/osdi/lab2
[osdi@localhost osdi]$ git merge origin/lab2
warning: Cannot merge binary files: bootsplash.jpg (HEAD vs. origin/lab2)

Auto-merging bootsplash.jpg
CONFLICT (add/add): Merge conflict in bootsplash.jpg
Automatic merge failed; fix conflicts and then commit the result.
[osdi@localhost osdi]$ ls
bootsplash.jpg  hello.s  linux-0.11  osdi.img
```

2. Modify the code in `Makefile`, `boot/Makefile`, `boot/bootsect.s` and `tools/build.sh`, look at [Lab2 source code](https://github.com/KennyTzeng/OSDI/tree/lab2) for detail.

Here is some BIOS interrupt call table.

[INT 10h AH=03h: Get cursor position and shape](https://en.wikipedia.org/wiki/INT_10H)

|Function|Function code|Parameters|Return|
|--------|-------------|----------|------|
|Get cursor position and shape|AH=03h|BH = Page Number|AX = 0</br>CH = Start scan line</br>CL = End scan line</br>DH = Row</br>DL = Column|

[INT 10h AH=13h: Write string (EGA+, meaning PC AT minimum)](https://en.wikipedia.org/wiki/INT_10H)

|Function|Function code|Parameters|Return|
|--------|-------------|----------|------|
|Write string (EGA+, meaning PC AT minimum)|AH=13h|AL = Write mode</br>BH = Page Number</br>BL = Color</br>CX = String length</br>DH = Row</br>DL = Column</br>ES:BP = Offset of string||

[INT 13h AH=02h: Read Sectors From Drive](https://en.wikipedia.org/wiki/INT_13H#INT_13h_AH=02h:_Read_Sectors_From_Drive)

+ Parameters

|Reg|Value|
|---|-----|
|AH|02h|
|AL|Sectors To Read Count|
|CH|Cylinder|
|CL|Sector|
|DH|Head|
|DL|Drive|
|ES:BX|Buffer Address Pointer|

+ Results

|Reg|Value|
|---|-----|
|CF|Set On Error, Clear If No Error|
|AH|Return Code|
|AL|Actual Sectors Read Count|

[INT 16h AH=00h: Read key press](https://en.wikipedia.org/wiki/INT_16H#INT_16h_AH=00h_-_read_keystroke)

|Function|Function code(AH)|Device|Return|
|--------|-----------------|------|------|
|Read key press|00h|Keyboard|AH = Scan code of the key pressed down</br>AL = ASCII character of the button pressed|

My boot/bootsect.s looks like this, show some message at first and according to the keystroke user input to choose which to boot.

```=
# boot/bootsect.s

    ...
    .equ HELLOSEG, 0x0100
    ...
_start:
    mov	$BOOTSEG, %ax
    mov	%ax, %ds
    ...
go: mov	%cs, %ax
    ...
    mov	%ax, %ss
    mov	$0xFF00, %sp		# arbitrary value >>512

###### lab2 - start ######

# show select message
    mov $0x03, %ah            # read cursor pos
    xor %bh, %bh
    int $0x10

    mov $35, %cx
    mov $0x0007, %bx        # page 0, attribute 7 (normal)
    mov	$select_text, %bp
    mov $0x1301, %ax        # write string, move cursor
    int $0x10

# choose load linux kernel or hello program
select_boot:
    mov $0x0000, %ax
    int $0x16
    cmp	$0x31, %al
    je	load_setup
    cmp	$0x32, %al
    je	load_hello
    jmp	select_boot

# load and execute hello
load_hello:
    # set es:bx to 0100:0000
    mov $HELLOSEG, %dx
    mov %dx, %es
    mov $0x0000, %bx

    mov	$0x0000, %dx        # drive 0, head 0
    mov	$0x0002, %cx        # sector 2, track 0
    .equ    AX, 0x0200+1    # ah = 2, 1 sector
    mov     $AX, %ax        # service 2, nr of sectors
    int	$0x13                # read it
    jnc ok_load_hello        # ok - continue
    mov $0x0000, %dx
    mov $0x0000, %ax        # reset the diskette
    int $0x13
    jmp load_hello

ok_load_hello:
    .equ sel_cs0, 0x0100    #select for code segment 0
    ljmp $sel_cs0, $0        #Jump to hello
    # cpu will not return here

###### lab2 - end ######

# load the setup-sectors directly after the bootblock.
# Note that 'es' is already set up.

load_setup:

    mov	$0x0000, %dx        # drive 0, head 0
    mov	$0x0003, %cx        # sector 3, track 0
    ...
    sread:    .word 2+ SETUPLEN    # sectors read of current track

```


## Questions

1. What’s the meaning of ljmp $BOOTSEG, $_start(boot/bootsect.s)? What is the memory address of the beginning of bootsect.s? What is the value of $_start? From above questions, could you please clearly explain how do you jump to the beginning of hello image?

We can debug real mode code with [this special mode in GDB](http://ternet.fr/gdb_real_mode.html). Set breakpoint at 0x7c00 and continue, take a look at the code and compare to the code in bootsect.s.

```
real-mode-gdb$ b *0x7c00
real-mode-gdb$ c
```

We can find that

```
1. the meaning of ljmp $BOOTSEG, $_start
set cs:ip to $BOOTSEG:$_start

2. the memory address of the beginning of bootsect.s
CS:IP: 0000:7C00 (0x07C00)

3. the value of $_start
$_start = 0x5
ljmp    $BOOTSEG, $_start   <->   jmp    0x7c0:0x5
```

in gdb : </br>
![](https://i.imgur.com/4Acqdwtl.png)

code in bootsect.s : </br>
![](https://i.imgur.com/PvnLm0Dl.png)



2. What’s the purpose of es register when the cpu is performing int $0x13 with AH=0x2h?

According to [INT 13H AH=02h](https://en.wikipedia.org/wiki/INT_13H#INT_13h_AH=02h:_Read_Sectors_From_Drive), buffer address depends on ES and BX(correspond to CS and IP), so the answer is read buffer segment address.

3. Please change the Hello program’s font color to another
> Hint: INT10H

According to [INT 10H Table](https://en.wikipedia.org/wiki/INT_10H) and [BIOS color attributes](https://en.wikipedia.org/wiki/BIOS_color_attributes), `BL` decide the color of texts. As I replace `mov $0x0007, %bx` with `mov $0x0004, %bx` , the output texts color change from gray to red.

4. If we would like to swap the position of hello and setup in the Image. Where do we need to modify in tools/build.sh and bootsect.s?

+ modify the `seek` in tools/build.sh (which `dd` skip n blocks at start of output and copy into)
+ modify parameter `CL` (Sector) before calling INT 13h AH=02h (Read Sectors From Drive) in bootsect.s
+ modify `sread:	.word 2+ SETUPLEN	# sectors read of current track` in bootsect.s

5. Please trace the SeaBIOS code. What are the first and the last instruction of the SeaBIOS? Where are they?

> Hint 1: You may want to use debugger to find the first instruction. Run qemu with -S can pause the cpu at the beginning. Remember? In addition to that, readelf is a convenient tool to read executable file’s symbol table.
[SeaBios Debugging](https://www.seabios.org/Debugging)

> Hint 2: SeaBios will try to find the MBR magic number 0xaa55. If there is a 512 bytes sector which ends with 0xaa55, that sector is the boot sector.
Last instruction: The instruction before SeaBios give the cpu to OS.

Launch qemu with `-S` and `-s` options, CPU will stop at startup, and then use gdb to attach, you can see the first instruction of the SeaBIOS : `0xffff0:	jmp    0xf000:0xe05b` .

```
real-mode-gdb$ target remote :1234
---------------------------[ STACK ]---
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
---------------------------[ DS:SI ]---
00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
---------------------------[ ES:DI ]---
00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
----------------------------[ CPU ]----
AX: 0000 BX: 0000 CX: 0000 DX: 0663
SI: 0000 DI: 0000 SP: 0000 BP: 0000
CS: F000 DS: 0000 ES: 0000 SS: 0000

IP: FFF0 EIP:0000FFF0
CS:IP: F000:FFF0 (0xFFFF0)
SS:SP: 0000:0000 (0x00000)
SS:BP: 0000:0000 (0x00000)
OF <0>  DF <0>  IF <0>  TF <0>  SF <0>  ZF <0>  AF <0>  PF <0>  CF <0>
ID <0>  VIP <0> VIF <0> AC <0>  VM <0>  RF <0>  NT <0>  IOPL <0>
---------------------------[ CODE ]----
   0xffff0:	jmp    0xf000:0xe05b
   0xffff5 <BiosDate>:	xor    BYTE PTR ds:0x322f,dh
   0xffff9 <BiosDate+4>:	xor    bp,WORD PTR [bx]
   0xffffb <BiosDate+6>:	cmp    WORD PTR [bx+di],di
   0xffffd <BiosDate+8>:	add    ah,bh
   0xfffff <BiosChecksum>:	add    BYTE PTR [bx+si],al
   0x100001:	add    BYTE PTR [bx+si],al
   0x100003:	add    BYTE PTR [bx+si],al
   0x100005:	add    BYTE PTR [bx+si],al
   0x100007:	add    BYTE PTR [bx+si],al
```

Its source code is at seabios/out/romlayout.S :

```
641    reset_vector:
642        ljmpw $SEG_BIOS, $entry_post
643
644        // 0xfff5 - BiosDate in misc.c
645
646        // 0xfffe - BiosModelId in misc.c
647
648        // 0xffff - BiosChecksum in misc.c
649
650     .end
```

Keep go on, with `nm` and `objdump` to get function name and disassembly code, I set the breakpoints at `call_boot_entry` and `_farcall16` and then use `ni` to keep stepping one instruction, finally got the last instruction of the SeaBIOS : `0xfd375 <_rodata32seg+22919>:	iret` .

```
# Usage of nm and objdump

## list symbols from object files
nm seabios/out/rom.o

## display disassembly information from object files.
objdump -D seabios/out/rom.o
```

```
real-mode-gdb$
---------------------------[ STACK ]---
7C00 0000 0200 D376 F000 0000 0000 6F62
0000 8FC7 0000 9000 0000 6F62 0000 8FC7
---------------------------[ DS:SI ]---
00000000: 53 FF 00 F0 53 FF 00 F0 C3 E2 00 F0 53 FF 00 F0  S...S.......S...
00000010: 53 FF 00 F0 54 FF 00 F0 53 FF 00 F0 53 FF 00 F0  S...T...S...S...
00000020: A5 FE 00 F0 87 E9 00 F0 65 FA 00 F0 65 FA 00 F0  ........e...e...
00000030: 65 FA 00 F0 65 FA 00 F0 57 EF 00 F0 65 FA 00 F0  e...e...W...e...
---------------------------[ ES:DI ]---
00000000: 53 FF 00 F0 53 FF 00 F0 C3 E2 00 F0 53 FF 00 F0  S...S.......S...
00000010: 53 FF 00 F0 54 FF 00 F0 53 FF 00 F0 53 FF 00 F0  S...T...S...S...
00000020: A5 FE 00 F0 87 E9 00 F0 65 FA 00 F0 65 FA 00 F0  ........e...e...
00000030: 65 FA 00 F0 65 FA 00 F0 57 EF 00 F0 65 FA 00 F0  e...e...W...e...
----------------------------[ CPU ]----
AX: AA55 BX: 0000 CX: 0000 DX: 0000
SI: 0000 DI: 0000 SP: 6F0A BP: 0000
CS: F000 DS: 0000 ES: 0000 SS: 0000

IP: D375 EIP:0000D375
CS:IP: F000:D375 (0xFD375)
SS:SP: 0000:6F0A (0x06F0A)
SS:BP: 0000:0000 (0x00000)
OF <0>  DF <0>  IF <0>  TF <0>  SF <0>  ZF <1>  AF <0>  PF <1>  CF <0>
ID <0>  VIP <0> VIF <0> AC <0>  VM <0>  RF <0>  NT <0>  IOPL <0>
---------------------------[ CODE ]----
   0xfd375 <_rodata32seg+22919>:	iret
   0xfd376 <_rodata32seg+22920>:	pushf
   0xfd377 <_rodata32seg+22921>:	cli
   0xfd378 <_rodata32seg+22922>:	cld
   0xfd379 <_rodata32seg+22923>:	push   ds
   0xfd37a <_rodata32seg+22924>:	push   eax
   0xfd37c <_rodata32seg+22926>:	mov    ds,WORD PTR [esp+0x8]
   0xfd381 <_rodata32seg+22931>:	mov    eax,DWORD PTR [esp+0xc]
   0xfd387 <_rodata32seg+22937>:	pop    DWORD PTR [eax+0x1c]
   0xfd38c <_rodata32seg+22942>:	pop    WORD PTR [eax]
0x0000d375 in ?? ()
real-mode-gdb$
---------------------------[ STACK ]---
D376 F000 0000 0000 6F62 0000 8FC7 0000
9000 0000 6F62 0000 8FC7 0000 0000 0000
---------------------------[ DS:SI ]---
00000000: 53 FF 00 F0 53 FF 00 F0 C3 E2 00 F0 53 FF 00 F0  S...S.......S...
00000010: 53 FF 00 F0 54 FF 00 F0 53 FF 00 F0 53 FF 00 F0  S...T...S...S...
00000020: A5 FE 00 F0 87 E9 00 F0 65 FA 00 F0 65 FA 00 F0  ........e...e...
00000030: 65 FA 00 F0 65 FA 00 F0 57 EF 00 F0 65 FA 00 F0  e...e...W...e...
---------------------------[ ES:DI ]---
00000000: 53 FF 00 F0 53 FF 00 F0 C3 E2 00 F0 53 FF 00 F0  S...S.......S...
00000010: 53 FF 00 F0 54 FF 00 F0 53 FF 00 F0 53 FF 00 F0  S...T...S...S...
00000020: A5 FE 00 F0 87 E9 00 F0 65 FA 00 F0 65 FA 00 F0  ........e...e...
00000030: 65 FA 00 F0 65 FA 00 F0 57 EF 00 F0 65 FA 00 F0  e...e...W...e...
----------------------------[ CPU ]----
AX: AA55 BX: 0000 CX: 0000 DX: 0000
SI: 0000 DI: 0000 SP: 6F10 BP: 0000
CS: 0000 DS: 0000 ES: 0000 SS: 0000

IP: 7C00 EIP:00007C00
CS:IP: 0000:7C00 (0x07C00)
SS:SP: 0000:6F10 (0x06F10)
SS:BP: 0000:0000 (0x00000)
OF <0>  DF <0>  IF <1>  TF <0>  SF <0>  ZF <0>  AF <0>  PF <0>  CF <0>
ID <0>  VIP <0> VIF <0> AC <0>  VM <0>  RF <0>  NT <0>  IOPL <0>
---------------------------[ CODE ]----
=> 0x7c00:	jmp    0x7c0:0x5
   0x7c05:	mov    ax,0x7c0
   0x7c08:	mov    ds,ax
   0x7c0a:	mov    ax,0x9000
   0x7c0d:	mov    es,ax
   0x7c0f:	mov    cx,0x100
   0x7c12:	sub    si,si
   0x7c14:	sub    di,di
   0x7c16:	rep movs WORD PTR es:[di],WORD PTR ds:[si]
   0x7c18:	jmp    0x9000:0x1d
0x00007c00 in ?? ()
real-mode-gdb$
```

Its source code is also at seabios/out/romlayout.S :

```
124    // Far call a 16bit function from 16bit mode with a specified cpu register state
125    // %eax = address of struct bregs, %edx = segment of struct bregs
126    // Clobbers: %e[bc]x, %e[ds]i, flags
127        DECLFUNC __farcall16
128    __farcall16:
129        // Save %edx/%eax, %ebp
130        pushl %ebp
131        pushl %eax
132        pushl %edx
133
134        // Setup for iretw call
135        movl %edx, %ds
136        pushw %cs
137        pushw $1f                       // return point
138        pushw BREGS_flags(%eax)         // flags
139        pushl BREGS_code(%eax)          // CS:IP
140
141        // Load calling registers and invoke call
142        RESTOREBREGS_DSEAX
143        iretw                           // XXX - just do a lcalll
```
