
/* DO NOT EDIT!  This is an autogenerated file.  See scripts/layoutrom.py. */
OUTPUT_FORMAT("elf32-i386")
OUTPUT_ARCH("i386")
SECTIONS
{
MaxPCIBus = 0x6df4 ;
DebugOutputPort = 0x6d46 ;
PirAddr = 0x6de8 ;
entry_pcibios32 = 0xd549 ;
entry_apm16 = 0xd4d6 ;
entry_apm32 = 0xd517 ;
acpi_pm1a_cnt = 0x6dec ;
.text.get_global_offset 0x71af : { *(.text.get_global_offset) }
.text.pci_next 0x71bb : { *(.text.pci_next) }
.text.putc.clone.18 0x7228 : { *(.text.putc.clone.18) }
.text.putsinglehex.clone.20 0x723d : { *(.text.putsinglehex.clone.20) }
.text.puthex.clone.21 0x7252 : { *(.text.puthex.clone.21) }
.text.putprettyhex.clone.22 0x72d7 : { *(.text.putprettyhex.clone.22) }
.text.puts.clone.23 0x730c : { *(.text.puts.clone.23) }
.text.putuint.clone.24 0x7322 : { *(.text.putuint.clone.24) }
.text.__dprintf 0x7350 : { *(.text.__dprintf) }
.text.handle_pcibios 0x754a : { *(.text.handle_pcibios) }
.rodata 0x79ee : { *(.rodata) }
.text.handle_apm 0x7874 : { *(.text.handle_apm) }


        /* Discard regular data sections to force a link error if
         * code attempts to access data not marked with VAR16 (or other
         * appropriate macro)
         */
        /DISCARD/ : {
                *(.text*) *(.data*) *(.bss*) *(.rodata*)
                *(COMMON) *(.discard*) *(.eh_frame) *(.note*)
                }
}
