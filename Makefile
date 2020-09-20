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

# kernel
LINUX=./scripts/linux
MAINLINE=./scripts/mainline

# stages
DEB=./scripts/debian-stage1
DEBIAN=sudo ./scripts/debian-stage1
DEBSTG2=./scripts/debian-stage2

DEV=./scripts/devuan-stage1
DEVUAN=sudo ./scripts/devuan-stage1
DEVSTG2=./scripts/devuan-stage2

UBU=./scripts/ubuntu-stage1
UBUNTU=sudo ./scripts/ubuntu-stage1
UBUSTG2=./scripts/ubuntu-stage2

# choose distribution
CHOOSE=./scripts/choose

# clean
CLN=./scripts/clean
CLEAN=sudo ./scripts/clean

# help
HELPER=./scripts/help

help:
	@echo
	@echo "Raspberry Pi Image Builder"
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
	@echo "  make image              Make bootable image"
	@echo "  make all                Kernel > rootfs > image"
	@echo
	@echo "bcm2710:"
	@echo " "
	@echo "  make rpi3-kernel        Builds linux kernel"
	@echo "  make rpi3-image         Make bootable image"
	@echo "  make rpi3-all           Kernel > rootfs > image"
	@echo
	@echo "bcm2708:"
	@echo " "
	@echo "  make rpi-kernel         Builds linux kernel"
	@echo "  make rpi-image          Make bootable image"
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
	@ echo bcm2711 > soc.txt
	@chmod +x ${LINUX}
	@${LINUX}

image:
	# Making bootable Debian image
	@ echo bcm2711 > soc.txt
	@chmod +x ${CHOOSE}
	@${CHOOSE}

all:
	# RPi4B | aarch64
	# - - - - - - - -
	#
	# Building linux
	@ echo bcm2711 > soc.txt
	@chmod +x ${LINUX}
	@${LINUX}
	# Creating ROOTFS tarball
	@chmod +x ${RFSV8}
	@${ROOTFSV8}
	# Making bootable image
	@ echo bcm2711 > soc.txt
	@chmod +x ${CHOOSE}
	@${CHOOSE}

mainline:
	# Mainline Linux | aarch64
	@chmod +x ${MAINLINE}
	@${MAINLINE}

# Raspberry Pi 3 | aarch64
rpi3-kernel:
	# Linux | aarch64
	@ echo bcm2710 > soc.txt
	@chmod +x ${LINUX}
	@${LINUX}

rpi3-image:
	# Making bootable image
	@ echo bcm2710 > soc.txt
	@chmod +x ${CHOOSE}
	@${CHOOSE}

rpi3-all:
	# RPi3B/+ | aarch64
	# - - - - - - - -
	#
	# Building linux
	@ echo bcm2710 > soc.txt
	@chmod +x ${LINUX}
	@${LINUX}
	# Creating ROOTFS tarball
	@chmod +x ${RFSV8}
	@${ROOTFSV8}
	# Making bootable image
	@ echo bcm2710 > soc.txt
	@chmod +x ${CHOOSE}
	@${CHOOSE}

# Raspberry Pi | armv6l
rpi-kernel:
	# Linux | armv6l
	@ echo bcm2708 > soc.txt
	@chmod +x ${LINUX}
	@${LINUX}

rpi-image:
	# Make bootable image
	@ echo bcm2708 > soc.txt
	@chmod +x ${CHOOSE}
	@${CHOOSE}

rpi-all:
	# RPi | armv6l
	# - - - - - - - -
	#
	# Building linux
	@ echo bcm2708 > soc.txt
	@chmod +x ${LINUX}
	@${LINUX}
	# Creating ROOTFS tarball
	@chmod +x ${RFSV6}
	@${ROOTFSV6}
	# Making bootable img
	@ echo bcm2708 > soc.txt
	@chmod +x ${CHOOSE}
	@${CHOOSE}

# rootfs
rootfs:
	# ROOTFS
	@chmod +x ${RFSV8}
	@${ROOTFSV8}

rootfsv6:
	# ROOTFS
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
	@chmod go=rx files/scripts/*
	@chmod go=rx files/debian/scripts/*
	@chmod go=rx files/devuan/scripts/*
	@chmod go=rx files/ubuntu/scripts/*
	@chmod go=r files/misc/*
	@chmod go=r files/debian/misc/*
	@chmod go=r files/devuan/misc/*
	@chmod go=r files/ubuntu/misc/*
	@chmod go=r files/debian/rules/*
	@chmod go=r files/devuan/rules/*
	@chmod go=r files/ubuntu/rules/*
	@chmod go=r files/users/*
	@chmod +x ${CONF}
	@${CONF}

mlconfig:
	# User config menu
	@chmod go=rx files/scripts/*
	@chmod go=rx files/debian/scripts/*
	@chmod go=rx files/devuan/scripts/*
	@chmod go=rx files/ubuntu/scripts/*
	@chmod go=r files/misc/*
	@chmod go=r files/debian/misc/*
	@chmod go=r files/devuan/misc/*
	@chmod go=r files/ubuntu/misc/*
	@chmod go=r files/debian/rules/*
	@chmod go=r files/devuan/rules/*
	@chmod go=r files/ubuntu/rules/*
	@chmod go=r files/users/*
	@chmod +x ${MLCONF}
	@${MLCONF}

admin:
	# User config menu
	@chmod go=rx files/scripts/*
	@chmod go=rx files/debian/scripts/*
	@chmod go=rx files/devuan/scripts/*
	@chmod go=rx files/ubuntu/scripts/*
	@chmod go=r files/misc/*
	@chmod go=r files/debian/misc/*
	@chmod go=r files/devuan/misc/*
	@chmod go=r files/ubuntu/misc/*
	@chmod go=r files/debian/rules/*
	@chmod go=r files/devuan/rules/*
	@chmod go=r files/ubuntu/rules/*
	@chmod go=r files/users/*
	@chmod +x ${ADMIN}
	@${ADMIN}

dialogrc:
	# Builder theme set
	@${DIALOGRC}

# distros
debianos:
	# Debian
	@chmod +x ${DEB}
	@chmod +x ${DEBSTG2}
	@${DEBIAN}

devuanos:
	# Devuan
	@chmod +x ${DEV}
	@chmod +x ${DEVSTG2}
	@${DEVUAN}

ubuntuos:
	# UBuntu
	@chmod +x ${UBU}
	@chmod +x ${UBUSTG2}
	@${UBUNTU}

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
