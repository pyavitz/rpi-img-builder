#include config.txt

KERNEL=./scripts/make-kernel
RFS=./scripts/make-rootfs
ROOTFS=sudo ./scripts/make-rootfs
IMG=./scripts/stage1
IMAGE=sudo ./scripts/stage1
STG2=./scripts/stage2
CLN=./scripts/clean
CLEAN=sudo ./scripts/clean


help:
	@echo
	@echo "Check config.txt for options"
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
	# Install all dependencies
	sudo apt install build-essential bison bc git dialog patch dosfstools zip unzip qemu debootstrap qemu-user-static rsync kmod cpio flex libssl-dev libncurses5-dev parted fakeroot swig crossbuild-essential-arm64

kernel:
	# Make linux kernel
	@chmod +x ${KERNEL}
	@${KERNEL}

rootfs:
	# Make Debian Rootfs 
	@chmod +x ${RFS}
	@${ROOTFS}

image:
	# Make bootable Debian image
	@chmod +x ${IMG}
	@chmod +x ${STG2}
	@${IMAGE}

cleanup:
	# Cleaning up
	@chmod +x ${CLN}
	@${CLEAN}

##
