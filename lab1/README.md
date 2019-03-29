# OSDI Lab1
###### tags: `OSDI 2019`

## Objective:
In this lab you can learn
*	Understand version control system and makefile project
*	Learn how to use QEMU and GDB to debug Linux 0.11 kernel
*	Learn how to commit to GIT system

## Lab 1-1 Linux 0.11 Development Environment Setup

1. Prepare Git environment
2. GitLab account registration
3. Checkout your lab files from GitLab

```
$ git clone
$ cd osdi
$ git checkout -b lab1 origin/lab1
```

4. Find the makefile bugs

There are some missing tab.

```
[osdi@localhost linux-0.11]$ make
Makefile:37: *** missing separator.  Stop.

# in Makefile
.c.s:
@$(CC) $(CFLAGS) -S -o $*.s $<
.s.o:
@$(AS)  -o $*.o $<
.c.o:
@$(CC) $(CFLAGS) -c -o $*.o $<
```

Just add tab before each line of recipe.

```
# in Makefile
.c.s:
    @$(CC) $(CFLAGS) -S -o $*.s $<
.s.o:
    @$(AS)  -o $*.o $<
.c.o:
    @$(CC) $(CFLAGS) -c -o $*.o $<
```

And then

```
$ make: execvp: tools/build.sh: Permission denied
```

Add execute permission to tools/build.sh.

```
[osdi@localhost linux-0.11]# chmod +x tools/build.sh
```

5.	Build the Linux 0.11

```
$ cd linux-0.11
$ make
```

After make, you will see a bootable file Image in the linux-0.11 folder, it contains system bootloader and linux0.11 kernel.

Note: if you have modified any file, please ‘make clean’ before next make.

6.	Compile and install newest QEMU

Note: Your QEMU emulator version needs larger than 2.5.x .
Reference: https://en.wikibooks.org/wiki/QEMU

```
$ git clone git://git.qemu-project.org/qemu.git
$ cd qemu
$ git checkout -b v2.6 origin/stable-2.6
$ git submodule update --init dtc
$ git submodule update --init pixman
$ ./configure
$ make && make install
```

7. Run the Linux 0.11

After Linux 0.11 make, the system will produce a bootable floppy disk image called “Image” in your Linux 0.11 root folder, then you can just use QEMU emulator to load this image and run Linux 0.11.

```
$ qemu-system-i386 -m 16M -boot a -fda Image -hda ../osdi.img
```

## Lab 1-2 Debug kernel

1. Find the kernel bugs
2. Debug the Linux 0.11 on QEMU

We can launch qemu with `-s` and `-S` option, CPU will freeze at startup and we can use `gdb` to attach.

```
$ qemu-system-i386 -m 16M -boot a -fda Image -hda ../osdi.img -s -S -serial stdio
```

The first bug is unneccessary panic() call, just comment it.

```
(gdb) bt
#0  0x000077ba in timer_interrupt ()
#1  0x00008a05 in panic (s=0x8 "\a0") at panic.c:24
#2  0x000068bf in main () at init/main.c:140
```

at init/main.c :

```c
138    floppy_init();
139    sti();
140    // panic("");
141    move_to_user_mode();
142    if (!fork()) {      /* we count on this going ok */
143        init();
144    }
```

Set breakpoint at main() and keep using `ni` or `si` to step one instruction, we will find that `NR_TASK = 0`. Modify it in include/linux/sched.h.

```
(gdb) si
127    i = NR_TASKS;
=> 0x00006dc4 <schedule+198>: c7 44 24 1c 00 00 00 00	 movl $0x0,0x1c(%esp)
(gdb) si
129    while (--i) {
=> 0x00006e18 <schedule+282>: 83 6c 24 1c 01  subl $0x1,0x1c(%esp)
   0x00006e1d <schedule+287>: 83 7c 24 1c 00  cmpl $0x0,0x1c(%esp)
   0x00006e22 <schedule+292>: 75 b2	        jne  0x6dd6 <schedule+216>
(gdb) x/wx $esp+0x1c
0x1b108 <init_task+4040>: 0x00000000
(gdb) si
0x00006e1d 129    while (--i) {
   0x00006e18 <schedule+282>: 83 6c 24 1c 01  subl $0x1,0x1c(%esp)
=> 0x00006e1d <schedule+287>: 83 7c 24 1c 00  cmpl $0x0,0x1c(%esp)
   0x00006e22 <schedule+292>: 75 b2	        jne  0x6dd6 <schedule+216>
(gdb) x/wx $esp+0x1c
0x1b108 <init_task+4040>: 0xffffffff
```

3. Print your student id

Add printf() before fork() and execve(shell) at init/main.c :

```c
195    // print my student id before shell startup
196	printf("Hello B062515\n\r");
197	
198	while (1) {
199	    if ((pid=fork())<0) {
200		    printf("Fork failed in init\r\n");
201		    continue;
202	    }
203	    if (!pid) {
204		    close(0);close(1);close(2);
205		    setsid();
206		    (void) open("/dev/tty0",O_RDWR,0);
207		    (void) dup(0);
208		    (void) dup(0);
209		    _exit(execve("/bin/sh",argv,envp));
210	    }
```

## Lab 1-3 Submit your lab1 for DEMO

Git-基礎-與遠端協同工作: https://git-scm.com/book/zh-tw/v1/Git-%E5%9F%BA%E7%A4%8E-%E8%88%87%E9%81%A0%E7%AB%AF%E5%8D%94%E5%90%8C%E5%B7%A5%E4%BD%9C </br>
Git-Documentation: https://git-scm.com/docs


## Questions
1. QEMU
```
qemu-system-i386 -m 16M -boot a -fda Image -hda ../osdi.img -s -S -serial stdio
``` 
According to the above command:
1.1: What's the difference between -S and -s in the command?

-S: freeze CPU at startup (use 'c' to start execution)
-s: shorthand for -gdb tcp::1234
-serial dev: redirect the serial port to char device 'dev'

  
1.2: What are -boot, -fda and -hda used for? If I want to boot with \.\./osdi.img(supposed it's a bootable image) what should I do?

-boot [order=drives], 'drives': floppy (a), hard disk \(c\), CD-ROM (d), network (n)
-fda/-fdb file: use 'file' as floppy disk 0/1 image
-hda/-hdb file: use 'file' as IDE hard disk 0/1 image

```
qemu-system-i386 -m 16M -boot c -fda Image -hda ../osdi.img
```


2. Git

2.1: Please explain all the flags and options used in below command:
```
git checkout -b lab1 origin/lab1
```

According to the [git-checkout](https://git-scm.com/docs/git-checkout) :
```
git checkout [[-b|-B|--orphan] <new_branch>] [<start_point>]

-b: Create a new branch named <new_branch> and start it at <start_point>;
```
git checkout: Switch branches or restore working tree files
-b <new_branch> <start_point>: 
Create a new branch named <new_branch> and start it at <start_point>


2.2 What are the differences among git add, git commit, and git push? What's the timing you will use them?


3. Makefile

3.1: What happened when you run the below command? Please explain it according to the Makefile.
```
make clean && make
```

`make clean` will execute the instructions of rule "clean" in Makefile. In this case it will remove some temporary or object files.

```
# in Makefile

clean:
    @rm -f Image System.map tmp_make core boot/bootsect boot/setup
    @rm -f init/*.o tools/system boot/*.o typescript* info bochsout.txt
    @for i in mm fs kernel lib boot; do make clean -C $$i; done
```

`make` will execute the instructions of first rule by default.

```
# in Makefile

all:    Image

Image: boot/bootsect boot/setup tools/system
    @cp -f tools/system system.tmp
    @strip system.tmp
    @objcopy -O binary -R .note -R .comment system.tmp tools/kernel
    @tools/build.sh boot/bootsect boot/setup tools/kernel Image $(ROOT_DEV)
    @rm system.tmp
    @rm tools/kernel -f
    @sync
```

3.2: I did edit the include/linux/sched.h file and run `make` command successfully but the Image file remains the same. However, if I edit the init/main.c file and run `make` command. My Image will be recompile. What's the difference between these two operations?

Although there is a rule like `init/main.o: ... include/linux/sched.h ...`, but it doesn't do anything, xxx.c or xxx.s code will not be compiled again.


4: After making, what does the kernel Image 'Image' look like?

Look at the code in tools/build.sh, this is how 'Image' been built.

```clike
# tools/build.sh
...
25 # Write bootsect (512 bytes, one sector) to stdout
26 [ ! -f "$bootsect" ] && echo "there is no bootsect binary file there" && exit -1
27 dd if=$bootsect bs=512 count=1 of=$IMAGE 2>&1 >/dev/null
28
29 # Write setup(4 * 512bytes, four sectors) to stdout
30 [ ! -f "$setup" ] && echo "there is no setup binary file there" && exit -1
31 dd if=$setup seek=1 bs=512 count=4 of=$IMAGE 2>&1 >/dev/null
32
33 # Write system(< SYS_SIZE) to stdout
34 [ ! -f "$system" ] && echo "there is no system binary file there" && exit -1
35 system_size=`wc -c $system |cut -d" " -f1`
36 [ $system_size -gt $SYS_SIZE ] && echo "the system binary is too big" && exit -1
37 dd if=$system seek=5 bs=512 count=$((2888-1-4)) of=$IMAGE 2>&1 >/dev/null
38
39 # Set "device" for the root image file
40 echo -ne "\x$DEFAULT_MINOR_ROOT\x$DEFAULT_MAJOR_ROOT" | dd ibs=1 obs=1 count=2 seek=508 of=$IMAGE conv=notrunc  2>&1 >/dev/null
```
