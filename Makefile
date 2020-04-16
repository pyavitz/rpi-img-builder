#include config.txt

# aarch64
KERNEL=./scripts/make-kernel
RFS=./scripts/make-rootfs
ROOTFS=sudo ./scripts/make-rootfs
IMG=./scripts/stage1
IMAGE=sudo ./scripts/stage1
STG2=./scripts/stage2

# armv7l
KERNELV7=./scripts/make-kernelv7
RFSV7=./scripts/make-rootfsv7
ROOTFSV7=sudo ./scripts/make-rootfsv7
IMGV7=./scripts/stage1v7
IMAGEV7=sudo ./scripts/stage1v7
STG2V7=./scripts/stage2v7

# clean
CLN=./scripts/clean
CLEAN=sudo ./scripts/clean


help:
	@echo
	@echo "Check config.txt for options"
	@echo "Append v7 to build 32bit ver."
	@echo
	@echo "Usage:"
	@echo
	@echo "  make install-depends   Install all dependencies"
	@echo "  make kernel            Make linux kernel"
	@echo "  make rootfs            Make ROOTFS tarball"
	@echo "  make image             Make bootable Debian image"
	@echo "  make cleanup           Clean up image errors"
	@echo
	@echo "For details consult the README.md file"
	@echo


install-depends:
	# Install all dependencies: aarch64
	sudo apt install build-essential bison bc git dialog patch \
	dosfstools zip unzip qemu debootstrap qemu-user-static rsync \
	kmod cpio flex libssl-dev libncurses5-dev parted fakeroot swig \
	crossbuild-essential-arm64

install-dependsv7:
	# Install all dependencies: armv7l
	sudo apt install build-essential bison bc git dialog patch \
	dosfstools zip unzip qemu debootstrap qemu-user-static rsync \
	kmod cpio flex libssl-dev libncurses5-dev parted fakeroot swig \
	crossbuild-essential-armhf

kernel:
	# Make linux kernel
	@chmod +x ${KERNEL}
	@${KERNEL}

kernelv7:
	# Make linux kernel v7l
	@chmod +x ${KERNELV7}
	@${KERNELV7}

rootfs:
	# Make Debian Rootfs 
	@chmod +x ${RFS}
	@${ROOTFS}

rootfsv7:
	# Make Debian armhf Rootfs
	@chmod +x ${RFSV7}
	@${ROOTFSV7}

image:
	# Make bootable Debian image
	@chmod +x ${IMG}
	@chmod +x ${STG2}
	@${IMAGE}

imagev7:
	# Make bootable Debian image
	@chmod +x ${IMGV7}
	@chmod +x ${STG2V7}
	@${IMAGEV7}

cleanup:
	# Cleaning up
	@chmod +x ${CLN}
	@${CLEAN}

##
