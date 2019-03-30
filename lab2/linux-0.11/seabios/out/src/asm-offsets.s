	.file	"asm-offsets.c"
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.section	.text.foo,"ax",@progbits
.globl foo
	.type	foo, @function
foo:
.LFB49:
	.file 1 "src/asm-offsets.c"
	.loc 1 10 0
	.cfi_startproc
	.loc 1 11 0
#APP
# 11 "src/asm-offsets.c" 1
	
->#BREGS
# 0 "" 2
	.loc 1 12 0
# 12 "src/asm-offsets.c" 1
	
->BREGS_es $2 offsetof(struct bregs, es)
# 0 "" 2
	.loc 1 13 0
# 13 "src/asm-offsets.c" 1
	
->BREGS_ds $0 offsetof(struct bregs, ds)
# 0 "" 2
	.loc 1 14 0
# 14 "src/asm-offsets.c" 1
	
->BREGS_eax $28 offsetof(struct bregs, eax)
# 0 "" 2
	.loc 1 15 0
# 15 "src/asm-offsets.c" 1
	
->BREGS_ebx $16 offsetof(struct bregs, ebx)
# 0 "" 2
	.loc 1 16 0
# 16 "src/asm-offsets.c" 1
	
->BREGS_ecx $24 offsetof(struct bregs, ecx)
# 0 "" 2
	.loc 1 17 0
# 17 "src/asm-offsets.c" 1
	
->BREGS_edx $20 offsetof(struct bregs, edx)
# 0 "" 2
	.loc 1 18 0
# 18 "src/asm-offsets.c" 1
	
->BREGS_ebp $12 offsetof(struct bregs, ebp)
# 0 "" 2
	.loc 1 19 0
# 19 "src/asm-offsets.c" 1
	
->BREGS_esi $8 offsetof(struct bregs, esi)
# 0 "" 2
	.loc 1 20 0
# 20 "src/asm-offsets.c" 1
	
->BREGS_edi $4 offsetof(struct bregs, edi)
# 0 "" 2
	.loc 1 21 0
# 21 "src/asm-offsets.c" 1
	
->BREGS_flags $36 offsetof(struct bregs, flags)
# 0 "" 2
	.loc 1 22 0
# 22 "src/asm-offsets.c" 1
	
->BREGS_code $32 offsetof(struct bregs, code)
# 0 "" 2
	.loc 1 23 0
#NO_APP
	ret
	.cfi_endproc
.LFE49:
	.size	foo, .-foo
	.text
.Letext0:
	.file 2 "src/types.h"
	.file 3 "src/bregs.h"
	.section	.debug_info
	.long	0x487
	.value	0x3
	.long	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.long	.LASF41
	.byte	0x1
	.long	.LASF42
	.long	.LASF43
	.long	0x0
	.long	0x0
	.long	.Ldebug_ranges0+0x0
	.long	.Ldebug_line0
	.uleb128 0x2
	.string	"u8"
	.byte	0x2
	.byte	0x9
	.long	0x33
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.long	.LASF0
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.long	.LASF1
	.uleb128 0x2
	.string	"u16"
	.byte	0x2
	.byte	0xb
	.long	0x4c
	.uleb128 0x3
	.byte	0x2
	.byte	0x7
	.long	.LASF2
	.uleb128 0x3
	.byte	0x2
	.byte	0x5
	.long	.LASF3
	.uleb128 0x2
	.string	"u32"
	.byte	0x2
	.byte	0xd
	.long	0x65
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.long	.LASF4
	.uleb128 0x4
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.long	.LASF5
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.long	.LASF6
	.uleb128 0x5
	.long	.LASF7
	.byte	0x2
	.byte	0x11
	.long	0x5a
	.uleb128 0x6
	.byte	0x4
	.byte	0x2
	.byte	0x1b
	.long	0xad
	.uleb128 0x7
	.long	.LASF8
	.byte	0x2
	.byte	0x1c
	.long	0x41
	.sleb128 0
	.uleb128 0x8
	.string	"seg"
	.byte	0x2
	.byte	0x1d
	.long	0x41
	.sleb128 2
	.byte	0x0
	.uleb128 0x9
	.byte	0x4
	.byte	0x2
	.byte	0x1a
	.long	0xc6
	.uleb128 0xa
	.long	0x8c
	.uleb128 0xb
	.long	.LASF14
	.byte	0x2
	.byte	0x1f
	.long	0x5a
	.byte	0x0
	.uleb128 0xc
	.long	.LASF37
	.byte	0x4
	.byte	0x2
	.byte	0x19
	.long	0xd9
	.uleb128 0xd
	.long	0xad
	.sleb128 0
	.byte	0x0
	.uleb128 0x6
	.byte	0x4
	.byte	0x3
	.byte	0x1a
	.long	0xf9
	.uleb128 0x8
	.string	"di"
	.byte	0x3
	.byte	0x1a
	.long	0x41
	.sleb128 0
	.uleb128 0x7
	.long	.LASF9
	.byte	0x3
	.byte	0x1a
	.long	0x41
	.sleb128 2
	.byte	0x0
	.uleb128 0x6
	.byte	0x4
	.byte	0x3
	.byte	0x1a
	.long	0x132
	.uleb128 0x7
	.long	.LASF10
	.byte	0x3
	.byte	0x1a
	.long	0x29
	.sleb128 0
	.uleb128 0x7
	.long	.LASF11
	.byte	0x3
	.byte	0x1a
	.long	0x29
	.sleb128 1
	.uleb128 0x7
	.long	.LASF12
	.byte	0x3
	.byte	0x1a
	.long	0x29
	.sleb128 2
	.uleb128 0x7
	.long	.LASF13
	.byte	0x3
	.byte	0x1a
	.long	0x29
	.sleb128 3
	.byte	0x0
	.uleb128 0x9
	.byte	0x4
	.byte	0x3
	.byte	0x1a
	.long	0x150
	.uleb128 0xe
	.string	"edi"
	.byte	0x3
	.byte	0x1a
	.long	0x5a
	.uleb128 0xa
	.long	0xd9
	.uleb128 0xa
	.long	0xf9
	.byte	0x0
	.uleb128 0x6
	.byte	0x4
	.byte	0x3
	.byte	0x1b
	.long	0x170
	.uleb128 0x8
	.string	"si"
	.byte	0x3
	.byte	0x1b
	.long	0x41
	.sleb128 0
	.uleb128 0x7
	.long	.LASF15
	.byte	0x3
	.byte	0x1b
	.long	0x41
	.sleb128 2
	.byte	0x0
	.uleb128 0x6
	.byte	0x4
	.byte	0x3
	.byte	0x1b
	.long	0x1a9
	.uleb128 0x7
	.long	.LASF16
	.byte	0x3
	.byte	0x1b
	.long	0x29
	.sleb128 0
	.uleb128 0x7
	.long	.LASF17
	.byte	0x3
	.byte	0x1b
	.long	0x29
	.sleb128 1
	.uleb128 0x7
	.long	.LASF18
	.byte	0x3
	.byte	0x1b
	.long	0x29
	.sleb128 2
	.uleb128 0x7
	.long	.LASF19
	.byte	0x3
	.byte	0x1b
	.long	0x29
	.sleb128 3
	.byte	0x0
	.uleb128 0x9
	.byte	0x4
	.byte	0x3
	.byte	0x1b
	.long	0x1c7
	.uleb128 0xe
	.string	"esi"
	.byte	0x3
	.byte	0x1b
	.long	0x5a
	.uleb128 0xa
	.long	0x150
	.uleb128 0xa
	.long	0x170
	.byte	0x0
	.uleb128 0x6
	.byte	0x4
	.byte	0x3
	.byte	0x1c
	.long	0x1e7
	.uleb128 0x8
	.string	"bp"
	.byte	0x3
	.byte	0x1c
	.long	0x41
	.sleb128 0
	.uleb128 0x7
	.long	.LASF20
	.byte	0x3
	.byte	0x1c
	.long	0x41
	.sleb128 2
	.byte	0x0
	.uleb128 0x6
	.byte	0x4
	.byte	0x3
	.byte	0x1c
	.long	0x220
	.uleb128 0x7
	.long	.LASF21
	.byte	0x3
	.byte	0x1c
	.long	0x29
	.sleb128 0
	.uleb128 0x7
	.long	.LASF22
	.byte	0x3
	.byte	0x1c
	.long	0x29
	.sleb128 1
	.uleb128 0x7
	.long	.LASF23
	.byte	0x3
	.byte	0x1c
	.long	0x29
	.sleb128 2
	.uleb128 0x7
	.long	.LASF24
	.byte	0x3
	.byte	0x1c
	.long	0x29
	.sleb128 3
	.byte	0x0
	.uleb128 0x9
	.byte	0x4
	.byte	0x3
	.byte	0x1c
	.long	0x23e
	.uleb128 0xe
	.string	"ebp"
	.byte	0x3
	.byte	0x1c
	.long	0x5a
	.uleb128 0xa
	.long	0x1c7
	.uleb128 0xa
	.long	0x1e7
	.byte	0x0
	.uleb128 0x6
	.byte	0x4
	.byte	0x3
	.byte	0x1d
	.long	0x25e
	.uleb128 0x8
	.string	"bx"
	.byte	0x3
	.byte	0x1d
	.long	0x41
	.sleb128 0
	.uleb128 0x7
	.long	.LASF25
	.byte	0x3
	.byte	0x1d
	.long	0x41
	.sleb128 2
	.byte	0x0
	.uleb128 0x6
	.byte	0x4
	.byte	0x3
	.byte	0x1d
	.long	0x295
	.uleb128 0x8
	.string	"bl"
	.byte	0x3
	.byte	0x1d
	.long	0x29
	.sleb128 0
	.uleb128 0x8
	.string	"bh"
	.byte	0x3
	.byte	0x1d
	.long	0x29
	.sleb128 1
	.uleb128 0x7
	.long	.LASF26
	.byte	0x3
	.byte	0x1d
	.long	0x29
	.sleb128 2
	.uleb128 0x7
	.long	.LASF27
	.byte	0x3
	.byte	0x1d
	.long	0x29
	.sleb128 3
	.byte	0x0
	.uleb128 0x9
	.byte	0x4
	.byte	0x3
	.byte	0x1d
	.long	0x2b3
	.uleb128 0xe
	.string	"ebx"
	.byte	0x3
	.byte	0x1d
	.long	0x5a
	.uleb128 0xa
	.long	0x23e
	.uleb128 0xa
	.long	0x25e
	.byte	0x0
	.uleb128 0x6
	.byte	0x4
	.byte	0x3
	.byte	0x1e
	.long	0x2d3
	.uleb128 0x8
	.string	"dx"
	.byte	0x3
	.byte	0x1e
	.long	0x41
	.sleb128 0
	.uleb128 0x7
	.long	.LASF28
	.byte	0x3
	.byte	0x1e
	.long	0x41
	.sleb128 2
	.byte	0x0
	.uleb128 0x6
	.byte	0x4
	.byte	0x3
	.byte	0x1e
	.long	0x30a
	.uleb128 0x8
	.string	"dl"
	.byte	0x3
	.byte	0x1e
	.long	0x29
	.sleb128 0
	.uleb128 0x8
	.string	"dh"
	.byte	0x3
	.byte	0x1e
	.long	0x29
	.sleb128 1
	.uleb128 0x7
	.long	.LASF29
	.byte	0x3
	.byte	0x1e
	.long	0x29
	.sleb128 2
	.uleb128 0x7
	.long	.LASF30
	.byte	0x3
	.byte	0x1e
	.long	0x29
	.sleb128 3
	.byte	0x0
	.uleb128 0x9
	.byte	0x4
	.byte	0x3
	.byte	0x1e
	.long	0x328
	.uleb128 0xe
	.string	"edx"
	.byte	0x3
	.byte	0x1e
	.long	0x5a
	.uleb128 0xa
	.long	0x2b3
	.uleb128 0xa
	.long	0x2d3
	.byte	0x0
	.uleb128 0x6
	.byte	0x4
	.byte	0x3
	.byte	0x1f
	.long	0x348
	.uleb128 0x8
	.string	"cx"
	.byte	0x3
	.byte	0x1f
	.long	0x41
	.sleb128 0
	.uleb128 0x7
	.long	.LASF31
	.byte	0x3
	.byte	0x1f
	.long	0x41
	.sleb128 2
	.byte	0x0
	.uleb128 0x6
	.byte	0x4
	.byte	0x3
	.byte	0x1f
	.long	0x37f
	.uleb128 0x8
	.string	"cl"
	.byte	0x3
	.byte	0x1f
	.long	0x29
	.sleb128 0
	.uleb128 0x8
	.string	"ch"
	.byte	0x3
	.byte	0x1f
	.long	0x29
	.sleb128 1
	.uleb128 0x7
	.long	.LASF32
	.byte	0x3
	.byte	0x1f
	.long	0x29
	.sleb128 2
	.uleb128 0x7
	.long	.LASF33
	.byte	0x3
	.byte	0x1f
	.long	0x29
	.sleb128 3
	.byte	0x0
	.uleb128 0x9
	.byte	0x4
	.byte	0x3
	.byte	0x1f
	.long	0x39d
	.uleb128 0xe
	.string	"ecx"
	.byte	0x3
	.byte	0x1f
	.long	0x5a
	.uleb128 0xa
	.long	0x328
	.uleb128 0xa
	.long	0x348
	.byte	0x0
	.uleb128 0x6
	.byte	0x4
	.byte	0x3
	.byte	0x20
	.long	0x3bd
	.uleb128 0x8
	.string	"ax"
	.byte	0x3
	.byte	0x20
	.long	0x41
	.sleb128 0
	.uleb128 0x7
	.long	.LASF34
	.byte	0x3
	.byte	0x20
	.long	0x41
	.sleb128 2
	.byte	0x0
	.uleb128 0x6
	.byte	0x4
	.byte	0x3
	.byte	0x20
	.long	0x3f4
	.uleb128 0x8
	.string	"al"
	.byte	0x3
	.byte	0x20
	.long	0x29
	.sleb128 0
	.uleb128 0x8
	.string	"ah"
	.byte	0x3
	.byte	0x20
	.long	0x29
	.sleb128 1
	.uleb128 0x7
	.long	.LASF35
	.byte	0x3
	.byte	0x20
	.long	0x29
	.sleb128 2
	.uleb128 0x7
	.long	.LASF36
	.byte	0x3
	.byte	0x20
	.long	0x29
	.sleb128 3
	.byte	0x0
	.uleb128 0x9
	.byte	0x4
	.byte	0x3
	.byte	0x20
	.long	0x412
	.uleb128 0xe
	.string	"eax"
	.byte	0x3
	.byte	0x20
	.long	0x5a
	.uleb128 0xa
	.long	0x39d
	.uleb128 0xa
	.long	0x3bd
	.byte	0x0
	.uleb128 0xc
	.long	.LASF38
	.byte	0x26
	.byte	0x3
	.byte	0x17
	.long	0x477
	.uleb128 0x8
	.string	"ds"
	.byte	0x3
	.byte	0x18
	.long	0x41
	.sleb128 0
	.uleb128 0x8
	.string	"es"
	.byte	0x3
	.byte	0x19
	.long	0x41
	.sleb128 2
	.uleb128 0xd
	.long	0x132
	.sleb128 4
	.uleb128 0xd
	.long	0x1a9
	.sleb128 8
	.uleb128 0xd
	.long	0x220
	.sleb128 12
	.uleb128 0xd
	.long	0x295
	.sleb128 16
	.uleb128 0xd
	.long	0x30a
	.sleb128 20
	.uleb128 0xd
	.long	0x37f
	.sleb128 24
	.uleb128 0xd
	.long	0x3f4
	.sleb128 28
	.uleb128 0x7
	.long	.LASF39
	.byte	0x3
	.byte	0x21
	.long	0xc6
	.sleb128 32
	.uleb128 0x7
	.long	.LASF40
	.byte	0x3
	.byte	0x22
	.long	0x41
	.sleb128 36
	.byte	0x0
	.uleb128 0xf
	.byte	0x1
	.string	"foo"
	.byte	0x1
	.byte	0x9
	.byte	0x1
	.long	.LFB49
	.long	.LFE49
	.byte	0x1
	.byte	0x9c
	.byte	0x0
	.section	.debug_abbrev
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x52
	.uleb128 0x1
	.uleb128 0x55
	.uleb128 0x6
	.uleb128 0x10
	.uleb128 0x6
	.byte	0x0
	.byte	0x0
	.uleb128 0x2
	.uleb128 0x16
	.byte	0x0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x3
	.uleb128 0x24
	.byte	0x0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0x0
	.byte	0x0
	.uleb128 0x4
	.uleb128 0x24
	.byte	0x0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0x0
	.byte	0x0
	.uleb128 0x5
	.uleb128 0x16
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x6
	.uleb128 0x13
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0x7
	.uleb128 0xd
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xd
	.byte	0x0
	.byte	0x0
	.uleb128 0x8
	.uleb128 0xd
	.byte	0x0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xd
	.byte	0x0
	.byte	0x0
	.uleb128 0x9
	.uleb128 0x17
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0xa
	.uleb128 0xd
	.byte	0x0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0xb
	.uleb128 0xd
	.byte	0x0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0xc
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0xd
	.uleb128 0xd
	.byte	0x0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xd
	.byte	0x0
	.byte	0x0
	.uleb128 0xe
	.uleb128 0xd
	.byte	0x0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0x0
	.byte	0x0
	.uleb128 0xf
	.uleb128 0x2e
	.byte	0x0
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0xa
	.byte	0x0
	.byte	0x0
	.byte	0x0
	.section	.debug_pubnames,"",@progbits
	.long	0x16
	.value	0x2
	.long	.Ldebug_info0
	.long	0x48b
	.long	0x477
	.string	"foo"
	.long	0x0
	.section	.debug_pubtypes,"",@progbits
	.long	0x47
	.value	0x2
	.long	.Ldebug_info0
	.long	0x48b
	.long	0x29
	.string	"u8"
	.long	0x41
	.string	"u16"
	.long	0x5a
	.string	"u32"
	.long	0x81
	.string	"size_t"
	.long	0xc6
	.string	"segoff_s"
	.long	0x412
	.string	"bregs"
	.long	0x0
	.section	.debug_aranges,"",@progbits
	.long	0x1c
	.value	0x2
	.long	.Ldebug_info0
	.byte	0x4
	.byte	0x0
	.value	0x0
	.value	0x0
	.long	.LFB49
	.long	.LFE49-.LFB49
	.long	0x0
	.long	0x0
	.section	.debug_ranges,"",@progbits
.Ldebug_ranges0:
	.long	.LFB49
	.long	.LFE49
	.long	0x0
	.long	0x0
	.section	.debug_str,"MS",@progbits,1
.LASF18:
	.string	"si_hilo"
.LASF7:
	.string	"size_t"
.LASF14:
	.string	"segoff"
.LASF26:
	.string	"bx_hilo"
.LASF31:
	.string	"cx_hi"
.LASF4:
	.string	"unsigned int"
.LASF30:
	.string	"dx_hihi"
.LASF38:
	.string	"bregs"
.LASF32:
	.string	"cx_hilo"
.LASF0:
	.string	"unsigned char"
.LASF37:
	.string	"segoff_s"
.LASF2:
	.string	"short unsigned int"
.LASF28:
	.string	"dx_hi"
.LASF35:
	.string	"ax_hilo"
.LASF10:
	.string	"di8l"
.LASF33:
	.string	"cx_hihi"
.LASF39:
	.string	"code"
.LASF13:
	.string	"di_hihi"
.LASF16:
	.string	"si8l"
.LASF11:
	.string	"di8u"
.LASF29:
	.string	"dx_hilo"
.LASF43:
	.string	"/home/osdi/osdi/linux-0.11/seabios"
.LASF40:
	.string	"flags"
.LASF24:
	.string	"bp_hihi"
.LASF5:
	.string	"long long unsigned int"
.LASF41:
	.string	"GNU C 4.5.1 20100924 (Red Hat 4.5.1-4)"
.LASF17:
	.string	"si8u"
.LASF20:
	.string	"bp_hi"
.LASF42:
	.string	"src/asm-offsets.c"
.LASF12:
	.string	"di_hilo"
.LASF6:
	.string	"long long int"
.LASF15:
	.string	"si_hi"
.LASF23:
	.string	"bp_hilo"
.LASF27:
	.string	"bx_hihi"
.LASF8:
	.string	"offset"
.LASF21:
	.string	"bp8l"
.LASF3:
	.string	"short int"
.LASF19:
	.string	"si_hihi"
.LASF9:
	.string	"di_hi"
.LASF25:
	.string	"bx_hi"
.LASF1:
	.string	"signed char"
.LASF22:
	.string	"bp8u"
.LASF36:
	.string	"ax_hihi"
.LASF34:
	.string	"ax_hi"
	.ident	"GCC: (GNU) 4.5.1 20100924 (Red Hat 4.5.1-4)"
	.section	.note.GNU-stack,"",@progbits
