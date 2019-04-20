# OSDI Lab4
###### tags: `OSDI 2019`

## Objective:
+ Understand how paging works in x86 system
+ Implement physical memory allocation function
+ Implement page table setup functions

## Build and Run
```
make all
qemu-system-i386 -hda kernel.img
```

## Questions
1. Please explain the following functions:
+ boot_alloc
+ page_init
+ page_alloc
+ page_free



2. Please explain the following functions:
+ pgdir_walk
+ page_lookup
+ boot_map_region
+ page_remove
+ page_insert



3. Please show how the physical address space and the virtual address space change from booting to the end of mem_init.



4. Why do we need RELOC at line 8 and line 24 in kernel/entry.S?
```
_start = RELOC(entry)
movl $(RELOC(entry_pgdir)), %eax
```



5. why we use `mov $relocated, %eax; jmp *eax` instead of `jmp relocated` ? If we use the later one, will it incur page fault? If yes, where the page fault incurs. If no, explain the reason.



6. After paging, how does the memory mapped io mechanism change?
