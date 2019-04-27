# OSDI Lab5
###### tags: `OSDI 2019`

## Objective:
+ x86 context-switch mechanism
+ System call
+ Task scheduler

## Notes
[Extended Asm - Assembler Instructions with C Expression Operands](https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html)

"volatile" : Using the volatile qualifier disables optimizations.

"cc" : The "cc" clobber indicates that the assembler code modifies the flags register.

"memory" : The "memory" clobber tells the compiler that the assembly code performs memory reads or writes to items other than those listed in the input and output operands.

---

[CPL vs. DPL vs. RPL](https://stackoverflow.com/questions/36617718/difference-between-dpl-and-rpl-in-x86)

CPL : Your current privilege level.
DPL : The privilege level of a segment. It defines the minimum privilege level required to access the segment.
RPL : Privilege level associated with a segment selector. A segment selector is just a 16-bit value that references a segment. Every memory access (implicitly or otherwise) uses a segment selector as part of the access.

When accessing a segment, there are actually two checks that must be performed. Access to the segment is only allowed if both of the following are true:
+ CPL <= DPL
+ RPL <= DPL

## References
[lab5_reference.pdf](https://drive.google.com/file/d/1keV0BWLIY_dFqxKOAY84RcUzMAtf2lyZ/view)
[Intel® 64 and IA-32 Architectures Software Developer’s Manual](https://software.intel.com/sites/default/files/managed/a4/60/325384-sdm-vol-3abcd.pdf)

## Questions
### 1. How did you implement “your” super perfect elegant scheduler?

I select next task from `tasks[]` to run by 
i. Sequentially search a task which state is runnable, start from pid = currunt task's pid + 1.
ii. Go back to the start when get to the end (like a circle).
iii. Run current task again if there is no other task runnable.

```c=
// at kernel/sched.c line 22

void sched_yield(void)
{
    extern Task tasks[];
    extern Task *cur_task;
    int next_pid = cur_task->task_id;

    int i;
    for (i = ((cur_task->task_id) + 1) % NR_TASKS; i != cur_task->task_id; i == NR_TASKS - 1 ? (i = 0) : (i++)) {
        if (tasks[i].state == TASK_RUNNABLE) {
            next_pid = i;
            break;
        }
    }

    cur_task = &(tasks[next_pid]);
    cur_task->state = TASK_RUNNING;
    cur_task->remind_ticks = TIME_QUANT;
    lcr3(PADDR(cur_task->pgdir));
    ctx_switch(cur_task);
}
```

### 2. System Call & Interrupt

### 2-1. How do we pass the arguments and the return value when doing system call？

By registers. Passing at most 6 arguments in eax(syscall number), edx, ecx, ebx, edi and esi, and put the return value in eax.

```clike=
// at lib/syscall.c line 25

asm volatile("int %1\n"
    : "=a" (ret)
    : "i" (T_SYSCALL),
      "a" (num),
      "d" (a1),
      "c" (a2),
      "b" (a3),
      "D" (a4),
      "S" (a5)
    : "cc", "memory");
```

### 2-2. How is stack set when interrupt occurs in user mode？ How about kernel mode？

CPU will automatically push ss, esp, eflags, cs and eip into stack, while only push eflags, cs and eip in kernel mode.

After that, we push a integer 0 in place of the error code, and ds, es and all general register to save the context into stack. See kernel/trap_entry.S and struct Trapframe in inc/trap.h in more details.

![](https://i.imgur.com/i60PigA.png)

### 2-3. Could you implement a non-shared kernel stack in the nctuOS？Could you do it with only one tss?

Yes, by additional paging management mechanism to handle this.

### 3. Process

### 3-1. Based on NCTU-OS, which of the following items are shared between our forked tasks?
i. user stack
ii. user data
iii. user code
iv. kernel stack
v. kernel data
vi. kernel code

Only user stack is not shared, others are all shared.
See task_create(), sys_fork() in kernel/task.c and setupkvm() in kernel/mem.c in more details.

+ user stack: allocate individual space
```clike=
// at kernel/task.c line 119
/* Setup User Stack */
int va;
for (va = USTACKTOP; va > USTACKTOP - USR_STACK_SIZE; va -= PGSIZE) {
    struct PageInfo *pp = page_alloc(ALLOC_ZERO);
    if (!pp) {
        return -1;
    }
    if (page_insert(ts->pgdir, pp, va - PGSIZE, PTE_W | PTE_U) == -1) {
        return -1;
    }
}
```

+ user data and user code
```clike=
// at kernel/task.c line 239
/* Step 4: All user program use the same code for now */
setupvm(tasks[pid].pgdir, (uint32_t)UTEXT_start, UTEXT_SZ);
setupvm(tasks[pid].pgdir, (uint32_t)UDATA_start, UDATA_SZ);
setupvm(tasks[pid].pgdir, (uint32_t)UBSS_start, UBSS_SZ);
setupvm(tasks[pid].pgdir, (uint32_t)URODATA_start, URODATA_SZ);
```

+ kernel stack, kernel data and kernel code
```clike=
// at kernel/mem.c line 593
pde_t * setupkvm()
{
    struct PageInfo *pp = page_alloc(ALLOC_ZERO);
    if (!pp) {
        return NULL;
    }
    pde_t *pgdir = page2kva(pp);
    boot_map_region(pgdir, UPAGES, ROUNDUP((sizeof(struct PageInfo) * npages), PGSIZE), PADDR(pages), PTE_U);
    boot_map_region(pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
    boot_map_region(pgdir, KERNBASE, (2^32)-KERNBASE, 0, PTE_W);
    boot_map_region(pgdir, IOPHYSMEM, ROUNDUP((EXTPHYSMEM - IOPHYSMEM), PGSIZE), IOPHYSMEM, PTE_W);
    return pgdir;
}
```

### 3-2. How do we save and restore the contents of registers and stack when context switch?

Like answer of 2-2, save the context by pushing such contents of registers into stack to form a Trapframe structure before context switch.

Restore the context by calling env_pop_tf() in kernel/trap.c, what it actually does is popping out the context we pushed before.

```clike=
// at kernel/trap.c line 121
void env_pop_tf(struct Trapframe *tf)
{
    __asm __volatile("movl %0,%%esp\n"
        "\tpopal\n"
        "\tpopl %%es\n"
        "\tpopl %%ds\n"
        "\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
        "\tiret"
        : : "g" (tf) : "memory");
    panic("iret failed");  /* mostly to placate the compiler */
}
```

### 4. Gate

### 4-1. When setting user code and data segment in gdt(kernel/task.c), why we set the dpl value to be 3?

Linux kernel only uses 2 privilege level, 0(kernel) and 3(user). We can access the segment if our CPL is less than or equal to the DPL of segment.

### 4-2. How do you determine the dpl value of every interrupts and trap gates? (ex: system call, timer, keyboard, page fault) Please refer to Chap 6.12 of the Intel manual Vol3.

The processor checks the DPL of the interrupt or trap gate only if an exception or interrupt is generated with an INT n, INT3, or INTO instruction. Here, the CPL must be less than or equal to the DPL of the gate.

This restriction prevents application programs or procedures running at privilege level 3 from using a software interrupt to access critical exception handlers, such as the page-fault handler, providing that those handlers are placed in more privileged code segments (numerically lower privilege level). 

System call is a trap to enter kernel space from user space to request services from OS, so dpl value of this case can be 3.

For hardware-generated interrupts and processor-detected exceptions, the processor ignores the DPL of interrupt and trap gates.