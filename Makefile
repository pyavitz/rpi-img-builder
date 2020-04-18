#include config.txt

# aarch64
KERNEL4=./scripts/make-kernel4
RFS=./scripts/make-rootfsv8
ROOTFS=sudo ./scripts/make-rootfsv8
IMG4=./scripts/rpi4-stage1
IMAGE4=sudo ./scripts/rpi4-stage1
STG42=./scripts/rpi4-stage2

KERNEL3=./scripts/make-kernel3
RFS=./scripts/make-rootfsv8
ROOTFS=sudo ./scripts/make-rootfsv8
IMG3=./scripts/rpi3-stage1
IMAGE3=sudo ./scripts/rpi3-stage1
STG32=./scripts/rpi3-stage2

# armv7l
KERNEL4V7=./scripts/make-kernel4v7
RFSV7=./scripts/make-rootfsv7
ROOTFSV7=sudo ./scripts/make-rootfsv7
IMG4V7=./scripts/rpi4v7-stage1
IMAGE4V7=sudo ./scripts/rpi4v7-stage1
STG42V7=./scripts/rpi4v7-stage2

KERNEL3V7=./scripts/make-kernel3v7
RFSV7=./scripts/make-rootfsv7
ROOTFSV7=sudo ./scripts/make-rootfsv7
IMG3V7=./scripts/rpi3v7-stage1
IMAGE3V7=sudo ./scripts/rpi3v7-stage1
STG32V7=./scripts/rpi3v7-stage2

#armv6l
KERNEL0=./scripts/make-kernel0
RFS0=./scripts/make-rootfsv6
ROOTFS0=sudo ./scripts/make-rootfsv6
IMG0=./scripts/rpi0-stage1
IMAGE0=sudo ./scripts/rpi0-stage1
STG02=./scripts/rpi0-stage2

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
	@echo "  make purge             Remove tmp directory"
	@echo
	@echo "  make all               Feeling lucky?"
	@echo
	@echo "For details consult the README.md file"
	@echo

# aarch64
install-depends:
	# Install all dependencies: aarch64
	sudo apt install build-essential bison bc git dialog patch \
	dosfstools zip unzip qemu debootstrap qemu-user-static rsync \
	kmod cpio flex libssl-dev libncurses5-dev parted fakeroot swig \
	crossbuild-essential-arm64

# Raspberry Pi 4
kernel:
	# LINUX
	@chmod +x ${KERNEL4}
	@${KERNEL4}

rootfs:
	# AARCH64 DEBIAN ROOTFS
	@chmod +x ${RFS}
	@${ROOTFS}

image:
	# Make bootable Debian image
	@chmod +x ${IMG4}
	@chmod +x ${STG42}
	@${IMAGE4}

all:
	# AARCH64
	# - - - - - - - -
	#
	# Building linux
	@chmod +x ${KERNEL4}
	@${KERNEL4}
	# Creating ROOTFS tarball
	@chmod +x ${RFS}
	@${ROOTFS}
	# Making bootable Debian img
	@chmod +x ${IMG4}
	@chmod +x ${STG42}
	@${IMAGE4}

# armv7l
install-dependsv7:
	# Install all dependencies: armv7l
	sudo apt install build-essential bison bc git dialog patch \
	dosfstools zip unzip qemu debootstrap qemu-user-static rsync \
	kmod cpio flex libssl-dev libncurses5-dev parted fakeroot swig \
	crossbuild-essential-armhf

kernelv7:
	# LINUX v7l
	@chmod +x ${KERNELV7}
	@${KERNELV7}



rootfsv7:
	# ARMHF DEBIAN ROOTFS
	@chmod +x ${RFSV7}
	@${ROOTFSV7}



imagev7:
	# Make bootable Debian image
	@chmod +x ${IMGV7}
	@chmod +x ${STG2V7}
	@${IMAGEV7}


allv7:
	# ARMv7l
	# - - - - - - - -
	#
	# Building linux
	@chmod +x ${KERNELV7}
	@${KERNELV7}
	# Creating ROOTFS tarball
	@chmod +x ${RFSV7}
	@${ROOTFSV7}
	# Making bootable Debian img
	@chmod +x ${IMGV7}
	@chmod +x ${STG2V7}
	@${IMAGEV7}

# clean and purge
cleanup:
	# Cleaning up
	@chmod +x ${CLN}
	@${CLEAN}

purge:
	# Removing tmp directory
	sudo rm -fdr tmp
##
