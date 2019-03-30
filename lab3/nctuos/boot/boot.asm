
boot/boot.out:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
.globl start
start:
	.code16                     # Assemble for 16-bit mode

	# Set up the important data segment registers (DS, ES, SS).
	xorw    %ax,%ax             # Segment number zero
    7c00:	31 c0                	xor    %eax,%eax
	movw    %ax,%ds             # -> Data Segment
    7c02:	8e d8                	mov    %eax,%ds
	movw    %ax,%es             # -> Extra Segment
    7c04:	8e c0                	mov    %eax,%es
	movw    %ax,%ss             # -> Stack Segment
    7c06:	8e d0                	mov    %eax,%ss

	cli                         # Disable interrupts
    7c08:	fa                   	cli    
	cld                         # String operations increment
    7c09:	fc                   	cld    

	# Switch from real to protected mode, using a bootstrap GDT
	# and segment translation that makes virtual addresses
	# identical to their physical addresses, so that the
	# effective memory map does not change during the switch.
	lgdt    gdtdesc
    7c0a:	0f 01 16             	lgdtl  (%esi)
    7c0d:	50                   	push   %eax
    7c0e:	7c 0f                	jl     7c1f <protcseg+0x1>
	movl    %cr0, %eax
    7c10:	20 c0                	and    %al,%al
	orl     $CR0_PE_ON, %eax
    7c12:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
    7c16:	0f 22 c0             	mov    %eax,%cr0

	# Jump to next instruction, but in 32-bit code segment.
	# Switches processor into 32-bit mode.
	ljmp    $PROT_MODE_CSEG, $protcseg
    7c19:	ea 1e 7c 08 00 66 b8 	ljmp   $0xb866,$0x87c1e

00007c1e <protcseg>:

.code32                     # Assemble for 32-bit mode
protcseg:
	# Set up the protected-mode data segment registers
	movw    $PROT_MODE_DSEG, %ax    # Our data segment selector
    7c1e:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds                # -> DS: Data Segment
    7c22:	8e d8                	mov    %eax,%ds
	movw    %ax, %es                # -> ES: Extra Segment
    7c24:	8e c0                	mov    %eax,%es
	movw    %ax, %fs                # -> FS
    7c26:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs                # -> GS
    7c28:	8e e8                	mov    %eax,%gs
	movw    %ax, %ss                # -> SS: Stack Segment
    7c2a:	8e d0                	mov    %eax,%ss

	# Set up the stack pointer and call into C.
	  movl    $start, %esp
    7c2c:	bc 00 7c 00 00       	mov    $0x7c00,%esp
	  call bootmain
    7c31:	e8 b9 00 00 00       	call   7cef <bootmain>

00007c36 <loop>:
loop:
	jmp loop
    7c36:	eb fe                	jmp    7c36 <loop>

00007c38 <gdt>:
	...
    7c40:	ff 07                	incl   (%edi)
    7c42:	00 00                	add    %al,(%eax)
    7c44:	00 9a c0 00 ff 07    	add    %bl,0x7ff00c0(%edx)
    7c4a:	00 00                	add    %al,(%eax)
    7c4c:	00 92 c0 00 17 00    	add    %dl,0x1700c0(%edx)

00007c50 <gdtdesc>:
    7c50:	17                   	pop    %ss
    7c51:	00 38                	add    %bh,(%eax)
    7c53:	7c 00                	jl     7c55 <gdtdesc+0x5>
    7c55:	00 90 90 ba f7 01    	add    %dl,0x1f7ba90(%eax)

00007c58 <waitdisk>:

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    7c58:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c5d:	ec                   	in     (%dx),%al

void
waitdisk(void)
{
	// wait for disk reaady
	while ((inb(0x1F7) & 0xC0) != 0x40)
    7c5e:	25 c0 00 00 00       	and    $0xc0,%eax
    7c63:	83 f8 40             	cmp    $0x40,%eax
    7c66:	75 f5                	jne    7c5d <waitdisk+0x5>
		/* do nothing */;
}
    7c68:	c3                   	ret    

00007c69 <readsect>:

void
readsect(void *dst, uint32_t offset)
{
    7c69:	57                   	push   %edi
    7c6a:	53                   	push   %ebx
    7c6b:	8b 5c 24 10          	mov    0x10(%esp),%ebx
	// wait for disk to be ready
	waitdisk();
    7c6f:	e8 e4 ff ff ff       	call   7c58 <waitdisk>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
    7c74:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7c79:	b0 01                	mov    $0x1,%al
    7c7b:	ee                   	out    %al,(%dx)
    7c7c:	b2 f3                	mov    $0xf3,%dl
    7c7e:	88 d8                	mov    %bl,%al
    7c80:	ee                   	out    %al,(%dx)

	outb(0x1F2, 1);		// count = 1
	outb(0x1F3, offset);
	outb(0x1F4, offset >> 8);
    7c81:	89 d8                	mov    %ebx,%eax
    7c83:	b2 f4                	mov    $0xf4,%dl
    7c85:	c1 e8 08             	shr    $0x8,%eax
    7c88:	ee                   	out    %al,(%dx)
	outb(0x1F5, offset >> 16);
    7c89:	89 d8                	mov    %ebx,%eax
    7c8b:	b2 f5                	mov    $0xf5,%dl
    7c8d:	c1 e8 10             	shr    $0x10,%eax
    7c90:	ee                   	out    %al,(%dx)
	outb(0x1F6, (offset >> 24) | 0xE0);
    7c91:	c1 eb 18             	shr    $0x18,%ebx
    7c94:	b2 f6                	mov    $0xf6,%dl
    7c96:	88 d8                	mov    %bl,%al
    7c98:	83 c8 e0             	or     $0xffffffe0,%eax
    7c9b:	ee                   	out    %al,(%dx)
    7c9c:	b0 20                	mov    $0x20,%al
    7c9e:	b2 f7                	mov    $0xf7,%dl
    7ca0:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// cmd 0x20 - read sectors

	// wait for disk to be ready
	waitdisk();
    7ca1:	e8 b2 ff ff ff       	call   7c58 <waitdisk>
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
    7ca6:	8b 7c 24 0c          	mov    0xc(%esp),%edi
    7caa:	b9 80 00 00 00       	mov    $0x80,%ecx
    7caf:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7cb4:	fc                   	cld    
    7cb5:	f2 6d                	repnz insl (%dx),%es:(%edi)

	// read a sector
	insl(0x1F0, dst, SECTSIZE/4);
}
    7cb7:	5b                   	pop    %ebx
    7cb8:	5f                   	pop    %edi
    7cb9:	c3                   	ret    

00007cba <readseg>:

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked
void
readseg(uint32_t pa, uint32_t count, uint32_t offset)
{
    7cba:	57                   	push   %edi
    7cbb:	56                   	push   %esi
    7cbc:	53                   	push   %ebx
    7cbd:	8b 74 24 18          	mov    0x18(%esp),%esi
    7cc1:	8b 5c 24 10          	mov    0x10(%esp),%ebx
	uint32_t end_pa;

	end_pa = pa + count;
    7cc5:	8b 7c 24 14          	mov    0x14(%esp),%edi

	// round down to sector boundary
	pa &= ~(SECTSIZE - 1);

	// translate from bytes to sectors, and kernel starts at sector 1
	offset = (offset / SECTSIZE) + 1;
    7cc9:	c1 ee 09             	shr    $0x9,%esi
    7ccc:	46                   	inc    %esi
void
readseg(uint32_t pa, uint32_t count, uint32_t offset)
{
	uint32_t end_pa;

	end_pa = pa + count;
    7ccd:	01 df                	add    %ebx,%edi

	// round down to sector boundary
	pa &= ~(SECTSIZE - 1);
    7ccf:	81 e3 00 fe ff ff    	and    $0xfffffe00,%ebx
	offset = (offset / SECTSIZE) + 1;

	// If this is too slow, we could read lots of sectors at a time.
	// We'd write more to memory than asked, but it doesn't matter --
	// we load in increasing order.
	while (pa < end_pa) {
    7cd5:	eb 10                	jmp    7ce7 <readseg+0x2d>
		// Since we haven't enabled paging yet and we're using
		// an identity segment mapping (see boot.S), we can
		// use physical addresses directly.  This won't be the
		// case once JOS enables the MMU.
		readsect((uint8_t*) pa, offset);
    7cd7:	56                   	push   %esi
		pa += SECTSIZE;
		offset++;
    7cd8:	46                   	inc    %esi
	while (pa < end_pa) {
		// Since we haven't enabled paging yet and we're using
		// an identity segment mapping (see boot.S), we can
		// use physical addresses directly.  This won't be the
		// case once JOS enables the MMU.
		readsect((uint8_t*) pa, offset);
    7cd9:	53                   	push   %ebx
		pa += SECTSIZE;
    7cda:	81 c3 00 02 00 00    	add    $0x200,%ebx
	while (pa < end_pa) {
		// Since we haven't enabled paging yet and we're using
		// an identity segment mapping (see boot.S), we can
		// use physical addresses directly.  This won't be the
		// case once JOS enables the MMU.
		readsect((uint8_t*) pa, offset);
    7ce0:	e8 84 ff ff ff       	call   7c69 <readsect>
		pa += SECTSIZE;
		offset++;
    7ce5:	58                   	pop    %eax
    7ce6:	5a                   	pop    %edx
	offset = (offset / SECTSIZE) + 1;

	// If this is too slow, we could read lots of sectors at a time.
	// We'd write more to memory than asked, but it doesn't matter --
	// we load in increasing order.
	while (pa < end_pa) {
    7ce7:	39 fb                	cmp    %edi,%ebx
    7ce9:	72 ec                	jb     7cd7 <readseg+0x1d>
		// case once JOS enables the MMU.
		readsect((uint8_t*) pa, offset);
		pa += SECTSIZE;
		offset++;
	}
}
    7ceb:	5b                   	pop    %ebx
    7cec:	5e                   	pop    %esi
    7ced:	5f                   	pop    %edi
    7cee:	c3                   	ret    

00007cef <bootmain>:
void readsect(void*, uint32_t);
void readseg(uint32_t, uint32_t, uint32_t);

void
bootmain(void)
{
    7cef:	56                   	push   %esi
    7cf0:	53                   	push   %ebx
    7cf1:	83 ec 04             	sub    $0x4,%esp
	struct Proghdr *ph, *eph;

	// read 1st page off disk
	readseg((uint32_t) ELFHDR, SECTSIZE*8, 0);
    7cf4:	6a 00                	push   $0x0
    7cf6:	68 00 10 00 00       	push   $0x1000
    7cfb:	68 00 00 01 00       	push   $0x10000
    7d00:	e8 b5 ff ff ff       	call   7cba <readseg>

	// is this a valid ELF?
	if (ELFHDR->e_magic != ELF_MAGIC)
    7d05:	83 c4 0c             	add    $0xc,%esp
    7d08:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d0f:	45 4c 46 
    7d12:	75 39                	jne    7d4d <bootmain+0x5e>
		goto bad;

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    7d14:	8b 1d 1c 00 01 00    	mov    0x1001c,%ebx
	eph = ph + ELFHDR->e_phnum;
    7d1a:	0f b7 05 2c 00 01 00 	movzwl 0x1002c,%eax
	// is this a valid ELF?
	if (ELFHDR->e_magic != ELF_MAGIC)
		goto bad;

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    7d21:	81 c3 00 00 01 00    	add    $0x10000,%ebx
	eph = ph + ELFHDR->e_phnum;
    7d27:	c1 e0 05             	shl    $0x5,%eax
    7d2a:	8d 34 03             	lea    (%ebx,%eax,1),%esi
	for (; ph < eph; ph++)
    7d2d:	eb 14                	jmp    7d43 <bootmain+0x54>
		// p_pa is the load address of this segment (as well
		// as the physical address)
		readseg(ph->p_pa, ph->p_memsz, ph->p_offset);
    7d2f:	ff 73 04             	pushl  0x4(%ebx)
    7d32:	ff 73 14             	pushl  0x14(%ebx)
    7d35:	ff 73 0c             	pushl  0xc(%ebx)
		goto bad;

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
	eph = ph + ELFHDR->e_phnum;
	for (; ph < eph; ph++)
    7d38:	83 c3 20             	add    $0x20,%ebx
		// p_pa is the load address of this segment (as well
		// as the physical address)
		readseg(ph->p_pa, ph->p_memsz, ph->p_offset);
    7d3b:	e8 7a ff ff ff       	call   7cba <readseg>
		goto bad;

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
	eph = ph + ELFHDR->e_phnum;
	for (; ph < eph; ph++)
    7d40:	83 c4 0c             	add    $0xc,%esp
    7d43:	39 f3                	cmp    %esi,%ebx
    7d45:	72 e8                	jb     7d2f <bootmain+0x40>
		// as the physical address)
		readseg(ph->p_pa, ph->p_memsz, ph->p_offset);

	// call the entry point from the ELF header
	// note: does not return!
	((void (*)(void)) (ELFHDR->e_entry))();
    7d47:	ff 15 18 00 01 00    	call   *0x10018
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
    7d4d:	ba 00 8a 00 00       	mov    $0x8a00,%edx
    7d52:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
    7d57:	66 ef                	out    %ax,(%dx)
    7d59:	b8 00 8e ff ff       	mov    $0xffff8e00,%eax
    7d5e:	66 ef                	out    %ax,(%dx)
    7d60:	eb fe                	jmp    7d60 <bootmain+0x71>
