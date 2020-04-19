# rootfs
RFSV8=./scripts/make-rootfsv8
ROOTFSV8=sudo ./scripts/make-rootfsv8
RFSV7=./scripts/make-rootfsv7
ROOTFSV7=sudo ./scripts/make-rootfsv7
RFSV6=./scripts/make-rootfsv6
ROOTFSV6=sudo ./scripts/make-rootfsv6

# aarch64
KERNEL4=./scripts/make-kernel4
IMG4=./scripts/rpi4-stage1
IMAGE4=sudo ./scripts/rpi4-stage1
STG42=./scripts/rpi4-stage2

KERNEL3=./scripts/make-kernel3
IMG3=./scripts/rpi3-stage1
IMAGE3=sudo ./scripts/rpi3-stage1
STG32=./scripts/rpi3-stage2

# armv7l
KERNEL4V7=./scripts/make-kernel4v7
IMG4V7=./scripts/rpi4v7-stage1
IMAGE4V7=sudo ./scripts/rpi4v7-stage1
STG42V7=./scripts/rpi4v7-stage2

KERNEL3V7=./scripts/make-kernel3v7
IMG3V7=./scripts/rpi3v7-stage1
IMAGE3V7=sudo ./scripts/rpi3v7-stage1
STG32V7=./scripts/rpi3v7-stage2

#armv6l
KERNEL0=./scripts/make-kernel0
IMG0=./scripts/rpi0-stage1
IMAGE0=sudo ./scripts/rpi0-stage1
STG02=./scripts/rpi0-stage2

# clean
CLN=./scripts/clean
CLEAN=sudo ./scripts/clean


help:
	@echo
	@echo "Check config.txt for options"
	@echo
	@echo "Usage: rpi4b"
	@echo
	@echo "  make install-depends   Install all dependencies"
	@echo "  make kernel            Make linux kernel"
	@echo "  make rootfs            Make ROOTFS tarball"
	@echo "  make image             Make bootable Debian image"
	@echo "  make cleanup           Clean up image errors"
	@echo "  make purge             Remove tmp directory"
	@echo "  make commands          Build RPi3B / RPi0W images"
	@echo
	@echo "  make all               Feeling lucky?"
	@echo
	@echo "For details consult the README.md"
	@echo

commands:
	@echo
	@echo "Install dependencies"
	@echo
	@echo "  make install-dependsv7   Install all armhf dependencies"
	@echo "  make install-dependsv6   Install all armel dependencies"
	@echo
	@echo "Boards:"
	@echo
	@echo "  rpi4 (default)           Raspberry Pi 4B"
	@echo "  rpi3                     Raspberry Pi 3B/+"
	@echo "  rpi0                     Raspberry Pi 0w"
	@echo
	@echo "RPi3B/+:"
	@echo " aacrh64"
	@echo "  make rpi3-kernel         Builds linux kernel"
	@echo "  make rpi3-image          Make bootable Debian image"
	@echo "  make rpi3-all            Kernel > rootfs > image"
	@echo
	@echo " armv7l"
	@echo "  make rpi3-kernelv7       Builds linux kernel"
	@echo "  make rpi3-imagev7        Make bootable Debian image"
	@echo "  make rpi3-allv7          Kernel > rootfs > image"
	@echo
	@echo "RPi0W:"
	@echo " armv6l"	
	@echo "  make rpi0-kernel         Builds linux kernel"
	@echo "  make rpi0-image          Make bootable Debian image"
	@echo "  make rpi0-all            Kernel > rootfs > image"
	@echo
	@echo "Root filesystem:"
	@echo
	@echo "  make rootfs (default)	  ARM64"
	@echo "  make rootfsv7		  ARMHF"
	@echo "  make rootfsv6		  ARMEL"
	@echo

# aarch64
install-depends:
	# Install all dependencies: aarch64
	sudo apt install build-essential bison bc git dialog patch \
	dosfstools zip unzip qemu debootstrap qemu-user-static rsync \
	kmod cpio flex libssl-dev libncurses5-dev parted fakeroot swig \
	crossbuild-essential-arm64

# Raspberry Pi 4 | aarch64
kernel:
	# LINUX
	@chmod +x ${KERNEL4}
	@${KERNEL4}

image:
	# Make bootable Debian image
	@chmod +x ${IMG4}
	@chmod +x ${STG42}
	@${IMAGE4}

all:
	# RPi4B > AARCH64
	# - - - - - - - -
	#
	# Building linux
	@chmod +x ${KERNEL4}
	@${KERNEL4}
	# Creating ROOTFS tarball
	@chmod +x ${RFSV8}
	@${ROOTFSV8}
	# Making bootable Debian img
	@chmod +x ${IMG4}
	@chmod +x ${STG42}
	@${IMAGE4}

# Raspberry Pi 3 | aarch64
rpi3-kernel:
	# LINUX
	@chmod +x ${KERNEL3}
	@${KERNEL3}

rpi3-image:
	# Make bootable Debian image
	@chmod +x ${IMG3}
	@chmod +x ${STG32}
	@${IMAGE3}

rpi3-all:
	# RPi3B/+ > AARCH64
	# - - - - - - - -
	#
	# Building linux
	@chmod +x ${KERNEL3}
	@${KERNEL3}
	# Creating ROOTFS tarball
	@chmod +x ${RFSV8}
	@${ROOTFSV8}
	# Making bootable Debian img
	@chmod +x ${IMG3}
	@chmod +x ${STG32}
	@${IMAGE3}

# armv7l
install-dependsv7:
	# Install all dependencies: armv7l
	sudo apt install build-essential bison bc git dialog patch \
	dosfstools zip unzip qemu debootstrap qemu-user-static rsync \
	kmod cpio flex libssl-dev libncurses5-dev parted fakeroot swig \
	crossbuild-essential-armhf

# Raspberry Pi 4 | armv7l
kernelv7:
	# LINUX v7l
	@chmod +x ${KERNEL4V7}
	@${KERNEL4V7}

imagev7:
	# Make bootable Debian image
	@chmod +x ${IMG4V7}
	@chmod +x ${STG42V7}
	@${IMAGE4V7}

allv7:
	# RPi4B > ARMv7l
	# - - - - - - - -
	#
	# Building linux
	@chmod +x ${KERNEL4V7}
	@${KERNEL4V7}
	# Creating ROOTFS tarball
	@chmod +x ${RFSV7}
	@${ROOTFSV7}
	# Making bootable Debian img
	@chmod +x ${IMG4V7}
	@chmod +x ${STG42V7}
	@${IMAGE4V7}

# Raspberry Pi 3 | armv7l
rpi3-kernelv7:
	# LINUX
	@chmod +x ${KERNEL3V7}
	@${KERNEL3V7}

rpi3-imagev7:
	# Make bootable Debian image
	@chmod +x ${IMG3V7}
	@chmod +x ${STG32V7}
	@${IMAGE3V7}

rpi3-allv7:
	# RP3B/+ > ARMv7l
	# - - - - - - - -
	#
	# Building linux
	@chmod +x ${KERNEL3V7}
	@${KERNEL3V7}
	# Creating ROOTFS tarball
	@chmod +x ${RFSV7}
	@${ROOTFSV7}
	# Making bootable Debian img
	@chmod +x ${IMG3V7}
	@chmod +x ${STG32V7}
	@${IMAGE3V7}

install-dependsv6:
	# Install all dependencies: armv6l
	sudo apt install build-essential bison bc git dialog patch \
	dosfstools zip unzip qemu debootstrap qemu-user-static rsync \
	kmod cpio flex libssl-dev libncurses5-dev parted fakeroot swig \
	crossbuild-essential-armel

# Raspberry Pi 0w | armv6l
rpi0-kernel:
	# LINUX
	@chmod +x ${KERNEL0}
	@${KERNEL0}

rpi0-image:
	# Make bootable Debian image
	@chmod +x ${IMG0}
	@chmod +x ${STG02}
	@${IMAGE0}

rpi0-all:
	# RPi0W > ARMV6L
	# - - - - - - - -
	#
	# Building linux
	@chmod +x ${KERNEL0}
	@${KERNEL0}
	# Creating ROOTFS tarball
	@chmod +x ${RFSV6}
	@${ROOTFSV6}
	# Making bootable Debian img
	@chmod +x ${IMG0}
	@chmod +x ${STG02}
	@${IMAGE0}

# rootfs
rootfs:
	# ARM64 DEBIAN ROOTFS
	@chmod +x ${RFSV8}
	@${ROOTFSV8}
	
rootfsv7:
	# ARMHF DEBIAN ROOTFS
	@chmod +x ${RFSV7}
	@${ROOTFSV7}

rootfsv6:
	# ARMEL DEBIAN ROOTFS
	@chmod +x ${RFSV6}
	@${ROOTFSV6}

# clean and purge
cleanup:
	# Cleaning up
	@chmod +x ${CLN}
	@${CLEAN}

purge:
	# Removing tmp directory
	sudo rm -fdr rpi*
##
