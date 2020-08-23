# menu
MENU=./lib/menu
CONF=./lib/config
MLCONF=./lib/ml_config
ADMIN=./lib/admin_config
DIALOGRC=$(shell cp -f lib/dialogrc ~/.dialogrc)

# rootfs
RFSV8=./scripts/rootfsv8
ROOTFSV8=sudo ./scripts/rootfsv8
RFSV6=./scripts/rootfsv6
ROOTFSV6=sudo ./scripts/rootfsv6

# aarch64
BCM2711=./scripts/bcm2711
BCM2710=./scripts/bcm2710
MAINLINE=./scripts/mainline

# armv6l
BCM2708=./scripts/bcm2708

# stages
IMG=./scripts/raspberrypi-stage1
IMAGE=sudo ./scripts/raspberrypi-stage1
STG2=./scripts/raspberrypi-stage2

# clean
CLN=./scripts/clean
CLEAN=sudo ./scripts/clean

# help
HELPER=./scripts/help

help:
	@echo
	@echo "Debian Image Builder for the Raspberry Pi"
	@echo
	@echo "Usage: "
	@echo
	@echo "  make ccompile          Install all dependencies"
	@echo "  make ncompile          Install native dependencies"
	@echo "  make config            Create user data file"
	@echo "  make menu              User menu interface"
	@echo "  make cleanup           Clean up image errors"
	@echo "  make purge             Remove tmp directory"
	@echo "  make commands          List legacy commands"
	@echo
	@echo "For details consult the README.md"
	@echo

commands:
	@echo
	@echo "Boards:"
	@echo
	@echo "  bcm2711                 Raspberry Pi 4B"
	@echo "  bcm2710                 Raspberry Pi 3A/B/+"
	@echo "  bcm2708                 Raspberry Pi 0/0W/B/+"
	@echo
	@echo "bcm2711:"
	@echo " "
	@echo "  make kernel             Builds linux kernel"
	@echo "  make image              Make bootable Debian image"
	@echo "  make all                Kernel > rootfs > image"
	@echo
	@echo "bcm2710:"
	@echo " "
	@echo "  make rpi3-kernel        Builds linux kernel"
	@echo "  make rpi3-image         Make bootable Debian image"
	@echo "  make rpi3-all           Kernel > rootfs > image"
	@echo
	@echo "bcm2708:"
	@echo " "
	@echo "  make rpi-kernel         Builds linux kernel"
	@echo "  make rpi-image          Make bootable Debian image"
	@echo "  make rpi-all            Kernel > rootfs > image"
	@echo
	@echo "Mainline:"
	@echo
	@echo "  make mlconfig		  Create user data file"
	@echo "  make mainline		  Builds mainline linux kernel"
	@echo
	@echo "Root filesystem:"
	@echo
	@echo "  make rootfs		  arm64"
	@echo "  make rootfsv6		  armel"
	@echo
	@echo "Miscellaneous:"
	@echo
	@echo "  make dialogrc		  Set builder theme"
	@echo "  make helper		  Reduce the time it takes to create a new image"
	@echo

# aarch64
ccompile:
	# Install all dependencies:
	sudo apt install build-essential bison bc git dialog patch \
	dosfstools zip unzip qemu debootstrap qemu-user-static rsync \
	kmod cpio flex libssl-dev libncurses5-dev parted fakeroot swig \
	crossbuild-essential-arm64 crossbuild-essential-armel

ncompile:
	# Install native dependencies:
	sudo apt install build-essential bison bc git dialog patch \
	dosfstools zip unzip qemu debootstrap qemu-user-static rsync \
	kmod cpio flex libssl-dev libncurses5-dev parted fakeroot swig

# Raspberry Pi 4 | aarch64
kernel:
	# Linux | aarch64
	@chmod +x ${BCM2711}
	@${BCM2711}

image:
	# Making bootable Debian image
	@ echo bcm2711 > soc.txt
	@chmod +x ${IMG}
	@chmod +x ${STG2}
	@${IMAGE}

all:
	# RPi4B | aarch64
	# - - - - - - - -
	#
	# Building linux
	@chmod +x ${BCM2711}
	@${BCM2711}
	# Creating ROOTFS tarball
	@chmod +x ${RFSV8}
	@${ROOTFSV8}
	# Making bootable Debian image
	@ echo bcm2711 > soc.txt
	@chmod +x ${IMG}
	@chmod +x ${STG2}
	@${IMAGE}

mainline:
	# Mainline Linux | aarch64
	@chmod +x ${MAINLINE}
	@${MAINLINE}

# Raspberry Pi 3 | aarch64
rpi3-kernel:
	# Linux | aarch64
	@chmod +x ${BCM2710}
	@${BCM2710}

rpi3-image:
	# Making bootable Debian image
	@ echo bcm2710 > soc.txt
	@chmod +x ${IMG}
	@chmod +x ${STG2}
	@${IMAGE}

rpi3-all:
	# RPi3B/+ | aarch64
	# - - - - - - - -
	#
	# Building linux
	@chmod +x ${BCM2710}
	@${BCM2710}
	# Creating ROOTFS tarball
	@chmod +x ${RFSV8}
	@${ROOTFSV8}
	# Making bootable Debian image
	@ echo bcm2710 > soc.txt
	@chmod +x ${IMG}
	@chmod +x ${STG2}
	@${IMAGE}

# Raspberry Pi | armv6l
rpi-kernel:
	# Linux | armv6l
	@chmod +x ${BCM2708}
	@${BCM2708}

rpi-image:
	# Make bootable Debian image
	@ echo bcm2708 > soc.txt
	@chmod +x ${IMG}
	@chmod +x ${STG2}
	@${IMAGE}

rpi-all:
	# RPi | armv6l
	# - - - - - - - -
	#
	# Building linux
	@chmod +x ${BCM2708}
	@${BCM2708}
	# Creating ROOTFS tarball
	@chmod +x ${RFSV6}
	@${ROOTFSV6}
	# Making bootable Debian img
	@ echo bcm2708 > soc.txt
	@chmod +x ${IMG}
	@chmod +x ${STG2}
	@${IMAGE}

# rootfs
rootfs:
	# ARM64 DEBIAN ROOTFS
	@chmod +x ${RFSV8}
	@${ROOTFSV8}

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

# menu
menu:
	# User menu interface
	@chmod +x ${MENU}
	@${MENU}
config:
	# User config menu
	@chmod +x ${CONF}
	@${CONF}

mlconfig:
	# User config menu
	@chmod +x ${MLCONF}
	@${MLCONF}

admin:
	# User config menu
	@chmod +x ${ADMIN}
	@${ADMIN}

dialogrc:
	# Builder theme set
	@${DIALOGRC}

helper:
	# Helper script
	@chmod +x ${HELPER}
	@${HELPER} -h

2708:
	# BCM2708
	@chmod +x ${HELPER}
	@${HELPER} -1

2710:
	# BCM2710
	@chmod +x ${HELPER}
	@${HELPER} -3

2711:
	# BCM2711
	@chmod +x ${HELPER}
	@${HELPER} -4
