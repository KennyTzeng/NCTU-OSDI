# OSDI Lab6
###### tags: `OSDI 2019`

## Objective
+ Understand how multiprocessor works in x86 system.
+ Add multiprocessor support to NCTUOS.
+ Modify your task scheduler to support multicore.

## Usage
```
// compile
make all

// run qemu
make qemu CPUS=n

// debug mode
make debug CPUS=n
```

## Notes
+ lapic_eoi() : To tell that it has finished the interrupt processing works, can continue to allow more interrupt requests now.
    + [End of interrupt by Wekipedia](https://en.wikipedia.org/wiki/End_of_interrupt)

+ When CPU wants to interrupt any other processor or set of processors (interprocessor interrupts, INI), put data on ICR, and the interrupt will go through ICC BUS.

## References
[MultiProcessor Specification Version 1.4 by Intel](https://web.archive.org/web/20121002210153/http://download.intel.com/design/archives/processors/pro/docs/24201606.pdf)

## Questions

### 1. mp_init():
#### 1.1 What does mp_config() do?
To search for an MP configuration table. This table contains explicit configuration information about APICs, processors, buses, and interrupts.

Additionally, another one data structure called "MP floating pointer" can link to this table. According to [Intel's MultiProcessor Specification](https://web.archive.org/web/20121002210153/http://download.intel.com/design/archives/processors/pro/docs/24201606.pdf), this structure must be stored in at least one of the following memory locations:
+ In the first kilobyte of Extended BIOS Data Area (EBDA)
+ Within the last kilobyte of system base memory (e.g., 639K-640K for systems with 640 KB of base memory or 511K-512K for systems with 512 KB of base memory) if the EBDA segment is undefined
+ In the BIOS ROM address space between 0F0000h and 0FFFFFh

Therefore, In mp_config(), at first call mpsearch() and mpsearch1() to search for the MP floating pointer structure in the order described above. If it finds, get the address of MP configuration table and check for the correct signature, checksum, and version. Then return the MP configuration table.

#### 1.2 What does this loop do?
```
for (p = conf->entries, i = 0; i < conf->entry; i++) {
    ...
}
```
As mentioned above, MP configuration table contains many information, and it consists of a header, followed by a number of entries of various types.

So this loop in mp_init() is to go through every entry of MP configuration table and get information, in this case it will count how many CPUs the system has.

#### 1.3 What is the interrupt mode for the nctuOS?
According to the MP specification, it defines three different interrupt modes as follows: (more details at 3.6.2)
1. PIC Mode—effectively bypasses all APIC components and forces the system to operate in single-processor mode.
2. Virtual Wire Mode—uses an APIC as a virtual wire, but otherwise operates the same as PIC Mode.
3. Symmetric I/O Mode—enables the system to operate with more than one processor.

In this case it is Virtual Wire Mode, becasue the system only enable LINT0 on BSP, disable the others and disable LINT1 on all CPUs. And there is no code about I/O APIC.

```c
// at lapic_init() in kernel/lapic.c

77 // Leave LINT0 of the BSP enabled so that it can get
78 // interrupts from the 8259A chip.
79 //
80 // According to Intel MP Specification, the BIOS should initialize
81 // BSP's local APIC in Virtual Wire Mode, in which 8259A's
82 // INTR is virtually connected to BSP's LINTIN0. In this mode,
83 // we do not need to program the IOAPIC.
84 if (thiscpu != bootcpu)//mask every cpu other than bootcpu
85 	lapicw(LINT0, MASKED);
86
87 // Disable NMI (LINT1) on all CPUs
88 lapicw(LINT1, MASKED);//why?
```



### 2. How did you modify:
#### 2.1 task_create()
The most different is I lock the global tasks by spinlock before go into find the task whose state is free, and really do unlock before every return point. 

Since it is multi-core right now, there may be another CPU modifing the state of task when you are looking for a free task, so it has to be ensured that only one can access the global resources simultaneously.

#### 2.2 sys_fork()
Process of copy a task is the same as before (except the new spinlock part mentioned above), after create a new task, find a CPU whose run queue has the less runnable tasks, put the new task into it (by append the new task's pid to CPU's run queue).

Similarly, lock the global cpus before go through it, because there may be another CPU adding or removing a task.

#### 2.3 sys_kill()
In lab5 sys_kill() just check the given pid number whether it is valid and then free the page directory, change the state of task and call schedule().

Here we have to check whether this pid number is in CPU's run queue, if there is, take it out of CPU's run queue and do the same things as before.

Note we have to lock the global tasks and cpus here.



### 3. How did you modify the scheduler for the SMP system?
Function schedule() is almost the same as before, use a round-robin algorithm to choose a runnable task from CPU's run queue and context switch into it.



### 4. What does boot_aps() do?
boot_aps() in kernel/main.c is to boot other CPUs at a time. It mainly does 2 things:
+ use memmove() in lib/string.c to copy the codes defined in kernel/mpentry.S to address MPENTRY_PADDR.
+ call lapic_startup() to boot a CPU at a time.

```c
// at boot_aps() in kernel/main.c

71 extern char mpentry_start[], mpentry_end[];
72 memmove(KADDR(MPENTRY_PADDR), mpentry_start, mpentry_end - mpentry_start);

...

84 int i;
85 for (i = 0; i < ncpu; i++) {
86     if (cpus[i].cpu_id == cpunum()) {
87         continue;
88     }
89     mpentry_kstack = percpu_kstacks[i] + KSTKSIZE;
90     lapic_startap(cpus[i].cpu_id, MPENTRY_PADDR);
91     while (cpus[i].cpu_status != CPU_STARTED);
92 }
```

#### 4.1 How does the mpentry_kstack setup?
Since booting AP is once a time, just set the mpentry_kstack to the percpu_kstacks[i] we setup before in mem_init() and call lapic_startup() is fine.

#### 4.2 What does lapic_startup do(mechanism)?
I am not quite understand the code of lapic_startup(), but I guess it's these few lines turning the program counter to MPENTRY_PADDR. The contents waiting us there is code mpentry_start() we memmove() before.

After doing some setting works in mpentry_start(), it will call mp_main() defined in kernel/main.c to do the rest jobs, once it finished, set the CPU state to STARTED and then the BSP will go booting the next one CPU.

```c
// at lapic_startup() in kernel/lapic.c

165 // Send startup IPI (twice!) to enter code.
166 // Regular hardware is supposed to only accept a STARTUP
167 // when it is in the halted state due to an INIT.  So the second
168 // should be ignored, but it is part of the official Intel algorithm.
169 // Bochs complains about the second one.  Too bad for Bochs.
170 for (i = 0; i < 2; i++) {
171     lapicw(ICRHI, apicid << 24);
172     lapicw(ICRLO, STARTUP | (addr >> 12));
173     microdelay(200);
174 }
```

Note that lapicw() used in lapic_startup() is like some kind of mmio operation. Since the memory is mapped into the device, setting the value at that memory address is equal to control the device.

#### 4.3 What’s AP’s initial program counter after it wake up?

When AP wake up, it's PC is at MPENTRY_PADDR, it's 0x7000.