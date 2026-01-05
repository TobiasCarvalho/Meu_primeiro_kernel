CC = gcc
LD = ld
CFLAGS = -ffreestanding -O2 -Wall -Wextra -m32 -fno-pic -fno-pie
LDFLAGS = -nostdlib -m elf_i386

OBJ = boot/entry.o kernel/kernel.o

all: os.iso

boot/entry.o: boot/entry.s
	$(CC) $(CFLAGS) -c boot/entry.s -o $@

kernel/kernel.o: kernel/kernel.c
	$(CC) $(CFLAGS) -c kernel/kernel.c -o $@

kernel.bin: $(OBJ)
	$(LD) $(LDFLAGS) -T linker.ld $(OBJ) -o kernel.bin

iso: kernel.bin
	mkdir -p iso/boot/grub
	cp kernel.bin iso/boot/kernel.bin
	cp grub.cfg iso/boot/grub/grub.cfg
	grub-mkrescue -o os.iso iso

run: iso
	qemu-system-i386 -cdrom os.iso

clean:
	rm -rf *.o boot/*.o boot/*.s kernel/*.o kernel.bin iso os.iso
