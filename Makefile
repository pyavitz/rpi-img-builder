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

kernel:
	# LINUX
	@chmod +x ${KERNEL}
	@${KERNEL}

rootfs:
	# AARCH64 DEBIAN ROOTFS
	@chmod +x ${RFS}
	@${ROOTFS}

image:
	# Make bootable Debian image
	@chmod +x ${IMG}
	@chmod +x ${STG2}
	@${IMAGE}

all:
	# AARCH64
	# - - - - - - - -
	#
	# Building linux
	@chmod +x ${KERNEL}
	@${KERNEL}
	# Creating ROOTFS tarball
	@chmod +x ${RFS}
	@${ROOTFS}
	# Making bootable Debian img
	@chmod +x ${IMG}
	@chmod +x ${STG2}
	@${IMAGE}

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
