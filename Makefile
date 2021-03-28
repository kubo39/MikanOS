.PHONY: all build bootloader clean

LDC := ldc2

BOOTLOADER_SRCS = $(wildcard $(PWD)/bootloader/*.d)
TARGET_OBJ = efimain.o
TARGET_BIN = hello.efi

all: build

build: bootloader

bootloader:
	$(LDC) \
		-mtriple=x86_64-pc-win32-coff \
		-boundscheck=off \
		-betterC \
		-nogc \
		--disable-red-zone \
		-defaultlib= \
		-debuglib= \
		-code-model=large \
		-mattr=-mmx,-sse,+soft-float \
		-relocation-model=static \
		--oq \
		-I./uefi-d/source -I./uefi-d/source/x64 \
		-c \
		-of=$(TARGET_OBJ) \
		$(BOOTLOADER_SRCS)
	lld-link \
		-subsystem:efi_application \
		-entry:EfiMain \
		-nodefaultlib \
		-dll \
		-out:$(TARGET_BIN) \
		$(TARGET_OBJ)

run-qemu: qemu-img
	qemu-system-x86_64 \
		-m 1G \
		-drive if=pflash,format=raw,readonly,file=$(HOME)/dev/osdev/osbook/devenv/OVMF_CODE.fd \
		-drive if=pflash,format=raw,file=$(HOME)/dev/osdev/osbook/devenv/OVMF_VARS.fd \
		-hda disk.img \
		-monitor stdio

qemu-img: bootloader
	qemu-img create -f raw disk.img 200M
	mkfs.fat -n 'Mikan OS' -s 2 -f 2 -R 32 -F 32 disk.img
	mkdir -p mnt
	sudo mount -o loop disk.img mnt
	sudo mkdir -p mnt/EFI/BOOT
	sudo cp $(TARGET_BIN) mnt/EFI/BOOT/BOOTX64.EFI
	sudo umount mnt

clean:
	rm $(TARGET_OBJ) $(TARGET_BIN) *.lib disk.img
