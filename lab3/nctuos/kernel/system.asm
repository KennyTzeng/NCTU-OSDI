
kernel/system:     file format elf32-i386


Disassembly of section .text:

00100000 <_start>:

.globl _start

.text
_start:
	movw	$0x1234,0x472			# warm boot
  100000:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
  100007:	34 12 

	# Setup kernel stack
	movl $0, %ebp
  100009:	bd 00 00 00 00       	mov    $0x0,%ebp
	movl $(bootstacktop), %esp
  10000e:	bc 20 b3 10 00       	mov    $0x10b320,%esp

	call kernel_main
  100013:	e8 04 00 00 00       	call   10001c <kernel_main>

00100018 <die>:
die:
	jmp die
  100018:	eb fe                	jmp    100018 <die>
	...

0010001c <kernel_main>:
#include <kernel/trap.h>
#include <kernel/picirq.h>

extern void init_video(void);
void kernel_main(void)
{
  10001c:	83 ec 0c             	sub    $0xc,%esp
	init_video();
  10001f:	e8 53 04 00 00       	call   100477 <init_video>

	pic_init();
  100024:	e8 3f 00 00 00       	call   100068 <pic_init>
  /* TODO: You should uncomment them
   */
	kbd_init();
  100029:	e8 08 02 00 00       	call   100236 <kbd_init>
	timer_init();
  10002e:	e8 b4 09 00 00       	call   1009e7 <timer_init>
	trap_init();
  100033:	e8 75 06 00 00       	call   1006ad <trap_init>

	/* Enable interrupt */
	__asm __volatile("sti");
  100038:	fb                   	sti    

	shell();
}
  100039:	83 c4 0c             	add    $0xc,%esp
	trap_init();

	/* Enable interrupt */
	__asm __volatile("sti");

	shell();
  10003c:	e9 6b 08 00 00       	jmp    1008ac <shell>
  100041:	00 00                	add    %al,(%eax)
	...

00100044 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
  100044:	8b 54 24 04          	mov    0x4(%esp),%edx
	int i;
	irq_mask_8259A = mask;
	if (!didinit)
  100048:	80 3d 20 b3 10 00 00 	cmpb   $0x0,0x10b320
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
  10004f:	89 d0                	mov    %edx,%eax
	int i;
	irq_mask_8259A = mask;
  100051:	66 89 15 00 30 10 00 	mov    %dx,0x103000
	if (!didinit)
  100058:	74 0d                	je     100067 <irq_setmask_8259A+0x23>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  10005a:	ba 21 00 00 00       	mov    $0x21,%edx
  10005f:	ee                   	out    %al,(%dx)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
  100060:	66 c1 e8 08          	shr    $0x8,%ax
  100064:	b2 a1                	mov    $0xa1,%dl
  100066:	ee                   	out    %al,(%dx)
  100067:	c3                   	ret    

00100068 <pic_init>:
static bool didinit;

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
  100068:	57                   	push   %edi
  100069:	b9 21 00 00 00       	mov    $0x21,%ecx
  10006e:	56                   	push   %esi
  10006f:	b0 ff                	mov    $0xff,%al
  100071:	53                   	push   %ebx
  100072:	89 ca                	mov    %ecx,%edx
  100074:	ee                   	out    %al,(%dx)
  100075:	be a1 00 00 00       	mov    $0xa1,%esi
  10007a:	89 f2                	mov    %esi,%edx
  10007c:	ee                   	out    %al,(%dx)
  10007d:	bf 11 00 00 00       	mov    $0x11,%edi
  100082:	bb 20 00 00 00       	mov    $0x20,%ebx
  100087:	89 f8                	mov    %edi,%eax
  100089:	89 da                	mov    %ebx,%edx
  10008b:	ee                   	out    %al,(%dx)
  10008c:	b0 20                	mov    $0x20,%al
  10008e:	89 ca                	mov    %ecx,%edx
  100090:	ee                   	out    %al,(%dx)
  100091:	b0 04                	mov    $0x4,%al
  100093:	ee                   	out    %al,(%dx)
  100094:	b0 03                	mov    $0x3,%al
  100096:	ee                   	out    %al,(%dx)
  100097:	b1 a0                	mov    $0xa0,%cl
  100099:	89 f8                	mov    %edi,%eax
  10009b:	89 ca                	mov    %ecx,%edx
  10009d:	ee                   	out    %al,(%dx)
  10009e:	b0 28                	mov    $0x28,%al
  1000a0:	89 f2                	mov    %esi,%edx
  1000a2:	ee                   	out    %al,(%dx)
  1000a3:	b0 02                	mov    $0x2,%al
  1000a5:	ee                   	out    %al,(%dx)
  1000a6:	b0 01                	mov    $0x1,%al
  1000a8:	ee                   	out    %al,(%dx)
  1000a9:	bf 68 00 00 00       	mov    $0x68,%edi
  1000ae:	89 da                	mov    %ebx,%edx
  1000b0:	89 f8                	mov    %edi,%eax
  1000b2:	ee                   	out    %al,(%dx)
  1000b3:	be 0a 00 00 00       	mov    $0xa,%esi
  1000b8:	89 f0                	mov    %esi,%eax
  1000ba:	ee                   	out    %al,(%dx)
  1000bb:	89 f8                	mov    %edi,%eax
  1000bd:	89 ca                	mov    %ecx,%edx
  1000bf:	ee                   	out    %al,(%dx)
  1000c0:	89 f0                	mov    %esi,%eax
  1000c2:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
  1000c3:	66 a1 00 30 10 00    	mov    0x103000,%ax

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
	didinit = 1;
  1000c9:	c6 05 20 b3 10 00 01 	movb   $0x1,0x10b320
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
  1000d0:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  1000d4:	74 0a                	je     1000e0 <pic_init+0x78>
		irq_setmask_8259A(irq_mask_8259A);
  1000d6:	0f b7 c0             	movzwl %ax,%eax
  1000d9:	50                   	push   %eax
  1000da:	e8 65 ff ff ff       	call   100044 <irq_setmask_8259A>
  1000df:	58                   	pop    %eax
}
  1000e0:	5b                   	pop    %ebx
  1000e1:	5e                   	pop    %esi
  1000e2:	5f                   	pop    %edi
  1000e3:	c3                   	ret    

001000e4 <kbd_proc_data>:
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
  1000e4:	53                   	push   %ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  1000e5:	ba 64 00 00 00       	mov    $0x64,%edx
  1000ea:	83 ec 08             	sub    $0x8,%esp
  1000ed:	ec                   	in     (%dx),%al
  1000ee:	88 c2                	mov    %al,%dl
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
		return -1;
  1000f0:	83 c8 ff             	or     $0xffffffff,%eax
{
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
  1000f3:	80 e2 01             	and    $0x1,%dl
  1000f6:	0f 84 d2 00 00 00    	je     1001ce <kbd_proc_data+0xea>
  1000fc:	ba 60 00 00 00       	mov    $0x60,%edx
  100101:	ec                   	in     (%dx),%al
		return -1;

	data = inb(KBDATAP);

	if (data == 0xE0) {
  100102:	3c e0                	cmp    $0xe0,%al
  100104:	88 c1                	mov    %al,%cl
  100106:	75 09                	jne    100111 <kbd_proc_data+0x2d>
		// E0 escape character
		shift |= E0ESC;
  100108:	83 0d 2c b5 10 00 40 	orl    $0x40,0x10b52c
  10010f:	eb 2d                	jmp    10013e <kbd_proc_data+0x5a>
		return 0;
	} else if (data & 0x80) {
  100111:	84 c0                	test   %al,%al
  100113:	8b 15 2c b5 10 00    	mov    0x10b52c,%edx
  100119:	79 2a                	jns    100145 <kbd_proc_data+0x61>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
  10011b:	88 c1                	mov    %al,%cl
  10011d:	83 e1 7f             	and    $0x7f,%ecx
  100120:	f6 c2 40             	test   $0x40,%dl
  100123:	0f 45 c8             	cmovne %eax,%ecx
		shift &= ~(shiftcode[data] | E0ESC);
  100126:	0f b6 c9             	movzbl %cl,%ecx
  100129:	8a 81 cc 17 10 00    	mov    0x1017cc(%ecx),%al
  10012f:	83 c8 40             	or     $0x40,%eax
  100132:	0f b6 c0             	movzbl %al,%eax
  100135:	f7 d0                	not    %eax
  100137:	21 d0                	and    %edx,%eax
  100139:	a3 2c b5 10 00       	mov    %eax,0x10b52c
		return 0;
  10013e:	31 c0                	xor    %eax,%eax
  100140:	e9 89 00 00 00       	jmp    1001ce <kbd_proc_data+0xea>
	} else if (shift & E0ESC) {
  100145:	f6 c2 40             	test   $0x40,%dl
  100148:	74 0c                	je     100156 <kbd_proc_data+0x72>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
		shift &= ~E0ESC;
  10014a:	83 e2 bf             	and    $0xffffffbf,%edx
		data = (shift & E0ESC ? data : data & 0x7F);
		shift &= ~(shiftcode[data] | E0ESC);
		return 0;
	} else if (shift & E0ESC) {
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
  10014d:	83 c9 80             	or     $0xffffff80,%ecx
		shift &= ~E0ESC;
  100150:	89 15 2c b5 10 00    	mov    %edx,0x10b52c
	}

	shift |= shiftcode[data];
  100156:	0f b6 c9             	movzbl %cl,%ecx
	shift ^= togglecode[data];
  100159:	0f b6 81 cc 18 10 00 	movzbl 0x1018cc(%ecx),%eax
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
		shift &= ~E0ESC;
	}

	shift |= shiftcode[data];
  100160:	0f b6 91 cc 17 10 00 	movzbl 0x1017cc(%ecx),%edx
  100167:	0b 15 2c b5 10 00    	or     0x10b52c,%edx
	shift ^= togglecode[data];
  10016d:	31 c2                	xor    %eax,%edx

	c = charcode[shift & (CTL | SHIFT)][data];
  10016f:	89 d0                	mov    %edx,%eax
  100171:	83 e0 03             	and    $0x3,%eax
	if (shift & CAPSLOCK) {
  100174:	f6 c2 08             	test   $0x8,%dl
	}

	shift |= shiftcode[data];
	shift ^= togglecode[data];

	c = charcode[shift & (CTL | SHIFT)][data];
  100177:	8b 04 85 cc 19 10 00 	mov    0x1019cc(,%eax,4),%eax
		data |= 0x80;
		shift &= ~E0ESC;
	}

	shift |= shiftcode[data];
	shift ^= togglecode[data];
  10017e:	89 15 2c b5 10 00    	mov    %edx,0x10b52c

	c = charcode[shift & (CTL | SHIFT)][data];
  100184:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
	if (shift & CAPSLOCK) {
  100188:	74 19                	je     1001a3 <kbd_proc_data+0xbf>
		if ('a' <= c && c <= 'z')
  10018a:	8d 48 9f             	lea    -0x61(%eax),%ecx
  10018d:	83 f9 19             	cmp    $0x19,%ecx
  100190:	77 05                	ja     100197 <kbd_proc_data+0xb3>
			c += 'A' - 'a';
  100192:	83 e8 20             	sub    $0x20,%eax
  100195:	eb 0c                	jmp    1001a3 <kbd_proc_data+0xbf>
		else if ('A' <= c && c <= 'Z')
  100197:	8d 58 bf             	lea    -0x41(%eax),%ebx
			c += 'a' - 'A';
  10019a:	8d 48 20             	lea    0x20(%eax),%ecx
  10019d:	83 fb 19             	cmp    $0x19,%ebx
  1001a0:	0f 46 c1             	cmovbe %ecx,%eax
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1001a3:	3d e9 00 00 00       	cmp    $0xe9,%eax
  1001a8:	75 24                	jne    1001ce <kbd_proc_data+0xea>
  1001aa:	f7 d2                	not    %edx
  1001ac:	80 e2 06             	and    $0x6,%dl
  1001af:	75 1d                	jne    1001ce <kbd_proc_data+0xea>
		cprintf("Rebooting!\n");
  1001b1:	83 ec 0c             	sub    $0xc,%esp
  1001b4:	68 c0 17 10 00       	push   $0x1017c0
  1001b9:	e8 98 05 00 00       	call   100756 <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  1001be:	ba 92 00 00 00       	mov    $0x92,%edx
  1001c3:	b0 03                	mov    $0x3,%al
  1001c5:	ee                   	out    %al,(%dx)
  1001c6:	b8 e9 00 00 00       	mov    $0xe9,%eax
  1001cb:	83 c4 10             	add    $0x10,%esp
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
}
  1001ce:	83 c4 08             	add    $0x8,%esp
  1001d1:	5b                   	pop    %ebx
  1001d2:	c3                   	ret    

001001d3 <cons_getc>:
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	// kbd_intr();

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
  1001d3:	8b 15 24 b5 10 00    	mov    0x10b524,%edx
		c = cons.buf[cons.rpos++];
		if (cons.rpos == CONSBUFSIZE)
			cons.rpos = 0;
		return c;
	}
	return 0;
  1001d9:	31 c0                	xor    %eax,%eax
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	// kbd_intr();

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
  1001db:	3b 15 28 b5 10 00    	cmp    0x10b528,%edx
  1001e1:	74 1b                	je     1001fe <cons_getc+0x2b>
		c = cons.buf[cons.rpos++];
  1001e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  1001e6:	0f b6 82 24 b3 10 00 	movzbl 0x10b324(%edx),%eax
		if (cons.rpos == CONSBUFSIZE)
			cons.rpos = 0;
  1001ed:	31 d2                	xor    %edx,%edx
  1001ef:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
  1001f5:	0f 45 d1             	cmovne %ecx,%edx
  1001f8:	89 15 24 b5 10 00    	mov    %edx,0x10b524
		return c;
	}
	return 0;
}
  1001fe:	c3                   	ret    

001001ff <kbd_intr>:
/*
 *  Note: The interrupt handler
 */
void
kbd_intr(void)
{
  1001ff:	53                   	push   %ebx
	while ((c = (*proc)()) != -1) {
		if (c == 0)
			continue;
		cons.buf[cons.wpos++] = c;
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
  100200:	31 db                	xor    %ebx,%ebx
/*
 *  Note: The interrupt handler
 */
void
kbd_intr(void)
{
  100202:	83 ec 08             	sub    $0x8,%esp
  100205:	eb 20                	jmp    100227 <kbd_intr+0x28>
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
		if (c == 0)
  100207:	85 c0                	test   %eax,%eax
  100209:	74 1c                	je     100227 <kbd_intr+0x28>
			continue;
		cons.buf[cons.wpos++] = c;
  10020b:	8b 15 28 b5 10 00    	mov    0x10b528,%edx
  100211:	88 82 24 b3 10 00    	mov    %al,0x10b324(%edx)
  100217:	8d 42 01             	lea    0x1(%edx),%eax
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
  10021a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10021f:	0f 44 c3             	cmove  %ebx,%eax
  100222:	a3 28 b5 10 00       	mov    %eax,0x10b528
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
  100227:	e8 b8 fe ff ff       	call   1000e4 <kbd_proc_data>
  10022c:	83 f8 ff             	cmp    $0xffffffff,%eax
  10022f:	75 d6                	jne    100207 <kbd_intr+0x8>
 */
void
kbd_intr(void)
{
	cons_intr(kbd_proc_data);
}
  100231:	83 c4 08             	add    $0x8,%esp
  100234:	5b                   	pop    %ebx
  100235:	c3                   	ret    

00100236 <kbd_init>:

void kbd_init(void)
{
  100236:	83 ec 0c             	sub    $0xc,%esp
	// Drain the kbd buffer so that Bochs generates interrupts.
  cons.rpos = 0;
  100239:	c7 05 24 b5 10 00 00 	movl   $0x0,0x10b524
  100240:	00 00 00 
  cons.wpos = 0;
  100243:	c7 05 28 b5 10 00 00 	movl   $0x0,0x10b528
  10024a:	00 00 00 
	kbd_intr();
  10024d:	e8 ad ff ff ff       	call   1001ff <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
  100252:	0f b7 05 00 30 10 00 	movzwl 0x103000,%eax
  100259:	83 ec 0c             	sub    $0xc,%esp
  10025c:	25 fd ff 00 00       	and    $0xfffd,%eax
  100261:	50                   	push   %eax
  100262:	e8 dd fd ff ff       	call   100044 <irq_setmask_8259A>
}
  100267:	83 c4 1c             	add    $0x1c,%esp
  10026a:	c3                   	ret    

0010026b <getc>:
/* high-level console I/O */
int getc(void)
{
	int c;

	while ((c = cons_getc()) == 0)
  10026b:	e8 63 ff ff ff       	call   1001d3 <cons_getc>
  100270:	85 c0                	test   %eax,%eax
  100272:	74 f7                	je     10026b <getc>
		/* do nothing */;
	return c;
}
  100274:	c3                   	ret    
  100275:	00 00                	add    %al,(%eax)
	...

00100278 <scroll>:
int attrib = 0x0F;
int csr_x = 0, csr_y = 0;

/* Scrolls the screen */
void scroll(void)
{
  100278:	56                   	push   %esi
  100279:	53                   	push   %ebx
  10027a:	83 ec 04             	sub    $0x4,%esp
    /* A blank is defined as a space... we need to give it
    *  backcolor too */
    blank = 0x0 | (attrib << 8);

    /* Row 25 is the end, this means we need to scroll up */
    if(csr_y >= 25)
  10027d:	8b 1d 34 b5 10 00    	mov    0x10b534,%ebx
{
    unsigned short blank, temp;

    /* A blank is defined as a space... we need to give it
    *  backcolor too */
    blank = 0x0 | (attrib << 8);
  100283:	8b 35 04 33 10 00    	mov    0x103304,%esi

    /* Row 25 is the end, this means we need to scroll up */
    if(csr_y >= 25)
  100289:	83 fb 18             	cmp    $0x18,%ebx
  10028c:	7e 58                	jle    1002e6 <scroll+0x6e>
    {
        /* Move the current text chunk that makes up the screen
        *  back in the buffer by a line */
        temp = csr_y - 25 + 1;
  10028e:	83 eb 18             	sub    $0x18,%ebx
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);
  100291:	a1 40 b9 10 00       	mov    0x10b940,%eax
  100296:	0f b7 db             	movzwl %bx,%ebx
  100299:	52                   	push   %edx
  10029a:	69 d3 60 ff ff ff    	imul   $0xffffff60,%ebx,%edx
{
    unsigned short blank, temp;

    /* A blank is defined as a space... we need to give it
    *  backcolor too */
    blank = 0x0 | (attrib << 8);
  1002a0:	c1 e6 08             	shl    $0x8,%esi
        temp = csr_y - 25 + 1;
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);

        /* Finally, we set the chunk of memory that occupies
        *  the last line of text to our 'blank' character */
        memset (textmemptr + (25 - temp) * 80, blank, 80);
  1002a3:	0f b7 f6             	movzwl %si,%esi
    if(csr_y >= 25)
    {
        /* Move the current text chunk that makes up the screen
        *  back in the buffer by a line */
        temp = csr_y - 25 + 1;
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);
  1002a6:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
  1002ac:	52                   	push   %edx
  1002ad:	69 d3 a0 00 00 00    	imul   $0xa0,%ebx,%edx

        /* Finally, we set the chunk of memory that occupies
        *  the last line of text to our 'blank' character */
        memset (textmemptr + (25 - temp) * 80, blank, 80);
  1002b3:	6b db b0             	imul   $0xffffffb0,%ebx,%ebx
    if(csr_y >= 25)
    {
        /* Move the current text chunk that makes up the screen
        *  back in the buffer by a line */
        temp = csr_y - 25 + 1;
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);
  1002b6:	8d 14 10             	lea    (%eax,%edx,1),%edx
  1002b9:	52                   	push   %edx
  1002ba:	50                   	push   %eax
  1002bb:	e8 09 11 00 00       	call   1013c9 <memcpy>

        /* Finally, we set the chunk of memory that occupies
        *  the last line of text to our 'blank' character */
        memset (textmemptr + (25 - temp) * 80, blank, 80);
  1002c0:	83 c4 0c             	add    $0xc,%esp
  1002c3:	8d 84 1b a0 0f 00 00 	lea    0xfa0(%ebx,%ebx,1),%eax
  1002ca:	03 05 40 b9 10 00    	add    0x10b940,%eax
  1002d0:	6a 50                	push   $0x50
  1002d2:	56                   	push   %esi
  1002d3:	50                   	push   %eax
  1002d4:	e8 16 10 00 00       	call   1012ef <memset>
        csr_y = 25 - 1;
  1002d9:	83 c4 10             	add    $0x10,%esp
  1002dc:	c7 05 34 b5 10 00 18 	movl   $0x18,0x10b534
  1002e3:	00 00 00 
    }
}
  1002e6:	83 c4 04             	add    $0x4,%esp
  1002e9:	5b                   	pop    %ebx
  1002ea:	5e                   	pop    %esi
  1002eb:	c3                   	ret    

001002ec <move_csr>:
    unsigned short temp;

    /* The equation for finding the index in a linear
    *  chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    temp = csr_y * 80 + csr_x;
  1002ec:	66 6b 0d 34 b5 10 00 	imul   $0x50,0x10b534,%cx
  1002f3:	50 
  1002f4:	ba d4 03 00 00       	mov    $0x3d4,%edx
  1002f9:	03 0d 30 b5 10 00    	add    0x10b530,%ecx
  1002ff:	b0 0e                	mov    $0xe,%al
  100301:	ee                   	out    %al,(%dx)
    *  where the hardware cursor is to be 'blinking'. To
    *  learn more, you should look up some VGA specific
    *  programming documents. A great start to graphics:
    *  http://www.brackeen.com/home/vga */
    outb(0x3D4, 14);
    outb(0x3D5, temp >> 8);
  100302:	89 c8                	mov    %ecx,%eax
  100304:	b2 d5                	mov    $0xd5,%dl
  100306:	66 c1 e8 08          	shr    $0x8,%ax
  10030a:	ee                   	out    %al,(%dx)
  10030b:	b0 0f                	mov    $0xf,%al
  10030d:	b2 d4                	mov    $0xd4,%dl
  10030f:	ee                   	out    %al,(%dx)
  100310:	b2 d5                	mov    $0xd5,%dl
  100312:	88 c8                	mov    %cl,%al
  100314:	ee                   	out    %al,(%dx)
    outb(0x3D4, 15);
    outb(0x3D5, temp);
}
  100315:	c3                   	ret    

00100316 <cls>:

/* Clears the screen */
void cls()
{
  100316:	56                   	push   %esi
  100317:	53                   	push   %ebx
    unsigned short blank;
    int i;

    /* Again, we need the 'short' that will be used to
    *  represent a space with color */
    blank = 0x0 | (attrib << 8);
  100318:	31 db                	xor    %ebx,%ebx
    outb(0x3D5, temp);
}

/* Clears the screen */
void cls()
{
  10031a:	83 ec 04             	sub    $0x4,%esp
    unsigned short blank;
    int i;

    /* Again, we need the 'short' that will be used to
    *  represent a space with color */
    blank = 0x0 | (attrib << 8);
  10031d:	8b 35 04 33 10 00    	mov    0x103304,%esi
  100323:	c1 e6 08             	shl    $0x8,%esi

    /* Sets the entire screen to spaces in our current
    *  color */
    for(i = 0; i < 25; i++)
        memset (textmemptr + i * 80, blank, 80);
  100326:	0f b7 f6             	movzwl %si,%esi
  100329:	a1 40 b9 10 00       	mov    0x10b940,%eax
  10032e:	51                   	push   %ecx
  10032f:	6a 50                	push   $0x50
  100331:	56                   	push   %esi
  100332:	01 d8                	add    %ebx,%eax
  100334:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
  10033a:	50                   	push   %eax
  10033b:	e8 af 0f 00 00       	call   1012ef <memset>
    *  represent a space with color */
    blank = 0x0 | (attrib << 8);

    /* Sets the entire screen to spaces in our current
    *  color */
    for(i = 0; i < 25; i++)
  100340:	83 c4 10             	add    $0x10,%esp
  100343:	81 fb a0 0f 00 00    	cmp    $0xfa0,%ebx
  100349:	75 de                	jne    100329 <cls+0x13>
        memset (textmemptr + i * 80, blank, 80);

    /* Update out virtual cursor, and then move the
    *  hardware cursor */
    csr_x = 0;
  10034b:	c7 05 30 b5 10 00 00 	movl   $0x0,0x10b530
  100352:	00 00 00 
    csr_y = 0;
  100355:	c7 05 34 b5 10 00 00 	movl   $0x0,0x10b534
  10035c:	00 00 00 
    move_csr();
}
  10035f:	83 c4 04             	add    $0x4,%esp
  100362:	5b                   	pop    %ebx
  100363:	5e                   	pop    %esi

    /* Update out virtual cursor, and then move the
    *  hardware cursor */
    csr_x = 0;
    csr_y = 0;
    move_csr();
  100364:	e9 83 ff ff ff       	jmp    1002ec <move_csr>

00100369 <putch>:
}

/* Puts a single character on the screen */
void putch(unsigned char c)
{
  100369:	53                   	push   %ebx
  10036a:	83 ec 08             	sub    $0x8,%esp
    unsigned short *where;
    unsigned short att = attrib << 8;
  10036d:	8b 0d 04 33 10 00    	mov    0x103304,%ecx
    move_csr();
}

/* Puts a single character on the screen */
void putch(unsigned char c)
{
  100373:	8a 44 24 10          	mov    0x10(%esp),%al
    unsigned short *where;
    unsigned short att = attrib << 8;
  100377:	c1 e1 08             	shl    $0x8,%ecx

    /* Handle a backspace, by moving the cursor back one space */
    if(c == 0x08)
  10037a:	3c 08                	cmp    $0x8,%al
  10037c:	75 21                	jne    10039f <putch+0x36>
    {
        if(csr_x != 0) {
  10037e:	a1 30 b5 10 00       	mov    0x10b530,%eax
  100383:	85 c0                	test   %eax,%eax
  100385:	74 7d                	je     100404 <putch+0x9b>
          where = (textmemptr-1) + (csr_y * 80 + csr_x);
  100387:	6b 15 34 b5 10 00 50 	imul   $0x50,0x10b534,%edx
  10038e:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
          *where = 0x0 | att;	/* Character AND attributes: color */
  100392:	8b 15 40 b9 10 00    	mov    0x10b940,%edx
          csr_x--;
  100398:	48                   	dec    %eax
    /* Handle a backspace, by moving the cursor back one space */
    if(c == 0x08)
    {
        if(csr_x != 0) {
          where = (textmemptr-1) + (csr_y * 80 + csr_x);
          *where = 0x0 | att;	/* Character AND attributes: color */
  100399:	66 89 0c 5a          	mov    %cx,(%edx,%ebx,2)
  10039d:	eb 0f                	jmp    1003ae <putch+0x45>
          csr_x--;
        }
    }
    /* Handles a tab by incrementing the cursor's x, but only
    *  to a point that will make it divisible by 8 */
    else if(c == 0x09)
  10039f:	3c 09                	cmp    $0x9,%al
  1003a1:	75 12                	jne    1003b5 <putch+0x4c>
    {
        csr_x = (csr_x + 8) & ~(8 - 1);
  1003a3:	a1 30 b5 10 00       	mov    0x10b530,%eax
  1003a8:	83 c0 08             	add    $0x8,%eax
  1003ab:	83 e0 f8             	and    $0xfffffff8,%eax
  1003ae:	a3 30 b5 10 00       	mov    %eax,0x10b530
  1003b3:	eb 4f                	jmp    100404 <putch+0x9b>
    }
    /* Handles a 'Carriage Return', which simply brings the
    *  cursor back to the margin */
    else if(c == '\r')
  1003b5:	3c 0d                	cmp    $0xd,%al
  1003b7:	75 0c                	jne    1003c5 <putch+0x5c>
    {
        csr_x = 0;
  1003b9:	c7 05 30 b5 10 00 00 	movl   $0x0,0x10b530
  1003c0:	00 00 00 
  1003c3:	eb 3f                	jmp    100404 <putch+0x9b>
    }
    /* We handle our newlines the way DOS and the BIOS do: we
    *  treat it as if a 'CR' was also there, so we bring the
    *  cursor to the margin and we increment the 'y' value */
    else if(c == '\n')
  1003c5:	3c 0a                	cmp    $0xa,%al
  1003c7:	75 12                	jne    1003db <putch+0x72>
    {
        csr_x = 0;
  1003c9:	c7 05 30 b5 10 00 00 	movl   $0x0,0x10b530
  1003d0:	00 00 00 
        csr_y++;
  1003d3:	ff 05 34 b5 10 00    	incl   0x10b534
  1003d9:	eb 29                	jmp    100404 <putch+0x9b>
    }
    /* Any character greater than and including a space, is a
    *  printable character. The equation for finding the index
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
  1003db:	3c 1f                	cmp    $0x1f,%al
  1003dd:	76 25                	jbe    100404 <putch+0x9b>
    {
        where = textmemptr + (csr_y * 80 + csr_x);
  1003df:	8b 15 30 b5 10 00    	mov    0x10b530,%edx
        *where = c | att;	/* Character AND attributes: color */
  1003e5:	0f b6 c0             	movzbl %al,%eax
    *  printable character. The equation for finding the index
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
    {
        where = textmemptr + (csr_y * 80 + csr_x);
  1003e8:	6b 1d 34 b5 10 00 50 	imul   $0x50,0x10b534,%ebx
        *where = c | att;	/* Character AND attributes: color */
  1003ef:	09 c8                	or     %ecx,%eax
  1003f1:	8b 0d 40 b9 10 00    	mov    0x10b940,%ecx
    *  printable character. The equation for finding the index
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
    {
        where = textmemptr + (csr_y * 80 + csr_x);
  1003f7:	01 d3                	add    %edx,%ebx
        *where = c | att;	/* Character AND attributes: color */
        csr_x++;
  1003f9:	42                   	inc    %edx
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
    {
        where = textmemptr + (csr_y * 80 + csr_x);
        *where = c | att;	/* Character AND attributes: color */
  1003fa:	66 89 04 59          	mov    %ax,(%ecx,%ebx,2)
        csr_x++;
  1003fe:	89 15 30 b5 10 00    	mov    %edx,0x10b530
    }

    /* If the cursor has reached the edge of the screen's width, we
    *  insert a new line in there */
    if(csr_x >= 80)
  100404:	83 3d 30 b5 10 00 4f 	cmpl   $0x4f,0x10b530
  10040b:	7e 10                	jle    10041d <putch+0xb4>
    {
        csr_x = 0;
        csr_y++;
  10040d:	ff 05 34 b5 10 00    	incl   0x10b534

    /* If the cursor has reached the edge of the screen's width, we
    *  insert a new line in there */
    if(csr_x >= 80)
    {
        csr_x = 0;
  100413:	c7 05 30 b5 10 00 00 	movl   $0x0,0x10b530
  10041a:	00 00 00 
        csr_y++;
    }

    /* Scroll the screen if needed, and finally move the cursor */
    scroll();
  10041d:	e8 56 fe ff ff       	call   100278 <scroll>
    move_csr();
}
  100422:	83 c4 08             	add    $0x8,%esp
  100425:	5b                   	pop    %ebx
        csr_y++;
    }

    /* Scroll the screen if needed, and finally move the cursor */
    scroll();
    move_csr();
  100426:	e9 c1 fe ff ff       	jmp    1002ec <move_csr>

0010042b <puts>:
}

/* Uses the above routine to output a string... */
void puts(unsigned char *text)
{
  10042b:	56                   	push   %esi
  10042c:	53                   	push   %ebx
    int i;

    for (i = 0; i < strlen(text); i++)
  10042d:	31 db                	xor    %ebx,%ebx
    move_csr();
}

/* Uses the above routine to output a string... */
void puts(unsigned char *text)
{
  10042f:	83 ec 04             	sub    $0x4,%esp
  100432:	8b 74 24 10          	mov    0x10(%esp),%esi
    int i;

    for (i = 0; i < strlen(text); i++)
  100436:	eb 11                	jmp    100449 <puts+0x1e>
    {
        putch(text[i]);
  100438:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
  10043c:	83 ec 0c             	sub    $0xc,%esp
/* Uses the above routine to output a string... */
void puts(unsigned char *text)
{
    int i;

    for (i = 0; i < strlen(text); i++)
  10043f:	43                   	inc    %ebx
    {
        putch(text[i]);
  100440:	50                   	push   %eax
  100441:	e8 23 ff ff ff       	call   100369 <putch>
/* Uses the above routine to output a string... */
void puts(unsigned char *text)
{
    int i;

    for (i = 0; i < strlen(text); i++)
  100446:	83 c4 10             	add    $0x10,%esp
  100449:	83 ec 0c             	sub    $0xc,%esp
  10044c:	56                   	push   %esi
  10044d:	e8 ce 0c 00 00       	call   101120 <strlen>
  100452:	83 c4 10             	add    $0x10,%esp
  100455:	39 c3                	cmp    %eax,%ebx
  100457:	7c df                	jl     100438 <puts+0xd>
    {
        putch(text[i]);
    }
}
  100459:	83 c4 04             	add    $0x4,%esp
  10045c:	5b                   	pop    %ebx
  10045d:	5e                   	pop    %esi
  10045e:	c3                   	ret    

0010045f <settextcolor>:
void settextcolor(unsigned char forecolor, unsigned char backcolor)
{
    /* Lab3: Use this function */
    /* Top 4 bits are the background, bottom 4 bits
    *  are the foreground color */
    attrib = (backcolor << 4) | (forecolor & 0x0F);
  10045f:	0f b6 44 24 08       	movzbl 0x8(%esp),%eax
  100464:	0f b6 54 24 04       	movzbl 0x4(%esp),%edx
  100469:	c1 e0 04             	shl    $0x4,%eax
  10046c:	83 e2 0f             	and    $0xf,%edx
  10046f:	09 d0                	or     %edx,%eax
  100471:	a3 04 33 10 00       	mov    %eax,0x103304
}
  100476:	c3                   	ret    

00100477 <init_video>:

/* Sets our text-mode VGA pointer, then clears the screen for us */
void init_video(void)
{
  100477:	83 ec 0c             	sub    $0xc,%esp
    textmemptr = (unsigned short *)0xB8000;
  10047a:	c7 05 40 b9 10 00 00 	movl   $0xb8000,0x10b940
  100481:	80 0b 00 
    cls();
}
  100484:	83 c4 0c             	add    $0xc,%esp

/* Sets our text-mode VGA pointer, then clears the screen for us */
void init_video(void)
{
    textmemptr = (unsigned short *)0xB8000;
    cls();
  100487:	e9 8a fe ff ff       	jmp    100316 <cls>

0010048c <print_regs>:
}

/* For debugging */
void
print_regs(struct PushRegs *regs)
{
  10048c:	53                   	push   %ebx
  10048d:	83 ec 10             	sub    $0x10,%esp
  100490:	8b 5c 24 18          	mov    0x18(%esp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
  100494:	ff 33                	pushl  (%ebx)
  100496:	68 dc 19 10 00       	push   $0x1019dc
  10049b:	e8 b6 02 00 00       	call   100756 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
  1004a0:	58                   	pop    %eax
  1004a1:	5a                   	pop    %edx
  1004a2:	ff 73 04             	pushl  0x4(%ebx)
  1004a5:	68 eb 19 10 00       	push   $0x1019eb
  1004aa:	e8 a7 02 00 00       	call   100756 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  1004af:	5a                   	pop    %edx
  1004b0:	59                   	pop    %ecx
  1004b1:	ff 73 08             	pushl  0x8(%ebx)
  1004b4:	68 fa 19 10 00       	push   $0x1019fa
  1004b9:	e8 98 02 00 00       	call   100756 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  1004be:	59                   	pop    %ecx
  1004bf:	58                   	pop    %eax
  1004c0:	ff 73 0c             	pushl  0xc(%ebx)
  1004c3:	68 09 1a 10 00       	push   $0x101a09
  1004c8:	e8 89 02 00 00       	call   100756 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  1004cd:	58                   	pop    %eax
  1004ce:	5a                   	pop    %edx
  1004cf:	ff 73 10             	pushl  0x10(%ebx)
  1004d2:	68 18 1a 10 00       	push   $0x101a18
  1004d7:	e8 7a 02 00 00       	call   100756 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
  1004dc:	5a                   	pop    %edx
  1004dd:	59                   	pop    %ecx
  1004de:	ff 73 14             	pushl  0x14(%ebx)
  1004e1:	68 27 1a 10 00       	push   $0x101a27
  1004e6:	e8 6b 02 00 00       	call   100756 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  1004eb:	59                   	pop    %ecx
  1004ec:	58                   	pop    %eax
  1004ed:	ff 73 18             	pushl  0x18(%ebx)
  1004f0:	68 36 1a 10 00       	push   $0x101a36
  1004f5:	e8 5c 02 00 00       	call   100756 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
  1004fa:	58                   	pop    %eax
  1004fb:	5a                   	pop    %edx
  1004fc:	ff 73 1c             	pushl  0x1c(%ebx)
  1004ff:	68 45 1a 10 00       	push   $0x101a45
  100504:	e8 4d 02 00 00       	call   100756 <cprintf>
}
  100509:	83 c4 18             	add    $0x18,%esp
  10050c:	5b                   	pop    %ebx
  10050d:	c3                   	ret    

0010050e <print_trapframe>:
}

/* For debugging */
void
print_trapframe(struct Trapframe *tf)
{
  10050e:	56                   	push   %esi
  10050f:	53                   	push   %ebx
  100510:	83 ec 10             	sub    $0x10,%esp
  100513:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
	cprintf("TRAP frame at %p \n");
  100517:	68 a9 1a 10 00       	push   $0x101aa9
  10051c:	e8 35 02 00 00       	call   100756 <cprintf>
	print_regs(&tf->tf_regs);
  100521:	89 1c 24             	mov    %ebx,(%esp)
  100524:	e8 63 ff ff ff       	call   10048c <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
  100529:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
  10052d:	5a                   	pop    %edx
  10052e:	59                   	pop    %ecx
  10052f:	50                   	push   %eax
  100530:	68 bc 1a 10 00       	push   $0x101abc
  100535:	e8 1c 02 00 00       	call   100756 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
  10053a:	5e                   	pop    %esi
  10053b:	58                   	pop    %eax
  10053c:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
  100540:	50                   	push   %eax
  100541:	68 cf 1a 10 00       	push   $0x101acf
  100546:	e8 0b 02 00 00       	call   100756 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  10054b:	8b 43 28             	mov    0x28(%ebx),%eax
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
  10054e:	83 c4 10             	add    $0x10,%esp
  100551:	83 f8 13             	cmp    $0x13,%eax
  100554:	77 09                	ja     10055f <print_trapframe+0x51>
		return excnames[trapno];
  100556:	8b 14 85 b8 1c 10 00 	mov    0x101cb8(,%eax,4),%edx
  10055d:	eb 1d                	jmp    10057c <print_trapframe+0x6e>
	if (trapno == T_SYSCALL)
  10055f:	83 f8 30             	cmp    $0x30,%eax
		return "System call";
  100562:	ba 54 1a 10 00       	mov    $0x101a54,%edx
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
  100567:	74 13                	je     10057c <print_trapframe+0x6e>
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
  100569:	8d 48 e0             	lea    -0x20(%eax),%ecx
		return "Hardware Interrupt";
  10056c:	ba 60 1a 10 00       	mov    $0x101a60,%edx
  100571:	83 f9 0f             	cmp    $0xf,%ecx
  100574:	b9 73 1a 10 00       	mov    $0x101a73,%ecx
  100579:	0f 47 d1             	cmova  %ecx,%edx
{
	cprintf("TRAP frame at %p \n");
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  10057c:	51                   	push   %ecx
  10057d:	52                   	push   %edx
  10057e:	50                   	push   %eax
  10057f:	68 e2 1a 10 00       	push   $0x101ae2
  100584:	e8 cd 01 00 00       	call   100756 <cprintf>
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
  100589:	83 c4 10             	add    $0x10,%esp
  10058c:	3b 1d 38 b5 10 00    	cmp    0x10b538,%ebx
  100592:	75 19                	jne    1005ad <print_trapframe+0x9f>
  100594:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
  100598:	75 13                	jne    1005ad <print_trapframe+0x9f>

static __inline uint32_t
rcr2(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr2,%0" : "=r" (val));
  10059a:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
  10059d:	52                   	push   %edx
  10059e:	52                   	push   %edx
  10059f:	50                   	push   %eax
  1005a0:	68 f4 1a 10 00       	push   $0x101af4
  1005a5:	e8 ac 01 00 00       	call   100756 <cprintf>
  1005aa:	83 c4 10             	add    $0x10,%esp
	cprintf("  err  0x%08x", tf->tf_err);
  1005ad:	56                   	push   %esi
  1005ae:	56                   	push   %esi
  1005af:	ff 73 2c             	pushl  0x2c(%ebx)
  1005b2:	68 03 1b 10 00       	push   $0x101b03
  1005b7:	e8 9a 01 00 00       	call   100756 <cprintf>
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
  1005bc:	83 c4 10             	add    $0x10,%esp
  1005bf:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
  1005c3:	75 43                	jne    100608 <print_trapframe+0xfa>
		cprintf(" [%s, %s, %s]\n",
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
  1005c5:	8b 73 2c             	mov    0x2c(%ebx),%esi
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		cprintf(" [%s, %s, %s]\n",
  1005c8:	b8 8d 1a 10 00       	mov    $0x101a8d,%eax
  1005cd:	b9 82 1a 10 00       	mov    $0x101a82,%ecx
  1005d2:	ba 99 1a 10 00       	mov    $0x101a99,%edx
  1005d7:	f7 c6 01 00 00 00    	test   $0x1,%esi
  1005dd:	0f 44 c8             	cmove  %eax,%ecx
  1005e0:	f7 c6 02 00 00 00    	test   $0x2,%esi
  1005e6:	b8 9f 1a 10 00       	mov    $0x101a9f,%eax
  1005eb:	0f 44 d0             	cmove  %eax,%edx
  1005ee:	83 e6 04             	and    $0x4,%esi
  1005f1:	51                   	push   %ecx
  1005f2:	b8 a4 1a 10 00       	mov    $0x101aa4,%eax
  1005f7:	be ca 1d 10 00       	mov    $0x101dca,%esi
  1005fc:	52                   	push   %edx
  1005fd:	0f 44 c6             	cmove  %esi,%eax
  100600:	50                   	push   %eax
  100601:	68 11 1b 10 00       	push   $0x101b11
  100606:	eb 08                	jmp    100610 <print_trapframe+0x102>
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
	else
		cprintf("\n");
  100608:	83 ec 0c             	sub    $0xc,%esp
  10060b:	68 ba 1a 10 00       	push   $0x101aba
  100610:	e8 41 01 00 00       	call   100756 <cprintf>
  100615:	5a                   	pop    %edx
  100616:	59                   	pop    %ecx
	cprintf("  eip  0x%08x\n", tf->tf_eip);
  100617:	ff 73 30             	pushl  0x30(%ebx)
  10061a:	68 20 1b 10 00       	push   $0x101b20
  10061f:	e8 32 01 00 00       	call   100756 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
  100624:	5e                   	pop    %esi
  100625:	58                   	pop    %eax
  100626:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
  10062a:	50                   	push   %eax
  10062b:	68 2f 1b 10 00       	push   $0x101b2f
  100630:	e8 21 01 00 00       	call   100756 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
  100635:	5a                   	pop    %edx
  100636:	59                   	pop    %ecx
  100637:	ff 73 38             	pushl  0x38(%ebx)
  10063a:	68 42 1b 10 00       	push   $0x101b42
  10063f:	e8 12 01 00 00       	call   100756 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
  100644:	83 c4 10             	add    $0x10,%esp
  100647:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
  10064b:	74 23                	je     100670 <print_trapframe+0x162>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
  10064d:	50                   	push   %eax
  10064e:	50                   	push   %eax
  10064f:	ff 73 3c             	pushl  0x3c(%ebx)
  100652:	68 51 1b 10 00       	push   $0x101b51
  100657:	e8 fa 00 00 00       	call   100756 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
  10065c:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
  100660:	59                   	pop    %ecx
  100661:	5e                   	pop    %esi
  100662:	50                   	push   %eax
  100663:	68 60 1b 10 00       	push   $0x101b60
  100668:	e8 e9 00 00 00       	call   100756 <cprintf>
  10066d:	83 c4 10             	add    $0x10,%esp
	}
}
  100670:	83 c4 04             	add    $0x4,%esp
  100673:	5b                   	pop    %ebx
  100674:	5e                   	pop    %esi
  100675:	c3                   	ret    

00100676 <default_trap_handler>:

/*
 * Note: This is the called for every interrupt.
 */
void default_trap_handler(struct Trapframe *tf)
{
  100676:	83 ec 0c             	sub    $0xc,%esp
  100679:	8b 44 24 10          	mov    0x10(%esp),%eax
   */

	extern void timer_handler();
	extern void kbd_intr();

	switch(tf->tf_trapno){
  10067d:	8b 50 28             	mov    0x28(%eax),%edx
 */
void default_trap_handler(struct Trapframe *tf)
{
	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;
  100680:	a3 38 b5 10 00       	mov    %eax,0x10b538
   */

	extern void timer_handler();
	extern void kbd_intr();

	switch(tf->tf_trapno){
  100685:	83 fa 20             	cmp    $0x20,%edx
  100688:	74 07                	je     100691 <default_trap_handler+0x1b>
  10068a:	83 fa 21             	cmp    $0x21,%edx
  10068d:	75 12                	jne    1006a1 <default_trap_handler+0x2b>
  10068f:	eb 08                	jmp    100699 <default_trap_handler+0x23>
	// print_trapframe can print some additional information.
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);
}
  100691:	83 c4 0c             	add    $0xc,%esp
	extern void timer_handler();
	extern void kbd_intr();

	switch(tf->tf_trapno){
		case IRQ_OFFSET + IRQ_TIMER:
			timer_handler();
  100694:	e9 41 03 00 00       	jmp    1009da <timer_handler>
	// print_trapframe can print some additional information.
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);
}
  100699:	83 c4 0c             	add    $0xc,%esp
	switch(tf->tf_trapno){
		case IRQ_OFFSET + IRQ_TIMER:
			timer_handler();
			break;
		case IRQ_OFFSET + IRQ_KBD:
			kbd_intr();
  10069c:	e9 5e fb ff ff       	jmp    1001ff <kbd_intr>
			break;
		default:
			// Unexpected trap: The user process or the kernel has a bug.
			print_trapframe(tf);
  1006a1:	89 44 24 10          	mov    %eax,0x10(%esp)
	// print_trapframe can print some additional information.
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);
}
  1006a5:	83 c4 0c             	add    $0xc,%esp
		case IRQ_OFFSET + IRQ_KBD:
			kbd_intr();
			break;
		default:
			// Unexpected trap: The user process or the kernel has a bug.
			print_trapframe(tf);
  1006a8:	e9 61 fe ff ff       	jmp    10050e <print_trapframe>

001006ad <trap_init>:
   *       come in handy for you when filling up the argument of "lidt"
   */

	/* Keyboard interrupt setup */
	extern void irq_kbd();
	SETGATE(idt[IRQ_OFFSET + IRQ_KBD], 0, GD_KT, irq_kbd, 0);
  1006ad:	b8 12 07 10 00       	mov    $0x100712,%eax
  1006b2:	66 a3 4c ba 10 00    	mov    %ax,0x10ba4c
  1006b8:	c1 e8 10             	shr    $0x10,%eax
  1006bb:	66 a3 52 ba 10 00    	mov    %ax,0x10ba52
	/* Timer Trap setup */
	extern void irq_timer();
	SETGATE(idt[IRQ_OFFSET + IRQ_TIMER], 0, GD_KT, irq_timer, 0);
  1006c1:	b8 0c 07 10 00       	mov    $0x10070c,%eax
  1006c6:	66 a3 44 ba 10 00    	mov    %ax,0x10ba44
  1006cc:	c1 e8 10             	shr    $0x10,%eax
  1006cf:	66 a3 4a ba 10 00    	mov    %ax,0x10ba4a
}

static __inline void
lidt(void *p)
{
	__asm __volatile("lidt (%0)" : : "r" (p));
  1006d5:	b8 08 33 10 00       	mov    $0x103308,%eax
   *       come in handy for you when filling up the argument of "lidt"
   */

	/* Keyboard interrupt setup */
	extern void irq_kbd();
	SETGATE(idt[IRQ_OFFSET + IRQ_KBD], 0, GD_KT, irq_kbd, 0);
  1006da:	66 c7 05 4e ba 10 00 	movw   $0x8,0x10ba4e
  1006e1:	08 00 
  1006e3:	c6 05 50 ba 10 00 00 	movb   $0x0,0x10ba50
  1006ea:	c6 05 51 ba 10 00 8e 	movb   $0x8e,0x10ba51
	/* Timer Trap setup */
	extern void irq_timer();
	SETGATE(idt[IRQ_OFFSET + IRQ_TIMER], 0, GD_KT, irq_timer, 0);
  1006f1:	66 c7 05 46 ba 10 00 	movw   $0x8,0x10ba46
  1006f8:	08 00 
  1006fa:	c6 05 48 ba 10 00 00 	movb   $0x0,0x10ba48
  100701:	c6 05 49 ba 10 00 8e 	movb   $0x8e,0x10ba49
  100708:	0f 01 18             	lidtl  (%eax)
	/* Load IDT */
	lidt(&idt_pd);
}
  10070b:	c3                   	ret    

0010070c <irq_timer>:
/* TODO: Interface declaration for ISRs
 * Note: Use TRAPHANDLER_NOEC macro define other isr enrty
 *       The Trap number are declared in inc/trap.h which might come in handy
 *       when declaring interface for ISRs.
 */
TRAPHANDLER_NOEC(irq_timer, IRQ_OFFSET + IRQ_TIMER)
  10070c:	6a 00                	push   $0x0
  10070e:	6a 20                	push   $0x20
  100710:	eb 06                	jmp    100718 <_alltraps>

00100712 <irq_kbd>:
TRAPHANDLER_NOEC(irq_kbd, IRQ_OFFSET + IRQ_KBD)
  100712:	6a 00                	push   $0x0
  100714:	6a 21                	push   $0x21
  100716:	eb 00                	jmp    100718 <_alltraps>

00100718 <_alltraps>:
   *       CPU.
   *       You may want to leverage the "pusha" instructions to reduce your work of
   *       pushing all the general purpose registers into the stack.
	 */

     pushl %ds
  100718:	1e                   	push   %ds
     pushl %es
  100719:	06                   	push   %es
     pushal
  10071a:	60                   	pusha  
     pushl %esp # Pass a pointer which points to the Trapframe as an argument to default_trap_handler()
  10071b:	54                   	push   %esp
     call default_trap_handler
  10071c:	e8 55 ff ff ff       	call   100676 <default_trap_handler>

     popl %esp
  100721:	5c                   	pop    %esp
     popal
  100722:	61                   	popa   
     popl %es
  100723:	07                   	pop    %es
     popl %ds
  100724:	1f                   	pop    %ds
     add $8, %esp # Cleans up the pushed error code and pushed ISR number
  100725:	83 c4 08             	add    $0x8,%esp
     iret # pops 5 things at once: CS, EIP, EFLAGS, SS, and ESP!
  100728:	cf                   	iret   
  100729:	00 00                	add    %al,(%eax)
	...

0010072c <vcprintf>:
#include <inc/stdio.h>


int
vcprintf(const char *fmt, va_list ap)
{
  10072c:	83 ec 1c             	sub    $0x1c,%esp
	int cnt = 0;
  10072f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  100736:	00 

	vprintfmt((void*)putch, &cnt, fmt, ap);
  100737:	ff 74 24 24          	pushl  0x24(%esp)
  10073b:	ff 74 24 24          	pushl  0x24(%esp)
  10073f:	8d 44 24 14          	lea    0x14(%esp),%eax
  100743:	50                   	push   %eax
  100744:	68 69 03 10 00       	push   $0x100369
  100749:	e8 31 04 00 00       	call   100b7f <vprintfmt>
	return cnt;
}
  10074e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  100752:	83 c4 2c             	add    $0x2c,%esp
  100755:	c3                   	ret    

00100756 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  100756:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  100759:	8d 44 24 14          	lea    0x14(%esp),%eax
	cnt = vcprintf(fmt, ap);
  10075d:	52                   	push   %edx
  10075e:	52                   	push   %edx
  10075f:	50                   	push   %eax
  100760:	ff 74 24 1c          	pushl  0x1c(%esp)
  100764:	e8 c3 ff ff ff       	call   10072c <vcprintf>
	va_end(ap);

	return cnt;
}
  100769:	83 c4 1c             	add    $0x1c,%esp
  10076c:	c3                   	ret    
  10076d:	00 00                	add    %al,(%eax)
	...

00100770 <mon_kerninfo>:
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int mon_kerninfo(int argc, char **argv)
{
  100770:	53                   	push   %ebx
	*/

	extern uint32_t kernel_load_addr, etext;
	extern uint32_t sdata, end;

  	cprintf("kernel code base start=0x%08x size=%d\n", &kernel_load_addr, (uint32_t)&etext - (uint32_t)&kernel_load_addr);
  100771:	b8 b5 17 10 00       	mov    $0x1017b5,%eax
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int mon_kerninfo(int argc, char **argv)
{
  100776:	83 ec 0c             	sub    $0xc,%esp
	*/

	extern uint32_t kernel_load_addr, etext;
	extern uint32_t sdata, end;

  	cprintf("kernel code base start=0x%08x size=%d\n", &kernel_load_addr, (uint32_t)&etext - (uint32_t)&kernel_load_addr);
  100779:	2d 00 00 10 00       	sub    $0x100000,%eax
  10077e:	50                   	push   %eax
	cprintf("kernel data base start=0x%08x size=%d\n", &sdata, (uint32_t)&end - (uint32_t)&sdata);
  10077f:	bb 44 c1 10 00       	mov    $0x10c144,%ebx
	*/

	extern uint32_t kernel_load_addr, etext;
	extern uint32_t sdata, end;

  	cprintf("kernel code base start=0x%08x size=%d\n", &kernel_load_addr, (uint32_t)&etext - (uint32_t)&kernel_load_addr);
  100784:	68 00 00 10 00       	push   $0x100000
  100789:	68 08 1d 10 00       	push   $0x101d08
  10078e:	e8 c3 ff ff ff       	call   100756 <cprintf>
	cprintf("kernel data base start=0x%08x size=%d\n", &sdata, (uint32_t)&end - (uint32_t)&sdata);
  100793:	89 d8                	mov    %ebx,%eax
  100795:	83 c4 0c             	add    $0xc,%esp
  100798:	2d 00 30 10 00       	sub    $0x103000,%eax
	cprintf("kernel executable memory footprint: %dKB\n", ((uint32_t)&end - (uint32_t)&kernel_load_addr) >> 10);
  10079d:	81 eb 00 00 10 00    	sub    $0x100000,%ebx

	extern uint32_t kernel_load_addr, etext;
	extern uint32_t sdata, end;

  	cprintf("kernel code base start=0x%08x size=%d\n", &kernel_load_addr, (uint32_t)&etext - (uint32_t)&kernel_load_addr);
	cprintf("kernel data base start=0x%08x size=%d\n", &sdata, (uint32_t)&end - (uint32_t)&sdata);
  1007a3:	50                   	push   %eax
  1007a4:	68 00 30 10 00       	push   $0x103000
  1007a9:	68 2f 1d 10 00       	push   $0x101d2f
  1007ae:	e8 a3 ff ff ff       	call   100756 <cprintf>
	cprintf("kernel executable memory footprint: %dKB\n", ((uint32_t)&end - (uint32_t)&kernel_load_addr) >> 10);
  1007b3:	c1 eb 0a             	shr    $0xa,%ebx
  1007b6:	58                   	pop    %eax
  1007b7:	5a                   	pop    %edx
  1007b8:	53                   	push   %ebx
  1007b9:	68 56 1d 10 00       	push   $0x101d56
  1007be:	e8 93 ff ff ff       	call   100756 <cprintf>
	/*
	extern char kernel_load_addr[], etext[];
	cprintf("Kernel code base start=0x%x size=%d\n", kernel_load_addr, etext - kernel_load_addr);
	*/
	return 0;
}
  1007c3:	31 c0                	xor    %eax,%eax
  1007c5:	83 c4 18             	add    $0x18,%esp
  1007c8:	5b                   	pop    %ebx
  1007c9:	c3                   	ret    

001007ca <mon_help>:
};
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))


int mon_help(int argc, char **argv)
{
  1007ca:	83 ec 10             	sub    $0x10,%esp
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  1007cd:	68 80 1d 10 00       	push   $0x101d80
  1007d2:	68 9e 1d 10 00       	push   $0x101d9e
  1007d7:	68 a3 1d 10 00       	push   $0x101da3
  1007dc:	e8 75 ff ff ff       	call   100756 <cprintf>
  1007e1:	83 c4 0c             	add    $0xc,%esp
  1007e4:	68 ac 1d 10 00       	push   $0x101dac
  1007e9:	68 d1 1d 10 00       	push   $0x101dd1
  1007ee:	68 a3 1d 10 00       	push   $0x101da3
  1007f3:	e8 5e ff ff ff       	call   100756 <cprintf>
  1007f8:	83 c4 0c             	add    $0xc,%esp
  1007fb:	68 da 1d 10 00       	push   $0x101dda
  100800:	68 ee 1d 10 00       	push   $0x101dee
  100805:	68 a3 1d 10 00       	push   $0x101da3
  10080a:	e8 47 ff ff ff       	call   100756 <cprintf>
  10080f:	83 c4 0c             	add    $0xc,%esp
  100812:	68 f9 1d 10 00       	push   $0x101df9
  100817:	68 0b 1e 10 00       	push   $0x101e0b
  10081c:	68 a3 1d 10 00       	push   $0x101da3
  100821:	e8 30 ff ff ff       	call   100756 <cprintf>
	return 0;
}
  100826:	31 c0                	xor    %eax,%eax
  100828:	83 c4 1c             	add    $0x1c,%esp
  10082b:	c3                   	ret    

0010082c <chg_color>:
int print_tick(int argc, char **argv)
{
	cprintf("Now tick = %d\n", get_tick());
}

int chg_color(int argc, char **argv) {
  10082c:	56                   	push   %esi
  10082d:	53                   	push   %ebx
  10082e:	83 ec 04             	sub    $0x4,%esp
  100831:	8b 44 24 10          	mov    0x10(%esp),%eax
  100835:	8b 74 24 14          	mov    0x14(%esp),%esi

	extern void settextcolor();

	if (argc == 1) {
  100839:	83 f8 01             	cmp    $0x1,%eax
  10083c:	75 17                	jne    100855 <chg_color+0x29>
		cprintf("No input text color!\n");
  10083e:	83 ec 0c             	sub    $0xc,%esp
		return 1;
  100841:	bb 01 00 00 00       	mov    $0x1,%ebx
int chg_color(int argc, char **argv) {

	extern void settextcolor();

	if (argc == 1) {
		cprintf("No input text color!\n");
  100846:	68 14 1e 10 00       	push   $0x101e14
  10084b:	e8 06 ff ff ff       	call   100756 <cprintf>
		return 1;
  100850:	83 c4 10             	add    $0x10,%esp
  100853:	eb 33                	jmp    100888 <chg_color+0x5c>
	} else if (argc == 2) {
		settextcolor(argv[1][0] - '0', 0);
		cprintf("Change color %d!\n", argv[1][0] - '0');
	}

	return 0;
  100855:	31 db                	xor    %ebx,%ebx
	extern void settextcolor();

	if (argc == 1) {
		cprintf("No input text color!\n");
		return 1;
	} else if (argc == 2) {
  100857:	83 f8 02             	cmp    $0x2,%eax
  10085a:	75 2c                	jne    100888 <chg_color+0x5c>
		settextcolor(argv[1][0] - '0', 0);
  10085c:	52                   	push   %edx
  10085d:	52                   	push   %edx
  10085e:	6a 00                	push   $0x0
  100860:	8b 46 04             	mov    0x4(%esi),%eax
  100863:	0f be 00             	movsbl (%eax),%eax
  100866:	83 e8 30             	sub    $0x30,%eax
  100869:	50                   	push   %eax
  10086a:	e8 f0 fb ff ff       	call   10045f <settextcolor>
		cprintf("Change color %d!\n", argv[1][0] - '0');
  10086f:	59                   	pop    %ecx
  100870:	58                   	pop    %eax
  100871:	8b 46 04             	mov    0x4(%esi),%eax
  100874:	0f be 00             	movsbl (%eax),%eax
  100877:	83 e8 30             	sub    $0x30,%eax
  10087a:	50                   	push   %eax
  10087b:	68 2a 1e 10 00       	push   $0x101e2a
  100880:	e8 d1 fe ff ff       	call   100756 <cprintf>
  100885:	83 c4 10             	add    $0x10,%esp
	}

	return 0;
}
  100888:	89 d8                	mov    %ebx,%eax
  10088a:	83 c4 04             	add    $0x4,%esp
  10088d:	5b                   	pop    %ebx
  10088e:	5e                   	pop    %esi
  10088f:	c3                   	ret    

00100890 <print_tick>:
	cprintf("Kernel code base start=0x%x size=%d\n", kernel_load_addr, etext - kernel_load_addr);
	*/
	return 0;
}
int print_tick(int argc, char **argv)
{
  100890:	83 ec 0c             	sub    $0xc,%esp
	cprintf("Now tick = %d\n", get_tick());
  100893:	e8 49 01 00 00       	call   1009e1 <get_tick>
  100898:	c7 44 24 10 3c 1e 10 	movl   $0x101e3c,0x10(%esp)
  10089f:	00 
  1008a0:	89 44 24 14          	mov    %eax,0x14(%esp)
}
  1008a4:	83 c4 0c             	add    $0xc,%esp
	*/
	return 0;
}
int print_tick(int argc, char **argv)
{
	cprintf("Now tick = %d\n", get_tick());
  1008a7:	e9 aa fe ff ff       	jmp    100756 <cprintf>

001008ac <shell>:
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}
void shell()
{
  1008ac:	55                   	push   %ebp
  1008ad:	57                   	push   %edi
  1008ae:	56                   	push   %esi
  1008af:	53                   	push   %ebx
  1008b0:	83 ec 58             	sub    $0x58,%esp
	char *buf;
	cprintf("Welcome to the OSDI course!\n");
  1008b3:	68 4b 1e 10 00       	push   $0x101e4b
  1008b8:	e8 99 fe ff ff       	call   100756 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
  1008bd:	c7 04 24 68 1e 10 00 	movl   $0x101e68,(%esp)
  1008c4:	e8 8d fe ff ff       	call   100756 <cprintf>
  1008c9:	83 c4 10             	add    $0x10,%esp
	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv);
  1008cc:	89 e5                	mov    %esp,%ebp
	cprintf("Welcome to the OSDI course!\n");
	cprintf("Type 'help' for a list of commands.\n");

	while(1)
	{
		buf = readline("OSDI> ");
  1008ce:	83 ec 0c             	sub    $0xc,%esp
  1008d1:	68 8d 1e 10 00       	push   $0x101e8d
  1008d6:	e8 95 07 00 00       	call   101070 <readline>
		if (buf != NULL)
  1008db:	83 c4 10             	add    $0x10,%esp
  1008de:	85 c0                	test   %eax,%eax
	cprintf("Welcome to the OSDI course!\n");
	cprintf("Type 'help' for a list of commands.\n");

	while(1)
	{
		buf = readline("OSDI> ");
  1008e0:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
  1008e2:	74 ea                	je     1008ce <shell+0x22>
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
  1008e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
  1008eb:	31 f6                	xor    %esi,%esi
  1008ed:	eb 04                	jmp    1008f3 <shell+0x47>
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
  1008ef:	c6 03 00             	movb   $0x0,(%ebx)
  1008f2:	43                   	inc    %ebx
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
  1008f3:	8a 03                	mov    (%ebx),%al
  1008f5:	84 c0                	test   %al,%al
  1008f7:	74 17                	je     100910 <shell+0x64>
  1008f9:	57                   	push   %edi
  1008fa:	0f be c0             	movsbl %al,%eax
  1008fd:	57                   	push   %edi
  1008fe:	50                   	push   %eax
  1008ff:	68 94 1e 10 00       	push   $0x101e94
  100904:	e8 88 09 00 00       	call   101291 <strchr>
  100909:	83 c4 10             	add    $0x10,%esp
  10090c:	85 c0                	test   %eax,%eax
  10090e:	75 df                	jne    1008ef <shell+0x43>
			*buf++ = 0;
		if (*buf == 0)
  100910:	80 3b 00             	cmpb   $0x0,(%ebx)
  100913:	74 36                	je     10094b <shell+0x9f>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
  100915:	83 fe 0f             	cmp    $0xf,%esi
  100918:	75 0b                	jne    100925 <shell+0x79>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
  10091a:	51                   	push   %ecx
  10091b:	51                   	push   %ecx
  10091c:	6a 10                	push   $0x10
  10091e:	68 99 1e 10 00       	push   $0x101e99
  100923:	eb 7d                	jmp    1009a2 <shell+0xf6>
			return 0;
		}
		argv[argc++] = buf;
  100925:	89 1c b4             	mov    %ebx,(%esp,%esi,4)
  100928:	46                   	inc    %esi
  100929:	eb 01                	jmp    10092c <shell+0x80>
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
  10092b:	43                   	inc    %ebx
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
  10092c:	8a 03                	mov    (%ebx),%al
  10092e:	84 c0                	test   %al,%al
  100930:	74 c1                	je     1008f3 <shell+0x47>
  100932:	52                   	push   %edx
  100933:	0f be c0             	movsbl %al,%eax
  100936:	52                   	push   %edx
  100937:	50                   	push   %eax
  100938:	68 94 1e 10 00       	push   $0x101e94
  10093d:	e8 4f 09 00 00       	call   101291 <strchr>
  100942:	83 c4 10             	add    $0x10,%esp
  100945:	85 c0                	test   %eax,%eax
  100947:	74 e2                	je     10092b <shell+0x7f>
  100949:	eb a8                	jmp    1008f3 <shell+0x47>
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
  10094b:	85 f6                	test   %esi,%esi
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;
  10094d:	c7 04 b4 00 00 00 00 	movl   $0x0,(%esp,%esi,4)

	// Lookup and invoke the command
	if (argc == 0)
  100954:	0f 84 74 ff ff ff    	je     1008ce <shell+0x22>
  10095a:	bf cc 1e 10 00       	mov    $0x101ecc,%edi
  10095f:	31 db                	xor    %ebx,%ebx
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
  100961:	50                   	push   %eax
  100962:	50                   	push   %eax
  100963:	ff 37                	pushl  (%edi)
  100965:	83 c7 0c             	add    $0xc,%edi
  100968:	ff 74 24 0c          	pushl  0xc(%esp)
  10096c:	e8 a9 08 00 00       	call   10121a <strcmp>
  100971:	83 c4 10             	add    $0x10,%esp
  100974:	85 c0                	test   %eax,%eax
  100976:	75 19                	jne    100991 <shell+0xe5>
			return commands[i].func(argc, argv);
  100978:	6b db 0c             	imul   $0xc,%ebx,%ebx
  10097b:	57                   	push   %edi
  10097c:	57                   	push   %edi
  10097d:	55                   	push   %ebp
  10097e:	56                   	push   %esi
  10097f:	ff 93 d4 1e 10 00    	call   *0x101ed4(%ebx)
	while(1)
	{
		buf = readline("OSDI> ");
		if (buf != NULL)
		{
			if (runcmd(buf) < 0)
  100985:	83 c4 10             	add    $0x10,%esp
  100988:	85 c0                	test   %eax,%eax
  10098a:	78 23                	js     1009af <shell+0x103>
  10098c:	e9 3d ff ff ff       	jmp    1008ce <shell+0x22>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
  100991:	43                   	inc    %ebx
  100992:	83 fb 04             	cmp    $0x4,%ebx
  100995:	75 ca                	jne    100961 <shell+0xb5>
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
  100997:	51                   	push   %ecx
  100998:	51                   	push   %ecx
  100999:	ff 74 24 08          	pushl  0x8(%esp)
  10099d:	68 b6 1e 10 00       	push   $0x101eb6
  1009a2:	e8 af fd ff ff       	call   100756 <cprintf>
  1009a7:	83 c4 10             	add    $0x10,%esp
  1009aa:	e9 1f ff ff ff       	jmp    1008ce <shell+0x22>
		{
			if (runcmd(buf) < 0)
				break;
		}
	}
}
  1009af:	83 c4 4c             	add    $0x4c,%esp
  1009b2:	5b                   	pop    %ebx
  1009b3:	5e                   	pop    %esi
  1009b4:	5f                   	pop    %edi
  1009b5:	5d                   	pop    %ebp
  1009b6:	c3                   	ret    
	...

001009b8 <set_timer>:

static unsigned long jiffies = 0;

void set_timer(int hz)
{
    int divisor = 1193180 / hz;       /* Calculate our divisor */
  1009b8:	b9 dc 34 12 00       	mov    $0x1234dc,%ecx
  1009bd:	89 c8                	mov    %ecx,%eax
  1009bf:	99                   	cltd   
  1009c0:	f7 7c 24 04          	idivl  0x4(%esp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  1009c4:	ba 43 00 00 00       	mov    $0x43,%edx
  1009c9:	89 c1                	mov    %eax,%ecx
  1009cb:	b0 36                	mov    $0x36,%al
  1009cd:	ee                   	out    %al,(%dx)
  1009ce:	b2 40                	mov    $0x40,%dl
  1009d0:	88 c8                	mov    %cl,%al
  1009d2:	ee                   	out    %al,(%dx)
    outb(0x43, 0x36);             /* Set our command byte 0x36 */
    outb(0x40, divisor & 0xFF);   /* Set low byte of divisor */
    outb(0x40, divisor >> 8);     /* Set high byte of divisor */
  1009d3:	89 c8                	mov    %ecx,%eax
  1009d5:	c1 f8 08             	sar    $0x8,%eax
  1009d8:	ee                   	out    %al,(%dx)
}
  1009d9:	c3                   	ret    

001009da <timer_handler>:
/* 
 * Timer interrupt handler
 */
void timer_handler()
{
	jiffies++;
  1009da:	ff 05 3c b5 10 00    	incl   0x10b53c
}
  1009e0:	c3                   	ret    

001009e1 <get_tick>:

unsigned long get_tick()
{
	return jiffies;
}
  1009e1:	a1 3c b5 10 00       	mov    0x10b53c,%eax
  1009e6:	c3                   	ret    

001009e7 <timer_init>:
void timer_init()
{
  1009e7:	83 ec 0c             	sub    $0xc,%esp
	set_timer(TIME_HZ);
  1009ea:	6a 64                	push   $0x64
  1009ec:	e8 c7 ff ff ff       	call   1009b8 <set_timer>

	/* Enable interrupt */
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_TIMER));
  1009f1:	50                   	push   %eax
  1009f2:	50                   	push   %eax
  1009f3:	0f b7 05 00 30 10 00 	movzwl 0x103000,%eax
  1009fa:	25 fe ff 00 00       	and    $0xfffe,%eax
  1009ff:	50                   	push   %eax
  100a00:	e8 3f f6 ff ff       	call   100044 <irq_setmask_8259A>
}
  100a05:	83 c4 1c             	add    $0x1c,%esp
  100a08:	c3                   	ret    
  100a09:	00 00                	add    %al,(%eax)
  100a0b:	00 00                	add    %al,(%eax)
  100a0d:	00 00                	add    %al,(%eax)
	...

00100a10 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  100a10:	55                   	push   %ebp
  100a11:	57                   	push   %edi
  100a12:	56                   	push   %esi
  100a13:	53                   	push   %ebx
  100a14:	83 ec 3c             	sub    $0x3c,%esp
  100a17:	89 c5                	mov    %eax,%ebp
  100a19:	89 d6                	mov    %edx,%esi
  100a1b:	8b 44 24 50          	mov    0x50(%esp),%eax
  100a1f:	89 44 24 24          	mov    %eax,0x24(%esp)
  100a23:	8b 54 24 54          	mov    0x54(%esp),%edx
  100a27:	89 54 24 20          	mov    %edx,0x20(%esp)
  100a2b:	8b 5c 24 5c          	mov    0x5c(%esp),%ebx
  100a2f:	8b 7c 24 60          	mov    0x60(%esp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  100a33:	b8 00 00 00 00       	mov    $0x0,%eax
  100a38:	39 d0                	cmp    %edx,%eax
  100a3a:	72 13                	jb     100a4f <printnum+0x3f>
  100a3c:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  100a40:	39 4c 24 58          	cmp    %ecx,0x58(%esp)
  100a44:	76 09                	jbe    100a4f <printnum+0x3f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  100a46:	83 eb 01             	sub    $0x1,%ebx
  100a49:	85 db                	test   %ebx,%ebx
  100a4b:	7f 63                	jg     100ab0 <printnum+0xa0>
  100a4d:	eb 71                	jmp    100ac0 <printnum+0xb0>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  100a4f:	89 7c 24 10          	mov    %edi,0x10(%esp)
  100a53:	83 eb 01             	sub    $0x1,%ebx
  100a56:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  100a5a:	8b 5c 24 58          	mov    0x58(%esp),%ebx
  100a5e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  100a62:	8b 44 24 08          	mov    0x8(%esp),%eax
  100a66:	8b 54 24 0c          	mov    0xc(%esp),%edx
  100a6a:	89 44 24 28          	mov    %eax,0x28(%esp)
  100a6e:	89 54 24 2c          	mov    %edx,0x2c(%esp)
  100a72:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  100a79:	00 
  100a7a:	8b 54 24 24          	mov    0x24(%esp),%edx
  100a7e:	89 14 24             	mov    %edx,(%esp)
  100a81:	8b 4c 24 20          	mov    0x20(%esp),%ecx
  100a85:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100a89:	e8 d2 0a 00 00       	call   101560 <__udivdi3>
  100a8e:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  100a92:	8b 5c 24 2c          	mov    0x2c(%esp),%ebx
  100a96:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100a9a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  100a9e:	89 04 24             	mov    %eax,(%esp)
  100aa1:	89 54 24 04          	mov    %edx,0x4(%esp)
  100aa5:	89 f2                	mov    %esi,%edx
  100aa7:	89 e8                	mov    %ebp,%eax
  100aa9:	e8 62 ff ff ff       	call   100a10 <printnum>
  100aae:	eb 10                	jmp    100ac0 <printnum+0xb0>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  100ab0:	89 74 24 04          	mov    %esi,0x4(%esp)
  100ab4:	89 3c 24             	mov    %edi,(%esp)
  100ab7:	ff d5                	call   *%ebp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  100ab9:	83 eb 01             	sub    $0x1,%ebx
  100abc:	85 db                	test   %ebx,%ebx
  100abe:	7f f0                	jg     100ab0 <printnum+0xa0>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  100ac0:	89 74 24 04          	mov    %esi,0x4(%esp)
  100ac4:	8b 74 24 04          	mov    0x4(%esp),%esi
  100ac8:	8b 44 24 58          	mov    0x58(%esp),%eax
  100acc:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ad0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  100ad7:	00 
  100ad8:	8b 54 24 24          	mov    0x24(%esp),%edx
  100adc:	89 14 24             	mov    %edx,(%esp)
  100adf:	8b 4c 24 20          	mov    0x20(%esp),%ecx
  100ae3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100ae7:	e8 84 0b 00 00       	call   101670 <__umoddi3>
  100aec:	89 74 24 04          	mov    %esi,0x4(%esp)
  100af0:	0f be 80 fc 1e 10 00 	movsbl 0x101efc(%eax),%eax
  100af7:	89 04 24             	mov    %eax,(%esp)
  100afa:	ff d5                	call   *%ebp
}
  100afc:	83 c4 3c             	add    $0x3c,%esp
  100aff:	5b                   	pop    %ebx
  100b00:	5e                   	pop    %esi
  100b01:	5f                   	pop    %edi
  100b02:	5d                   	pop    %ebp
  100b03:	c3                   	ret    

00100b04 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  100b04:	83 fa 01             	cmp    $0x1,%edx
  100b07:	7e 0d                	jle    100b16 <getuint+0x12>
		return va_arg(*ap, unsigned long long);
  100b09:	8b 10                	mov    (%eax),%edx
  100b0b:	8d 4a 08             	lea    0x8(%edx),%ecx
  100b0e:	89 08                	mov    %ecx,(%eax)
  100b10:	8b 02                	mov    (%edx),%eax
  100b12:	8b 52 04             	mov    0x4(%edx),%edx
  100b15:	c3                   	ret    
	else if (lflag)
  100b16:	85 d2                	test   %edx,%edx
  100b18:	74 0f                	je     100b29 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  100b1a:	8b 10                	mov    (%eax),%edx
  100b1c:	8d 4a 04             	lea    0x4(%edx),%ecx
  100b1f:	89 08                	mov    %ecx,(%eax)
  100b21:	8b 02                	mov    (%edx),%eax
  100b23:	ba 00 00 00 00       	mov    $0x0,%edx
  100b28:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  100b29:	8b 10                	mov    (%eax),%edx
  100b2b:	8d 4a 04             	lea    0x4(%edx),%ecx
  100b2e:	89 08                	mov    %ecx,(%eax)
  100b30:	8b 02                	mov    (%edx),%eax
  100b32:	ba 00 00 00 00       	mov    $0x0,%edx
}
  100b37:	c3                   	ret    

00100b38 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  100b38:	8b 44 24 08          	mov    0x8(%esp),%eax
	b->cnt++;
  100b3c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  100b40:	8b 10                	mov    (%eax),%edx
  100b42:	3b 50 04             	cmp    0x4(%eax),%edx
  100b45:	73 0b                	jae    100b52 <sprintputch+0x1a>
		*b->buf++ = ch;
  100b47:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  100b4b:	88 0a                	mov    %cl,(%edx)
  100b4d:	83 c2 01             	add    $0x1,%edx
  100b50:	89 10                	mov    %edx,(%eax)
  100b52:	f3 c3                	repz ret 

00100b54 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  100b54:	83 ec 1c             	sub    $0x1c,%esp
	va_list ap;

	va_start(ap, fmt);
  100b57:	8d 44 24 2c          	lea    0x2c(%esp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  100b5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100b5f:	8b 44 24 28          	mov    0x28(%esp),%eax
  100b63:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b67:	8b 44 24 24          	mov    0x24(%esp),%eax
  100b6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b6f:	8b 44 24 20          	mov    0x20(%esp),%eax
  100b73:	89 04 24             	mov    %eax,(%esp)
  100b76:	e8 04 00 00 00       	call   100b7f <vprintfmt>
	va_end(ap);
}
  100b7b:	83 c4 1c             	add    $0x1c,%esp
  100b7e:	c3                   	ret    

00100b7f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  100b7f:	55                   	push   %ebp
  100b80:	57                   	push   %edi
  100b81:	56                   	push   %esi
  100b82:	53                   	push   %ebx
  100b83:	83 ec 4c             	sub    $0x4c,%esp
  100b86:	8b 6c 24 60          	mov    0x60(%esp),%ebp
  100b8a:	8b 7c 24 64          	mov    0x64(%esp),%edi
  100b8e:	8b 5c 24 68          	mov    0x68(%esp),%ebx
  100b92:	eb 11                	jmp    100ba5 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  100b94:	85 c0                	test   %eax,%eax
  100b96:	0f 84 40 04 00 00    	je     100fdc <vprintfmt+0x45d>
				return;
			putch(ch, putdat);
  100b9c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100ba0:	89 04 24             	mov    %eax,(%esp)
  100ba3:	ff d5                	call   *%ebp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  100ba5:	0f b6 03             	movzbl (%ebx),%eax
  100ba8:	83 c3 01             	add    $0x1,%ebx
  100bab:	83 f8 25             	cmp    $0x25,%eax
  100bae:	75 e4                	jne    100b94 <vprintfmt+0x15>
  100bb0:	c6 44 24 28 20       	movb   $0x20,0x28(%esp)
  100bb5:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
  100bbc:	00 
  100bbd:	be ff ff ff ff       	mov    $0xffffffff,%esi
  100bc2:	c7 44 24 30 ff ff ff 	movl   $0xffffffff,0x30(%esp)
  100bc9:	ff 
  100bca:	b9 00 00 00 00       	mov    $0x0,%ecx
  100bcf:	89 74 24 34          	mov    %esi,0x34(%esp)
  100bd3:	eb 34                	jmp    100c09 <vprintfmt+0x8a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100bd5:	8b 5c 24 24          	mov    0x24(%esp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  100bd9:	c6 44 24 28 2d       	movb   $0x2d,0x28(%esp)
  100bde:	eb 29                	jmp    100c09 <vprintfmt+0x8a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100be0:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  100be4:	c6 44 24 28 30       	movb   $0x30,0x28(%esp)
  100be9:	eb 1e                	jmp    100c09 <vprintfmt+0x8a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100beb:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  100bef:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%esp)
  100bf6:	00 
  100bf7:	eb 10                	jmp    100c09 <vprintfmt+0x8a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  100bf9:	8b 44 24 34          	mov    0x34(%esp),%eax
  100bfd:	89 44 24 30          	mov    %eax,0x30(%esp)
  100c01:	c7 44 24 34 ff ff ff 	movl   $0xffffffff,0x34(%esp)
  100c08:	ff 
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100c09:	0f b6 03             	movzbl (%ebx),%eax
  100c0c:	0f b6 d0             	movzbl %al,%edx
  100c0f:	8d 73 01             	lea    0x1(%ebx),%esi
  100c12:	89 74 24 24          	mov    %esi,0x24(%esp)
  100c16:	83 e8 23             	sub    $0x23,%eax
  100c19:	3c 55                	cmp    $0x55,%al
  100c1b:	0f 87 9c 03 00 00    	ja     100fbd <vprintfmt+0x43e>
  100c21:	0f b6 c0             	movzbl %al,%eax
  100c24:	ff 24 85 c0 1f 10 00 	jmp    *0x101fc0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  100c2b:	83 ea 30             	sub    $0x30,%edx
  100c2e:	89 54 24 34          	mov    %edx,0x34(%esp)
				ch = *fmt;
  100c32:	8b 54 24 24          	mov    0x24(%esp),%edx
  100c36:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  100c39:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100c3c:	8b 5c 24 24          	mov    0x24(%esp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  100c40:	83 fa 09             	cmp    $0x9,%edx
  100c43:	77 5b                	ja     100ca0 <vprintfmt+0x121>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100c45:	8b 74 24 34          	mov    0x34(%esp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  100c49:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  100c4c:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  100c4f:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  100c53:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  100c56:	8d 50 d0             	lea    -0x30(%eax),%edx
  100c59:	83 fa 09             	cmp    $0x9,%edx
  100c5c:	76 eb                	jbe    100c49 <vprintfmt+0xca>
  100c5e:	89 74 24 34          	mov    %esi,0x34(%esp)
  100c62:	eb 3c                	jmp    100ca0 <vprintfmt+0x121>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  100c64:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100c68:	8d 50 04             	lea    0x4(%eax),%edx
  100c6b:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100c6f:	8b 00                	mov    (%eax),%eax
  100c71:	89 44 24 34          	mov    %eax,0x34(%esp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100c75:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  100c79:	eb 25                	jmp    100ca0 <vprintfmt+0x121>

		case '.':
			if (width < 0)
  100c7b:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
  100c80:	0f 88 65 ff ff ff    	js     100beb <vprintfmt+0x6c>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100c86:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  100c8a:	e9 7a ff ff ff       	jmp    100c09 <vprintfmt+0x8a>
  100c8f:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  100c93:	c7 44 24 2c 01 00 00 	movl   $0x1,0x2c(%esp)
  100c9a:	00 
			goto reswitch;
  100c9b:	e9 69 ff ff ff       	jmp    100c09 <vprintfmt+0x8a>

		process_precision:
			if (width < 0)
  100ca0:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
  100ca5:	0f 89 5e ff ff ff    	jns    100c09 <vprintfmt+0x8a>
  100cab:	e9 49 ff ff ff       	jmp    100bf9 <vprintfmt+0x7a>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  100cb0:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100cb3:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  100cb7:	e9 4d ff ff ff       	jmp    100c09 <vprintfmt+0x8a>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  100cbc:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100cc0:	8d 50 04             	lea    0x4(%eax),%edx
  100cc3:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100cc7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100ccb:	8b 00                	mov    (%eax),%eax
  100ccd:	89 04 24             	mov    %eax,(%esp)
  100cd0:	ff d5                	call   *%ebp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100cd2:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  100cd6:	e9 ca fe ff ff       	jmp    100ba5 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  100cdb:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100cdf:	8d 50 04             	lea    0x4(%eax),%edx
  100ce2:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100ce6:	8b 00                	mov    (%eax),%eax
  100ce8:	89 c2                	mov    %eax,%edx
  100cea:	c1 fa 1f             	sar    $0x1f,%edx
  100ced:	31 d0                	xor    %edx,%eax
  100cef:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  100cf1:	83 f8 08             	cmp    $0x8,%eax
  100cf4:	7f 0b                	jg     100d01 <vprintfmt+0x182>
  100cf6:	8b 14 85 20 21 10 00 	mov    0x102120(,%eax,4),%edx
  100cfd:	85 d2                	test   %edx,%edx
  100cff:	75 21                	jne    100d22 <vprintfmt+0x1a3>
				printfmt(putch, putdat, "error %d", err);
  100d01:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100d05:	c7 44 24 08 14 1f 10 	movl   $0x101f14,0x8(%esp)
  100d0c:	00 
  100d0d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100d11:	89 2c 24             	mov    %ebp,(%esp)
  100d14:	e8 3b fe ff ff       	call   100b54 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100d19:	8b 5c 24 24          	mov    0x24(%esp),%ebx
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  100d1d:	e9 83 fe ff ff       	jmp    100ba5 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  100d22:	89 54 24 0c          	mov    %edx,0xc(%esp)
  100d26:	c7 44 24 08 1d 1f 10 	movl   $0x101f1d,0x8(%esp)
  100d2d:	00 
  100d2e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100d32:	89 2c 24             	mov    %ebp,(%esp)
  100d35:	e8 1a fe ff ff       	call   100b54 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100d3a:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  100d3e:	e9 62 fe ff ff       	jmp    100ba5 <vprintfmt+0x26>
  100d43:	8b 74 24 34          	mov    0x34(%esp),%esi
  100d47:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  100d4b:	8b 44 24 30          	mov    0x30(%esp),%eax
  100d4f:	89 44 24 38          	mov    %eax,0x38(%esp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  100d53:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100d57:	8d 50 04             	lea    0x4(%eax),%edx
  100d5a:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100d5e:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  100d60:	85 c0                	test   %eax,%eax
  100d62:	ba 0d 1f 10 00       	mov    $0x101f0d,%edx
  100d67:	0f 45 d0             	cmovne %eax,%edx
  100d6a:	89 54 24 34          	mov    %edx,0x34(%esp)
			if (width > 0 && padc != '-')
  100d6e:	83 7c 24 38 00       	cmpl   $0x0,0x38(%esp)
  100d73:	7e 07                	jle    100d7c <vprintfmt+0x1fd>
  100d75:	80 7c 24 28 2d       	cmpb   $0x2d,0x28(%esp)
  100d7a:	75 14                	jne    100d90 <vprintfmt+0x211>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  100d7c:	8b 54 24 34          	mov    0x34(%esp),%edx
  100d80:	0f be 02             	movsbl (%edx),%eax
  100d83:	85 c0                	test   %eax,%eax
  100d85:	0f 85 ac 00 00 00    	jne    100e37 <vprintfmt+0x2b8>
  100d8b:	e9 97 00 00 00       	jmp    100e27 <vprintfmt+0x2a8>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  100d90:	89 74 24 04          	mov    %esi,0x4(%esp)
  100d94:	8b 44 24 34          	mov    0x34(%esp),%eax
  100d98:	89 04 24             	mov    %eax,(%esp)
  100d9b:	e8 99 03 00 00       	call   101139 <strnlen>
  100da0:	8b 54 24 38          	mov    0x38(%esp),%edx
  100da4:	29 c2                	sub    %eax,%edx
  100da6:	89 54 24 30          	mov    %edx,0x30(%esp)
  100daa:	85 d2                	test   %edx,%edx
  100dac:	7e ce                	jle    100d7c <vprintfmt+0x1fd>
					putch(padc, putdat);
  100dae:	0f be 44 24 28       	movsbl 0x28(%esp),%eax
  100db3:	89 74 24 38          	mov    %esi,0x38(%esp)
  100db7:	89 5c 24 3c          	mov    %ebx,0x3c(%esp)
  100dbb:	89 d3                	mov    %edx,%ebx
  100dbd:	89 c6                	mov    %eax,%esi
  100dbf:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100dc3:	89 34 24             	mov    %esi,(%esp)
  100dc6:	ff d5                	call   *%ebp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  100dc8:	83 eb 01             	sub    $0x1,%ebx
  100dcb:	85 db                	test   %ebx,%ebx
  100dcd:	7f f0                	jg     100dbf <vprintfmt+0x240>
  100dcf:	8b 74 24 38          	mov    0x38(%esp),%esi
  100dd3:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
  100dd7:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%esp)
  100dde:	00 
  100ddf:	eb 9b                	jmp    100d7c <vprintfmt+0x1fd>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  100de1:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%esp)
  100de6:	74 19                	je     100e01 <vprintfmt+0x282>
  100de8:	8d 50 e0             	lea    -0x20(%eax),%edx
  100deb:	83 fa 5e             	cmp    $0x5e,%edx
  100dee:	76 11                	jbe    100e01 <vprintfmt+0x282>
					putch('?', putdat);
  100df0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100df4:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  100dfb:	ff 54 24 28          	call   *0x28(%esp)
  100dff:	eb 0b                	jmp    100e0c <vprintfmt+0x28d>
				else
					putch(ch, putdat);
  100e01:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100e05:	89 04 24             	mov    %eax,(%esp)
  100e08:	ff 54 24 28          	call   *0x28(%esp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  100e0c:	83 ed 01             	sub    $0x1,%ebp
  100e0f:	0f be 03             	movsbl (%ebx),%eax
  100e12:	85 c0                	test   %eax,%eax
  100e14:	74 05                	je     100e1b <vprintfmt+0x29c>
  100e16:	83 c3 01             	add    $0x1,%ebx
  100e19:	eb 31                	jmp    100e4c <vprintfmt+0x2cd>
  100e1b:	89 6c 24 30          	mov    %ebp,0x30(%esp)
  100e1f:	8b 6c 24 28          	mov    0x28(%esp),%ebp
  100e23:	8b 5c 24 38          	mov    0x38(%esp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  100e27:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
  100e2c:	7f 35                	jg     100e63 <vprintfmt+0x2e4>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100e2e:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  100e32:	e9 6e fd ff ff       	jmp    100ba5 <vprintfmt+0x26>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  100e37:	8b 54 24 34          	mov    0x34(%esp),%edx
  100e3b:	83 c2 01             	add    $0x1,%edx
  100e3e:	89 6c 24 28          	mov    %ebp,0x28(%esp)
  100e42:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  100e46:	89 5c 24 38          	mov    %ebx,0x38(%esp)
  100e4a:	89 d3                	mov    %edx,%ebx
  100e4c:	85 f6                	test   %esi,%esi
  100e4e:	78 91                	js     100de1 <vprintfmt+0x262>
  100e50:	83 ee 01             	sub    $0x1,%esi
  100e53:	79 8c                	jns    100de1 <vprintfmt+0x262>
  100e55:	89 6c 24 30          	mov    %ebp,0x30(%esp)
  100e59:	8b 6c 24 28          	mov    0x28(%esp),%ebp
  100e5d:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  100e61:	eb c4                	jmp    100e27 <vprintfmt+0x2a8>
  100e63:	89 de                	mov    %ebx,%esi
  100e65:	8b 5c 24 30          	mov    0x30(%esp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  100e69:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100e6d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  100e74:	ff d5                	call   *%ebp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  100e76:	83 eb 01             	sub    $0x1,%ebx
  100e79:	85 db                	test   %ebx,%ebx
  100e7b:	7f ec                	jg     100e69 <vprintfmt+0x2ea>
  100e7d:	89 f3                	mov    %esi,%ebx
  100e7f:	e9 21 fd ff ff       	jmp    100ba5 <vprintfmt+0x26>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  100e84:	83 f9 01             	cmp    $0x1,%ecx
  100e87:	7e 12                	jle    100e9b <vprintfmt+0x31c>
		return va_arg(*ap, long long);
  100e89:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100e8d:	8d 50 08             	lea    0x8(%eax),%edx
  100e90:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100e94:	8b 18                	mov    (%eax),%ebx
  100e96:	8b 70 04             	mov    0x4(%eax),%esi
  100e99:	eb 2a                	jmp    100ec5 <vprintfmt+0x346>
	else if (lflag)
  100e9b:	85 c9                	test   %ecx,%ecx
  100e9d:	74 14                	je     100eb3 <vprintfmt+0x334>
		return va_arg(*ap, long);
  100e9f:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100ea3:	8d 50 04             	lea    0x4(%eax),%edx
  100ea6:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100eaa:	8b 18                	mov    (%eax),%ebx
  100eac:	89 de                	mov    %ebx,%esi
  100eae:	c1 fe 1f             	sar    $0x1f,%esi
  100eb1:	eb 12                	jmp    100ec5 <vprintfmt+0x346>
	else
		return va_arg(*ap, int);
  100eb3:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100eb7:	8d 50 04             	lea    0x4(%eax),%edx
  100eba:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100ebe:	8b 18                	mov    (%eax),%ebx
  100ec0:	89 de                	mov    %ebx,%esi
  100ec2:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  100ec5:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  100eca:	85 f6                	test   %esi,%esi
  100ecc:	0f 89 ab 00 00 00    	jns    100f7d <vprintfmt+0x3fe>
				putch('-', putdat);
  100ed2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100ed6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  100edd:	ff d5                	call   *%ebp
				num = -(long long) num;
  100edf:	f7 db                	neg    %ebx
  100ee1:	83 d6 00             	adc    $0x0,%esi
  100ee4:	f7 de                	neg    %esi
			}
			base = 10;
  100ee6:	b8 0a 00 00 00       	mov    $0xa,%eax
  100eeb:	e9 8d 00 00 00       	jmp    100f7d <vprintfmt+0x3fe>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  100ef0:	89 ca                	mov    %ecx,%edx
  100ef2:	8d 44 24 6c          	lea    0x6c(%esp),%eax
  100ef6:	e8 09 fc ff ff       	call   100b04 <getuint>
  100efb:	89 c3                	mov    %eax,%ebx
  100efd:	89 d6                	mov    %edx,%esi
			base = 10;
  100eff:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  100f04:	eb 77                	jmp    100f7d <vprintfmt+0x3fe>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  100f06:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100f0a:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  100f11:	ff d5                	call   *%ebp
			putch('X', putdat);
  100f13:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100f17:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  100f1e:	ff d5                	call   *%ebp
			putch('X', putdat);
  100f20:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100f24:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  100f2b:	ff d5                	call   *%ebp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100f2d:	8b 5c 24 24          	mov    0x24(%esp),%ebx
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
			putch('X', putdat);
			putch('X', putdat);
			break;
  100f31:	e9 6f fc ff ff       	jmp    100ba5 <vprintfmt+0x26>

		// pointer
		case 'p':
			putch('0', putdat);
  100f36:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100f3a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  100f41:	ff d5                	call   *%ebp
			putch('x', putdat);
  100f43:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100f47:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  100f4e:	ff d5                	call   *%ebp
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  100f50:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100f54:	8d 50 04             	lea    0x4(%eax),%edx
  100f57:	89 54 24 6c          	mov    %edx,0x6c(%esp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  100f5b:	8b 18                	mov    (%eax),%ebx
  100f5d:	be 00 00 00 00       	mov    $0x0,%esi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  100f62:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  100f67:	eb 14                	jmp    100f7d <vprintfmt+0x3fe>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  100f69:	89 ca                	mov    %ecx,%edx
  100f6b:	8d 44 24 6c          	lea    0x6c(%esp),%eax
  100f6f:	e8 90 fb ff ff       	call   100b04 <getuint>
  100f74:	89 c3                	mov    %eax,%ebx
  100f76:	89 d6                	mov    %edx,%esi
			base = 16;
  100f78:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  100f7d:	0f be 54 24 28       	movsbl 0x28(%esp),%edx
  100f82:	89 54 24 10          	mov    %edx,0x10(%esp)
  100f86:	8b 54 24 30          	mov    0x30(%esp),%edx
  100f8a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  100f8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100f92:	89 1c 24             	mov    %ebx,(%esp)
  100f95:	89 74 24 04          	mov    %esi,0x4(%esp)
  100f99:	89 fa                	mov    %edi,%edx
  100f9b:	89 e8                	mov    %ebp,%eax
  100f9d:	e8 6e fa ff ff       	call   100a10 <printnum>
			break;
  100fa2:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  100fa6:	e9 fa fb ff ff       	jmp    100ba5 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  100fab:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100faf:	89 14 24             	mov    %edx,(%esp)
  100fb2:	ff d5                	call   *%ebp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100fb4:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  100fb8:	e9 e8 fb ff ff       	jmp    100ba5 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  100fbd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100fc1:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  100fc8:	ff d5                	call   *%ebp
			for (fmt--; fmt[-1] != '%'; fmt--)
  100fca:	eb 02                	jmp    100fce <vprintfmt+0x44f>
  100fcc:	89 c3                	mov    %eax,%ebx
  100fce:	8d 43 ff             	lea    -0x1(%ebx),%eax
  100fd1:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  100fd5:	75 f5                	jne    100fcc <vprintfmt+0x44d>
  100fd7:	e9 c9 fb ff ff       	jmp    100ba5 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  100fdc:	83 c4 4c             	add    $0x4c,%esp
  100fdf:	5b                   	pop    %ebx
  100fe0:	5e                   	pop    %esi
  100fe1:	5f                   	pop    %edi
  100fe2:	5d                   	pop    %ebp
  100fe3:	c3                   	ret    

00100fe4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  100fe4:	83 ec 2c             	sub    $0x2c,%esp
  100fe7:	8b 44 24 30          	mov    0x30(%esp),%eax
  100feb:	8b 54 24 34          	mov    0x34(%esp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  100fef:	89 44 24 14          	mov    %eax,0x14(%esp)
  100ff3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  100ff7:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  100ffb:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  101002:	00 

	if (buf == NULL || n < 1)
  101003:	85 c0                	test   %eax,%eax
  101005:	74 35                	je     10103c <vsnprintf+0x58>
  101007:	85 d2                	test   %edx,%edx
  101009:	7e 31                	jle    10103c <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  10100b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  10100f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  101013:	8b 44 24 38          	mov    0x38(%esp),%eax
  101017:	89 44 24 08          	mov    %eax,0x8(%esp)
  10101b:	8d 44 24 14          	lea    0x14(%esp),%eax
  10101f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101023:	c7 04 24 38 0b 10 00 	movl   $0x100b38,(%esp)
  10102a:	e8 50 fb ff ff       	call   100b7f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  10102f:	8b 44 24 14          	mov    0x14(%esp),%eax
  101033:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  101036:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  10103a:	eb 05                	jmp    101041 <vsnprintf+0x5d>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  10103c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  101041:	83 c4 2c             	add    $0x2c,%esp
  101044:	c3                   	ret    

00101045 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  101045:	83 ec 1c             	sub    $0x1c,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  101048:	8d 44 24 2c          	lea    0x2c(%esp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  10104c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  101050:	8b 44 24 28          	mov    0x28(%esp),%eax
  101054:	89 44 24 08          	mov    %eax,0x8(%esp)
  101058:	8b 44 24 24          	mov    0x24(%esp),%eax
  10105c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101060:	8b 44 24 20          	mov    0x20(%esp),%eax
  101064:	89 04 24             	mov    %eax,(%esp)
  101067:	e8 78 ff ff ff       	call   100fe4 <vsnprintf>
	va_end(ap);

	return rc;
}
  10106c:	83 c4 1c             	add    $0x1c,%esp
  10106f:	c3                   	ret    

00101070 <readline>:

#define BUFLEN 1024
static char buf[BUFLEN];

char *readline(const char *prompt)
{
  101070:	56                   	push   %esi
  101071:	53                   	push   %ebx
  101072:	83 ec 14             	sub    $0x14,%esp
  101075:	8b 44 24 20          	mov    0x20(%esp),%eax
	int i, c, echoing;

	if (prompt != NULL)
  101079:	85 c0                	test   %eax,%eax
  10107b:	74 10                	je     10108d <readline+0x1d>
		cprintf("%s", prompt);
  10107d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101081:	c7 04 24 1d 1f 10 00 	movl   $0x101f1d,(%esp)
  101088:	e8 c9 f6 ff ff       	call   100756 <cprintf>

#define BUFLEN 1024
static char buf[BUFLEN];

char *readline(const char *prompt)
{
  10108d:	be 00 00 00 00       	mov    $0x0,%esi
	if (prompt != NULL)
		cprintf("%s", prompt);

	i = 0;
	while (1) {
		c = getc();
  101092:	e8 d4 f1 ff ff       	call   10026b <getc>
  101097:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  101099:	85 c0                	test   %eax,%eax
  10109b:	79 17                	jns    1010b4 <readline+0x44>
			cprintf("read error: %e\n", c);
  10109d:	89 44 24 04          	mov    %eax,0x4(%esp)
  1010a1:	c7 04 24 44 21 10 00 	movl   $0x102144,(%esp)
  1010a8:	e8 a9 f6 ff ff       	call   100756 <cprintf>
			return NULL;
  1010ad:	b8 00 00 00 00       	mov    $0x0,%eax
  1010b2:	eb 64                	jmp    101118 <readline+0xa8>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  1010b4:	83 f8 08             	cmp    $0x8,%eax
  1010b7:	74 05                	je     1010be <readline+0x4e>
  1010b9:	83 f8 7f             	cmp    $0x7f,%eax
  1010bc:	75 15                	jne    1010d3 <readline+0x63>
  1010be:	85 f6                	test   %esi,%esi
  1010c0:	7e 11                	jle    1010d3 <readline+0x63>
			putch('\b');
  1010c2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010c9:	e8 9b f2 ff ff       	call   100369 <putch>
			i--;
  1010ce:	83 ee 01             	sub    $0x1,%esi
  1010d1:	eb bf                	jmp    101092 <readline+0x22>
		} else if (c >= ' ' && i < BUFLEN-1) {
  1010d3:	83 fb 1f             	cmp    $0x1f,%ebx
  1010d6:	7e 1e                	jle    1010f6 <readline+0x86>
  1010d8:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  1010de:	7f 16                	jg     1010f6 <readline+0x86>
			putch(c);
  1010e0:	0f b6 c3             	movzbl %bl,%eax
  1010e3:	89 04 24             	mov    %eax,(%esp)
  1010e6:	e8 7e f2 ff ff       	call   100369 <putch>
			buf[i++] = c;
  1010eb:	88 9e 40 b5 10 00    	mov    %bl,0x10b540(%esi)
  1010f1:	83 c6 01             	add    $0x1,%esi
  1010f4:	eb 9c                	jmp    101092 <readline+0x22>
		} else if (c == '\n' || c == '\r') {
  1010f6:	83 fb 0a             	cmp    $0xa,%ebx
  1010f9:	74 05                	je     101100 <readline+0x90>
  1010fb:	83 fb 0d             	cmp    $0xd,%ebx
  1010fe:	75 92                	jne    101092 <readline+0x22>
			putch('\n');
  101100:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  101107:	e8 5d f2 ff ff       	call   100369 <putch>
			buf[i] = 0;
  10110c:	c6 86 40 b5 10 00 00 	movb   $0x0,0x10b540(%esi)
			return buf;
  101113:	b8 40 b5 10 00       	mov    $0x10b540,%eax
		}
	}
}
  101118:	83 c4 14             	add    $0x14,%esp
  10111b:	5b                   	pop    %ebx
  10111c:	5e                   	pop    %esi
  10111d:	c3                   	ret    
	...

00101120 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  101120:	8b 54 24 04          	mov    0x4(%esp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  101124:	b8 00 00 00 00       	mov    $0x0,%eax
  101129:	80 3a 00             	cmpb   $0x0,(%edx)
  10112c:	74 09                	je     101137 <strlen+0x17>
		n++;
  10112e:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  101131:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  101135:	75 f7                	jne    10112e <strlen+0xe>
		n++;
	return n;
}
  101137:	f3 c3                	repz ret 

00101139 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  101139:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  10113d:	8b 54 24 08          	mov    0x8(%esp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  101141:	b8 00 00 00 00       	mov    $0x0,%eax
  101146:	85 d2                	test   %edx,%edx
  101148:	74 12                	je     10115c <strnlen+0x23>
  10114a:	80 39 00             	cmpb   $0x0,(%ecx)
  10114d:	74 0d                	je     10115c <strnlen+0x23>
		n++;
  10114f:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  101152:	39 d0                	cmp    %edx,%eax
  101154:	74 06                	je     10115c <strnlen+0x23>
  101156:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  10115a:	75 f3                	jne    10114f <strnlen+0x16>
		n++;
	return n;
}
  10115c:	f3 c3                	repz ret 

0010115e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  10115e:	53                   	push   %ebx
  10115f:	8b 44 24 08          	mov    0x8(%esp),%eax
  101163:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  101167:	ba 00 00 00 00       	mov    $0x0,%edx
  10116c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  101170:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  101173:	83 c2 01             	add    $0x1,%edx
  101176:	84 c9                	test   %cl,%cl
  101178:	75 f2                	jne    10116c <strcpy+0xe>
		/* do nothing */;
	return ret;
}
  10117a:	5b                   	pop    %ebx
  10117b:	c3                   	ret    

0010117c <strcat>:

char *
strcat(char *dst, const char *src)
{
  10117c:	53                   	push   %ebx
  10117d:	83 ec 08             	sub    $0x8,%esp
  101180:	8b 5c 24 10          	mov    0x10(%esp),%ebx
	int len = strlen(dst);
  101184:	89 1c 24             	mov    %ebx,(%esp)
  101187:	e8 94 ff ff ff       	call   101120 <strlen>
	strcpy(dst + len, src);
  10118c:	8b 54 24 14          	mov    0x14(%esp),%edx
  101190:	89 54 24 04          	mov    %edx,0x4(%esp)
  101194:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  101197:	89 04 24             	mov    %eax,(%esp)
  10119a:	e8 bf ff ff ff       	call   10115e <strcpy>
	return dst;
}
  10119f:	89 d8                	mov    %ebx,%eax
  1011a1:	83 c4 08             	add    $0x8,%esp
  1011a4:	5b                   	pop    %ebx
  1011a5:	c3                   	ret    

001011a6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  1011a6:	56                   	push   %esi
  1011a7:	53                   	push   %ebx
  1011a8:	8b 44 24 0c          	mov    0xc(%esp),%eax
  1011ac:	8b 54 24 10          	mov    0x10(%esp),%edx
  1011b0:	8b 74 24 14          	mov    0x14(%esp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  1011b4:	85 f6                	test   %esi,%esi
  1011b6:	74 18                	je     1011d0 <strncpy+0x2a>
  1011b8:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  1011bd:	0f b6 1a             	movzbl (%edx),%ebx
  1011c0:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  1011c3:	80 3a 01             	cmpb   $0x1,(%edx)
  1011c6:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  1011c9:	83 c1 01             	add    $0x1,%ecx
  1011cc:	39 ce                	cmp    %ecx,%esi
  1011ce:	77 ed                	ja     1011bd <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  1011d0:	5b                   	pop    %ebx
  1011d1:	5e                   	pop    %esi
  1011d2:	c3                   	ret    

001011d3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  1011d3:	57                   	push   %edi
  1011d4:	56                   	push   %esi
  1011d5:	53                   	push   %ebx
  1011d6:	8b 7c 24 10          	mov    0x10(%esp),%edi
  1011da:	8b 5c 24 14          	mov    0x14(%esp),%ebx
  1011de:	8b 74 24 18          	mov    0x18(%esp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  1011e2:	89 f8                	mov    %edi,%eax
  1011e4:	85 f6                	test   %esi,%esi
  1011e6:	74 2c                	je     101214 <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
  1011e8:	83 fe 01             	cmp    $0x1,%esi
  1011eb:	74 24                	je     101211 <strlcpy+0x3e>
  1011ed:	0f b6 0b             	movzbl (%ebx),%ecx
  1011f0:	84 c9                	test   %cl,%cl
  1011f2:	74 1d                	je     101211 <strlcpy+0x3e>
  1011f4:	ba 00 00 00 00       	mov    $0x0,%edx
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  1011f9:	83 ee 02             	sub    $0x2,%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  1011fc:	88 08                	mov    %cl,(%eax)
  1011fe:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  101201:	39 f2                	cmp    %esi,%edx
  101203:	74 0c                	je     101211 <strlcpy+0x3e>
  101205:	0f b6 4c 13 01       	movzbl 0x1(%ebx,%edx,1),%ecx
  10120a:	83 c2 01             	add    $0x1,%edx
  10120d:	84 c9                	test   %cl,%cl
  10120f:	75 eb                	jne    1011fc <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  101211:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  101214:	29 f8                	sub    %edi,%eax
}
  101216:	5b                   	pop    %ebx
  101217:	5e                   	pop    %esi
  101218:	5f                   	pop    %edi
  101219:	c3                   	ret    

0010121a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  10121a:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  10121e:	8b 54 24 08          	mov    0x8(%esp),%edx
	while (*p && *p == *q)
  101222:	0f b6 01             	movzbl (%ecx),%eax
  101225:	84 c0                	test   %al,%al
  101227:	74 15                	je     10123e <strcmp+0x24>
  101229:	3a 02                	cmp    (%edx),%al
  10122b:	75 11                	jne    10123e <strcmp+0x24>
		p++, q++;
  10122d:	83 c1 01             	add    $0x1,%ecx
  101230:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  101233:	0f b6 01             	movzbl (%ecx),%eax
  101236:	84 c0                	test   %al,%al
  101238:	74 04                	je     10123e <strcmp+0x24>
  10123a:	3a 02                	cmp    (%edx),%al
  10123c:	74 ef                	je     10122d <strcmp+0x13>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  10123e:	0f b6 c0             	movzbl %al,%eax
  101241:	0f b6 12             	movzbl (%edx),%edx
  101244:	29 d0                	sub    %edx,%eax
}
  101246:	c3                   	ret    

00101247 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  101247:	53                   	push   %ebx
  101248:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  10124c:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  101250:	8b 54 24 10          	mov    0x10(%esp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  101254:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  101259:	85 d2                	test   %edx,%edx
  10125b:	74 28                	je     101285 <strncmp+0x3e>
  10125d:	0f b6 01             	movzbl (%ecx),%eax
  101260:	84 c0                	test   %al,%al
  101262:	74 23                	je     101287 <strncmp+0x40>
  101264:	3a 03                	cmp    (%ebx),%al
  101266:	75 1f                	jne    101287 <strncmp+0x40>
  101268:	83 ea 01             	sub    $0x1,%edx
  10126b:	74 13                	je     101280 <strncmp+0x39>
		n--, p++, q++;
  10126d:	83 c1 01             	add    $0x1,%ecx
  101270:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  101273:	0f b6 01             	movzbl (%ecx),%eax
  101276:	84 c0                	test   %al,%al
  101278:	74 0d                	je     101287 <strncmp+0x40>
  10127a:	3a 03                	cmp    (%ebx),%al
  10127c:	74 ea                	je     101268 <strncmp+0x21>
  10127e:	eb 07                	jmp    101287 <strncmp+0x40>
		n--, p++, q++;
	if (n == 0)
		return 0;
  101280:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  101285:	5b                   	pop    %ebx
  101286:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  101287:	0f b6 01             	movzbl (%ecx),%eax
  10128a:	0f b6 13             	movzbl (%ebx),%edx
  10128d:	29 d0                	sub    %edx,%eax
  10128f:	eb f4                	jmp    101285 <strncmp+0x3e>

00101291 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  101291:	8b 44 24 04          	mov    0x4(%esp),%eax
  101295:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
	for (; *s; s++)
  10129a:	0f b6 10             	movzbl (%eax),%edx
  10129d:	84 d2                	test   %dl,%dl
  10129f:	74 21                	je     1012c2 <strchr+0x31>
		if (*s == c)
  1012a1:	38 ca                	cmp    %cl,%dl
  1012a3:	75 0d                	jne    1012b2 <strchr+0x21>
  1012a5:	f3 c3                	repz ret 
  1012a7:	38 ca                	cmp    %cl,%dl
  1012a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1012b0:	74 15                	je     1012c7 <strchr+0x36>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  1012b2:	83 c0 01             	add    $0x1,%eax
  1012b5:	0f b6 10             	movzbl (%eax),%edx
  1012b8:	84 d2                	test   %dl,%dl
  1012ba:	75 eb                	jne    1012a7 <strchr+0x16>
		if (*s == c)
			return (char *) s;
	return 0;
  1012bc:	b8 00 00 00 00       	mov    $0x0,%eax
  1012c1:	c3                   	ret    
  1012c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1012c7:	f3 c3                	repz ret 

001012c9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  1012c9:	8b 44 24 04          	mov    0x4(%esp),%eax
  1012cd:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
	for (; *s; s++)
  1012d2:	0f b6 10             	movzbl (%eax),%edx
  1012d5:	84 d2                	test   %dl,%dl
  1012d7:	74 14                	je     1012ed <strfind+0x24>
		if (*s == c)
  1012d9:	38 ca                	cmp    %cl,%dl
  1012db:	75 06                	jne    1012e3 <strfind+0x1a>
  1012dd:	f3 c3                	repz ret 
  1012df:	38 ca                	cmp    %cl,%dl
  1012e1:	74 0a                	je     1012ed <strfind+0x24>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  1012e3:	83 c0 01             	add    $0x1,%eax
  1012e6:	0f b6 10             	movzbl (%eax),%edx
  1012e9:	84 d2                	test   %dl,%dl
  1012eb:	75 f2                	jne    1012df <strfind+0x16>
		if (*s == c)
			break;
	return (char *) s;
}
  1012ed:	f3 c3                	repz ret 

001012ef <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  1012ef:	83 ec 0c             	sub    $0xc,%esp
  1012f2:	89 1c 24             	mov    %ebx,(%esp)
  1012f5:	89 74 24 04          	mov    %esi,0x4(%esp)
  1012f9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  1012fd:	8b 7c 24 10          	mov    0x10(%esp),%edi
  101301:	8b 44 24 14          	mov    0x14(%esp),%eax
  101305:	8b 4c 24 18          	mov    0x18(%esp),%ecx
	char *p;

	if (n == 0)
  101309:	85 c9                	test   %ecx,%ecx
  10130b:	74 30                	je     10133d <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  10130d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  101313:	75 25                	jne    10133a <memset+0x4b>
  101315:	f6 c1 03             	test   $0x3,%cl
  101318:	75 20                	jne    10133a <memset+0x4b>
		c &= 0xFF;
  10131a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  10131d:	89 d3                	mov    %edx,%ebx
  10131f:	c1 e3 08             	shl    $0x8,%ebx
  101322:	89 d6                	mov    %edx,%esi
  101324:	c1 e6 18             	shl    $0x18,%esi
  101327:	89 d0                	mov    %edx,%eax
  101329:	c1 e0 10             	shl    $0x10,%eax
  10132c:	09 f0                	or     %esi,%eax
  10132e:	09 d0                	or     %edx,%eax
  101330:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  101332:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  101335:	fc                   	cld    
  101336:	f3 ab                	rep stos %eax,%es:(%edi)
  101338:	eb 03                	jmp    10133d <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  10133a:	fc                   	cld    
  10133b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  10133d:	89 f8                	mov    %edi,%eax
  10133f:	8b 1c 24             	mov    (%esp),%ebx
  101342:	8b 74 24 04          	mov    0x4(%esp),%esi
  101346:	8b 7c 24 08          	mov    0x8(%esp),%edi
  10134a:	83 c4 0c             	add    $0xc,%esp
  10134d:	c3                   	ret    

0010134e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  10134e:	83 ec 08             	sub    $0x8,%esp
  101351:	89 34 24             	mov    %esi,(%esp)
  101354:	89 7c 24 04          	mov    %edi,0x4(%esp)
  101358:	8b 44 24 0c          	mov    0xc(%esp),%eax
  10135c:	8b 74 24 10          	mov    0x10(%esp),%esi
  101360:	8b 4c 24 14          	mov    0x14(%esp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  101364:	39 c6                	cmp    %eax,%esi
  101366:	73 36                	jae    10139e <memmove+0x50>
  101368:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  10136b:	39 d0                	cmp    %edx,%eax
  10136d:	73 2f                	jae    10139e <memmove+0x50>
		s += n;
		d += n;
  10136f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  101372:	f6 c2 03             	test   $0x3,%dl
  101375:	75 1b                	jne    101392 <memmove+0x44>
  101377:	f7 c7 03 00 00 00    	test   $0x3,%edi
  10137d:	75 13                	jne    101392 <memmove+0x44>
  10137f:	f6 c1 03             	test   $0x3,%cl
  101382:	75 0e                	jne    101392 <memmove+0x44>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  101384:	83 ef 04             	sub    $0x4,%edi
  101387:	8d 72 fc             	lea    -0x4(%edx),%esi
  10138a:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  10138d:	fd                   	std    
  10138e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  101390:	eb 09                	jmp    10139b <memmove+0x4d>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  101392:	83 ef 01             	sub    $0x1,%edi
  101395:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  101398:	fd                   	std    
  101399:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  10139b:	fc                   	cld    
  10139c:	eb 20                	jmp    1013be <memmove+0x70>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  10139e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  1013a4:	75 13                	jne    1013b9 <memmove+0x6b>
  1013a6:	a8 03                	test   $0x3,%al
  1013a8:	75 0f                	jne    1013b9 <memmove+0x6b>
  1013aa:	f6 c1 03             	test   $0x3,%cl
  1013ad:	75 0a                	jne    1013b9 <memmove+0x6b>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  1013af:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  1013b2:	89 c7                	mov    %eax,%edi
  1013b4:	fc                   	cld    
  1013b5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1013b7:	eb 05                	jmp    1013be <memmove+0x70>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  1013b9:	89 c7                	mov    %eax,%edi
  1013bb:	fc                   	cld    
  1013bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  1013be:	8b 34 24             	mov    (%esp),%esi
  1013c1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  1013c5:	83 c4 08             	add    $0x8,%esp
  1013c8:	c3                   	ret    

001013c9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  1013c9:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  1013cc:	8b 44 24 18          	mov    0x18(%esp),%eax
  1013d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1013d4:	8b 44 24 14          	mov    0x14(%esp),%eax
  1013d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1013dc:	8b 44 24 10          	mov    0x10(%esp),%eax
  1013e0:	89 04 24             	mov    %eax,(%esp)
  1013e3:	e8 66 ff ff ff       	call   10134e <memmove>
}
  1013e8:	83 c4 0c             	add    $0xc,%esp
  1013eb:	c3                   	ret    

001013ec <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  1013ec:	57                   	push   %edi
  1013ed:	56                   	push   %esi
  1013ee:	53                   	push   %ebx
  1013ef:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  1013f3:	8b 74 24 14          	mov    0x14(%esp),%esi
  1013f7:	8b 7c 24 18          	mov    0x18(%esp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  1013fb:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  101400:	85 ff                	test   %edi,%edi
  101402:	74 38                	je     10143c <memcmp+0x50>
		if (*s1 != *s2)
  101404:	0f b6 03             	movzbl (%ebx),%eax
  101407:	0f b6 0e             	movzbl (%esi),%ecx
  10140a:	38 c8                	cmp    %cl,%al
  10140c:	74 1d                	je     10142b <memcmp+0x3f>
  10140e:	eb 11                	jmp    101421 <memcmp+0x35>
  101410:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  101415:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  10141a:	83 c2 01             	add    $0x1,%edx
  10141d:	38 c8                	cmp    %cl,%al
  10141f:	74 12                	je     101433 <memcmp+0x47>
			return (int) *s1 - (int) *s2;
  101421:	0f b6 c0             	movzbl %al,%eax
  101424:	0f b6 c9             	movzbl %cl,%ecx
  101427:	29 c8                	sub    %ecx,%eax
  101429:	eb 11                	jmp    10143c <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  10142b:	83 ef 01             	sub    $0x1,%edi
  10142e:	ba 00 00 00 00       	mov    $0x0,%edx
  101433:	39 fa                	cmp    %edi,%edx
  101435:	75 d9                	jne    101410 <memcmp+0x24>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  101437:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10143c:	5b                   	pop    %ebx
  10143d:	5e                   	pop    %esi
  10143e:	5f                   	pop    %edi
  10143f:	c3                   	ret    

00101440 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  101440:	8b 44 24 04          	mov    0x4(%esp),%eax
	const void *ends = (const char *) s + n;
  101444:	89 c2                	mov    %eax,%edx
  101446:	03 54 24 0c          	add    0xc(%esp),%edx
	for (; s < ends; s++)
  10144a:	39 d0                	cmp    %edx,%eax
  10144c:	73 16                	jae    101464 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  10144e:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
  101453:	38 08                	cmp    %cl,(%eax)
  101455:	75 06                	jne    10145d <memfind+0x1d>
  101457:	f3 c3                	repz ret 
  101459:	38 08                	cmp    %cl,(%eax)
  10145b:	74 07                	je     101464 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  10145d:	83 c0 01             	add    $0x1,%eax
  101460:	39 c2                	cmp    %eax,%edx
  101462:	77 f5                	ja     101459 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  101464:	f3 c3                	repz ret 

00101466 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  101466:	55                   	push   %ebp
  101467:	57                   	push   %edi
  101468:	56                   	push   %esi
  101469:	53                   	push   %ebx
  10146a:	8b 54 24 14          	mov    0x14(%esp),%edx
  10146e:	8b 74 24 18          	mov    0x18(%esp),%esi
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  101472:	0f b6 02             	movzbl (%edx),%eax
  101475:	3c 20                	cmp    $0x20,%al
  101477:	74 04                	je     10147d <strtol+0x17>
  101479:	3c 09                	cmp    $0x9,%al
  10147b:	75 0e                	jne    10148b <strtol+0x25>
		s++;
  10147d:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  101480:	0f b6 02             	movzbl (%edx),%eax
  101483:	3c 20                	cmp    $0x20,%al
  101485:	74 f6                	je     10147d <strtol+0x17>
  101487:	3c 09                	cmp    $0x9,%al
  101489:	74 f2                	je     10147d <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  10148b:	3c 2b                	cmp    $0x2b,%al
  10148d:	75 0a                	jne    101499 <strtol+0x33>
		s++;
  10148f:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  101492:	bf 00 00 00 00       	mov    $0x0,%edi
  101497:	eb 10                	jmp    1014a9 <strtol+0x43>
  101499:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  10149e:	3c 2d                	cmp    $0x2d,%al
  1014a0:	75 07                	jne    1014a9 <strtol+0x43>
		s++, neg = 1;
  1014a2:	83 c2 01             	add    $0x1,%edx
  1014a5:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  1014a9:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  1014ae:	0f 94 c0             	sete   %al
  1014b1:	74 07                	je     1014ba <strtol+0x54>
  1014b3:	83 7c 24 1c 10       	cmpl   $0x10,0x1c(%esp)
  1014b8:	75 18                	jne    1014d2 <strtol+0x6c>
  1014ba:	80 3a 30             	cmpb   $0x30,(%edx)
  1014bd:	75 13                	jne    1014d2 <strtol+0x6c>
  1014bf:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  1014c3:	75 0d                	jne    1014d2 <strtol+0x6c>
		s += 2, base = 16;
  1014c5:	83 c2 02             	add    $0x2,%edx
  1014c8:	c7 44 24 1c 10 00 00 	movl   $0x10,0x1c(%esp)
  1014cf:	00 
  1014d0:	eb 1c                	jmp    1014ee <strtol+0x88>
	else if (base == 0 && s[0] == '0')
  1014d2:	84 c0                	test   %al,%al
  1014d4:	74 18                	je     1014ee <strtol+0x88>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  1014d6:	c7 44 24 1c 0a 00 00 	movl   $0xa,0x1c(%esp)
  1014dd:	00 
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  1014de:	80 3a 30             	cmpb   $0x30,(%edx)
  1014e1:	75 0b                	jne    1014ee <strtol+0x88>
		s++, base = 8;
  1014e3:	83 c2 01             	add    $0x1,%edx
  1014e6:	c7 44 24 1c 08 00 00 	movl   $0x8,0x1c(%esp)
  1014ed:	00 
	else if (base == 0)
		base = 10;
  1014ee:	b8 00 00 00 00       	mov    $0x0,%eax

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  1014f3:	0f b6 0a             	movzbl (%edx),%ecx
  1014f6:	8d 69 d0             	lea    -0x30(%ecx),%ebp
  1014f9:	89 eb                	mov    %ebp,%ebx
  1014fb:	80 fb 09             	cmp    $0x9,%bl
  1014fe:	77 08                	ja     101508 <strtol+0xa2>
			dig = *s - '0';
  101500:	0f be c9             	movsbl %cl,%ecx
  101503:	83 e9 30             	sub    $0x30,%ecx
  101506:	eb 22                	jmp    10152a <strtol+0xc4>
		else if (*s >= 'a' && *s <= 'z')
  101508:	8d 69 9f             	lea    -0x61(%ecx),%ebp
  10150b:	89 eb                	mov    %ebp,%ebx
  10150d:	80 fb 19             	cmp    $0x19,%bl
  101510:	77 08                	ja     10151a <strtol+0xb4>
			dig = *s - 'a' + 10;
  101512:	0f be c9             	movsbl %cl,%ecx
  101515:	83 e9 57             	sub    $0x57,%ecx
  101518:	eb 10                	jmp    10152a <strtol+0xc4>
		else if (*s >= 'A' && *s <= 'Z')
  10151a:	8d 69 bf             	lea    -0x41(%ecx),%ebp
  10151d:	89 eb                	mov    %ebp,%ebx
  10151f:	80 fb 19             	cmp    $0x19,%bl
  101522:	77 19                	ja     10153d <strtol+0xd7>
			dig = *s - 'A' + 10;
  101524:	0f be c9             	movsbl %cl,%ecx
  101527:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  10152a:	3b 4c 24 1c          	cmp    0x1c(%esp),%ecx
  10152e:	7d 11                	jge    101541 <strtol+0xdb>
			break;
		s++, val = (val * base) + dig;
  101530:	83 c2 01             	add    $0x1,%edx
  101533:	0f af 44 24 1c       	imul   0x1c(%esp),%eax
  101538:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  10153b:	eb b6                	jmp    1014f3 <strtol+0x8d>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  10153d:	89 c1                	mov    %eax,%ecx
  10153f:	eb 02                	jmp    101543 <strtol+0xdd>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  101541:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  101543:	85 f6                	test   %esi,%esi
  101545:	74 02                	je     101549 <strtol+0xe3>
		*endptr = (char *) s;
  101547:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  101549:	89 ca                	mov    %ecx,%edx
  10154b:	f7 da                	neg    %edx
  10154d:	85 ff                	test   %edi,%edi
  10154f:	0f 45 c2             	cmovne %edx,%eax
}
  101552:	5b                   	pop    %ebx
  101553:	5e                   	pop    %esi
  101554:	5f                   	pop    %edi
  101555:	5d                   	pop    %ebp
  101556:	c3                   	ret    
	...

00101560 <__udivdi3>:
  101560:	55                   	push   %ebp
  101561:	89 e5                	mov    %esp,%ebp
  101563:	57                   	push   %edi
  101564:	56                   	push   %esi
  101565:	8d 64 24 e0          	lea    -0x20(%esp),%esp
  101569:	8b 45 14             	mov    0x14(%ebp),%eax
  10156c:	8b 75 08             	mov    0x8(%ebp),%esi
  10156f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  101572:	85 c0                	test   %eax,%eax
  101574:	89 75 e8             	mov    %esi,-0x18(%ebp)
  101577:	8b 7d 0c             	mov    0xc(%ebp),%edi
  10157a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  10157d:	75 39                	jne    1015b8 <__udivdi3+0x58>
  10157f:	39 f9                	cmp    %edi,%ecx
  101581:	77 65                	ja     1015e8 <__udivdi3+0x88>
  101583:	85 c9                	test   %ecx,%ecx
  101585:	75 0b                	jne    101592 <__udivdi3+0x32>
  101587:	b8 01 00 00 00       	mov    $0x1,%eax
  10158c:	31 d2                	xor    %edx,%edx
  10158e:	f7 f1                	div    %ecx
  101590:	89 c1                	mov    %eax,%ecx
  101592:	89 f8                	mov    %edi,%eax
  101594:	31 d2                	xor    %edx,%edx
  101596:	f7 f1                	div    %ecx
  101598:	89 c7                	mov    %eax,%edi
  10159a:	89 f0                	mov    %esi,%eax
  10159c:	f7 f1                	div    %ecx
  10159e:	89 fa                	mov    %edi,%edx
  1015a0:	89 c6                	mov    %eax,%esi
  1015a2:	89 75 f0             	mov    %esi,-0x10(%ebp)
  1015a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1015a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1015ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1015ae:	8d 64 24 20          	lea    0x20(%esp),%esp
  1015b2:	5e                   	pop    %esi
  1015b3:	5f                   	pop    %edi
  1015b4:	5d                   	pop    %ebp
  1015b5:	c3                   	ret    
  1015b6:	66 90                	xchg   %ax,%ax
  1015b8:	31 d2                	xor    %edx,%edx
  1015ba:	31 f6                	xor    %esi,%esi
  1015bc:	39 f8                	cmp    %edi,%eax
  1015be:	77 e2                	ja     1015a2 <__udivdi3+0x42>
  1015c0:	0f bd d0             	bsr    %eax,%edx
  1015c3:	83 f2 1f             	xor    $0x1f,%edx
  1015c6:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1015c9:	75 2d                	jne    1015f8 <__udivdi3+0x98>
  1015cb:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1015ce:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  1015d1:	76 06                	jbe    1015d9 <__udivdi3+0x79>
  1015d3:	39 f8                	cmp    %edi,%eax
  1015d5:	89 f2                	mov    %esi,%edx
  1015d7:	73 c9                	jae    1015a2 <__udivdi3+0x42>
  1015d9:	31 d2                	xor    %edx,%edx
  1015db:	be 01 00 00 00       	mov    $0x1,%esi
  1015e0:	eb c0                	jmp    1015a2 <__udivdi3+0x42>
  1015e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1015e8:	89 f0                	mov    %esi,%eax
  1015ea:	89 fa                	mov    %edi,%edx
  1015ec:	f7 f1                	div    %ecx
  1015ee:	31 d2                	xor    %edx,%edx
  1015f0:	89 c6                	mov    %eax,%esi
  1015f2:	eb ae                	jmp    1015a2 <__udivdi3+0x42>
  1015f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1015f8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  1015fc:	89 c2                	mov    %eax,%edx
  1015fe:	b8 20 00 00 00       	mov    $0x20,%eax
  101603:	2b 45 ec             	sub    -0x14(%ebp),%eax
  101606:	d3 e2                	shl    %cl,%edx
  101608:	89 c1                	mov    %eax,%ecx
  10160a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  10160d:	d3 ee                	shr    %cl,%esi
  10160f:	09 d6                	or     %edx,%esi
  101611:	89 fa                	mov    %edi,%edx
  101613:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  101617:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  10161a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  10161d:	d3 e6                	shl    %cl,%esi
  10161f:	89 c1                	mov    %eax,%ecx
  101621:	89 75 f0             	mov    %esi,-0x10(%ebp)
  101624:	8b 75 e8             	mov    -0x18(%ebp),%esi
  101627:	d3 ea                	shr    %cl,%edx
  101629:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  10162d:	d3 e7                	shl    %cl,%edi
  10162f:	89 c1                	mov    %eax,%ecx
  101631:	d3 ee                	shr    %cl,%esi
  101633:	09 fe                	or     %edi,%esi
  101635:	89 f0                	mov    %esi,%eax
  101637:	f7 75 e4             	divl   -0x1c(%ebp)
  10163a:	89 d7                	mov    %edx,%edi
  10163c:	89 c6                	mov    %eax,%esi
  10163e:	f7 65 f0             	mull   -0x10(%ebp)
  101641:	39 d7                	cmp    %edx,%edi
  101643:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  101646:	72 12                	jb     10165a <__udivdi3+0xfa>
  101648:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  10164c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10164f:	d3 e2                	shl    %cl,%edx
  101651:	39 c2                	cmp    %eax,%edx
  101653:	73 08                	jae    10165d <__udivdi3+0xfd>
  101655:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  101658:	75 03                	jne    10165d <__udivdi3+0xfd>
  10165a:	8d 76 ff             	lea    -0x1(%esi),%esi
  10165d:	31 d2                	xor    %edx,%edx
  10165f:	e9 3e ff ff ff       	jmp    1015a2 <__udivdi3+0x42>
	...

00101670 <__umoddi3>:
  101670:	55                   	push   %ebp
  101671:	89 e5                	mov    %esp,%ebp
  101673:	57                   	push   %edi
  101674:	56                   	push   %esi
  101675:	8d 64 24 e0          	lea    -0x20(%esp),%esp
  101679:	8b 7d 14             	mov    0x14(%ebp),%edi
  10167c:	8b 45 08             	mov    0x8(%ebp),%eax
  10167f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  101682:	8b 75 0c             	mov    0xc(%ebp),%esi
  101685:	85 ff                	test   %edi,%edi
  101687:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10168a:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  10168d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  101690:	89 f2                	mov    %esi,%edx
  101692:	75 14                	jne    1016a8 <__umoddi3+0x38>
  101694:	39 f1                	cmp    %esi,%ecx
  101696:	76 40                	jbe    1016d8 <__umoddi3+0x68>
  101698:	f7 f1                	div    %ecx
  10169a:	89 d0                	mov    %edx,%eax
  10169c:	31 d2                	xor    %edx,%edx
  10169e:	8d 64 24 20          	lea    0x20(%esp),%esp
  1016a2:	5e                   	pop    %esi
  1016a3:	5f                   	pop    %edi
  1016a4:	5d                   	pop    %ebp
  1016a5:	c3                   	ret    
  1016a6:	66 90                	xchg   %ax,%ax
  1016a8:	39 f7                	cmp    %esi,%edi
  1016aa:	77 4c                	ja     1016f8 <__umoddi3+0x88>
  1016ac:	0f bd c7             	bsr    %edi,%eax
  1016af:	83 f0 1f             	xor    $0x1f,%eax
  1016b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1016b5:	75 51                	jne    101708 <__umoddi3+0x98>
  1016b7:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  1016ba:	0f 87 e8 00 00 00    	ja     1017a8 <__umoddi3+0x138>
  1016c0:	89 f2                	mov    %esi,%edx
  1016c2:	8b 75 f0             	mov    -0x10(%ebp),%esi
  1016c5:	29 ce                	sub    %ecx,%esi
  1016c7:	19 fa                	sbb    %edi,%edx
  1016c9:	89 75 f0             	mov    %esi,-0x10(%ebp)
  1016cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1016cf:	8d 64 24 20          	lea    0x20(%esp),%esp
  1016d3:	5e                   	pop    %esi
  1016d4:	5f                   	pop    %edi
  1016d5:	5d                   	pop    %ebp
  1016d6:	c3                   	ret    
  1016d7:	90                   	nop
  1016d8:	85 c9                	test   %ecx,%ecx
  1016da:	75 0b                	jne    1016e7 <__umoddi3+0x77>
  1016dc:	b8 01 00 00 00       	mov    $0x1,%eax
  1016e1:	31 d2                	xor    %edx,%edx
  1016e3:	f7 f1                	div    %ecx
  1016e5:	89 c1                	mov    %eax,%ecx
  1016e7:	89 f0                	mov    %esi,%eax
  1016e9:	31 d2                	xor    %edx,%edx
  1016eb:	f7 f1                	div    %ecx
  1016ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1016f0:	f7 f1                	div    %ecx
  1016f2:	eb a6                	jmp    10169a <__umoddi3+0x2a>
  1016f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1016f8:	89 f2                	mov    %esi,%edx
  1016fa:	8d 64 24 20          	lea    0x20(%esp),%esp
  1016fe:	5e                   	pop    %esi
  1016ff:	5f                   	pop    %edi
  101700:	5d                   	pop    %ebp
  101701:	c3                   	ret    
  101702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101708:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  10170c:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  101713:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101716:	29 45 f0             	sub    %eax,-0x10(%ebp)
  101719:	d3 e7                	shl    %cl,%edi
  10171b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10171e:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  101722:	89 f2                	mov    %esi,%edx
  101724:	d3 e8                	shr    %cl,%eax
  101726:	09 f8                	or     %edi,%eax
  101728:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  10172c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10172f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101732:	d3 e0                	shl    %cl,%eax
  101734:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  101738:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10173b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10173e:	d3 ea                	shr    %cl,%edx
  101740:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  101744:	d3 e6                	shl    %cl,%esi
  101746:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  10174a:	d3 e8                	shr    %cl,%eax
  10174c:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  101750:	09 f0                	or     %esi,%eax
  101752:	8b 75 e8             	mov    -0x18(%ebp),%esi
  101755:	d3 e6                	shl    %cl,%esi
  101757:	f7 75 e4             	divl   -0x1c(%ebp)
  10175a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  10175d:	89 d6                	mov    %edx,%esi
  10175f:	f7 65 f4             	mull   -0xc(%ebp)
  101762:	89 d7                	mov    %edx,%edi
  101764:	89 c2                	mov    %eax,%edx
  101766:	39 fe                	cmp    %edi,%esi
  101768:	89 f9                	mov    %edi,%ecx
  10176a:	72 30                	jb     10179c <__umoddi3+0x12c>
  10176c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10176f:	72 27                	jb     101798 <__umoddi3+0x128>
  101771:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101774:	29 d0                	sub    %edx,%eax
  101776:	19 ce                	sbb    %ecx,%esi
  101778:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  10177c:	89 f2                	mov    %esi,%edx
  10177e:	d3 e8                	shr    %cl,%eax
  101780:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  101784:	d3 e2                	shl    %cl,%edx
  101786:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  10178a:	09 d0                	or     %edx,%eax
  10178c:	89 f2                	mov    %esi,%edx
  10178e:	d3 ea                	shr    %cl,%edx
  101790:	8d 64 24 20          	lea    0x20(%esp),%esp
  101794:	5e                   	pop    %esi
  101795:	5f                   	pop    %edi
  101796:	5d                   	pop    %ebp
  101797:	c3                   	ret    
  101798:	39 fe                	cmp    %edi,%esi
  10179a:	75 d5                	jne    101771 <__umoddi3+0x101>
  10179c:	89 f9                	mov    %edi,%ecx
  10179e:	89 c2                	mov    %eax,%edx
  1017a0:	2b 55 f4             	sub    -0xc(%ebp),%edx
  1017a3:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  1017a6:	eb c9                	jmp    101771 <__umoddi3+0x101>
  1017a8:	39 f7                	cmp    %esi,%edi
  1017aa:	0f 82 10 ff ff ff    	jb     1016c0 <__umoddi3+0x50>
  1017b0:	e9 17 ff ff ff       	jmp    1016cc <__umoddi3+0x5c>
