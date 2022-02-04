# menu
MENU=./lib/dialog/menu
CONF=./lib/dialog/config
MLCONF=./lib/dialog/mlconfig
ADMIN=./lib/dialog/admin
DIALOGRC=$(shell cp -f lib/dialogrc ~/.dialogrc)

# rootfs
RFSV8=./scripts/rootfs
ROOTFSV8=sudo ./scripts/rootfs
RFSV7=./scripts/rootfs
ROOTFSV7=sudo ./scripts/rootfs
RFSV6=./scripts/rootfs
ROOTFSV6=sudo ./scripts/rootfs

# kernel
SELECT=./scripts/select
XLINUX=./scripts/rpi-linux
LINUX=sudo ./scripts/rpi-linux
XMAINLINE=./scripts/linux
MAINLINE=sudo ./scripts/linux

# commit
XCOMMIT=./scripts/rpi-commit
COMMIT=sudo ./scripts/rpi-commit

# stages
STG1=./scripts/stage1
STG2=./scripts/stage2
STAGE=sudo ./scripts/stage1

# clean
CLN=./scripts/clean
CLEAN=sudo ./scripts/clean

# purge
PURGE=$(shell sudo rm -fdr source)
PURGEALL=$(shell sudo rm -fdr source output)

# miscellaneous
XCHECK=./scripts/check
CHECK=./scripts/check
XRUN=./scripts/run-linux
RUN=./scripts/run-linux
XCOMP=./scripts/compress
COMP=sudo ./scripts/compress

# dependencies
CCOMPILE=./scripts/.ccompile
CCOMPILE64=./scripts/.ccompile64
NCOMPILE=./scripts/.ncompile

help:
	@echo
	@echo "\e[1;31m             Raspberry Pi Image Builder\e[0m"
	@echo "\e[1;37m             **************************"
	@echo "\e[1;37mUsage:\e[0m "
	@echo
	@echo "  make ccompile          Install x86-64 cross dependencies"
	@echo "  make ccompile64        Install Arm64 cross dependencies"
	@echo "  make ncompile          Install native dependencies"
	@echo "  make config            Create user data file"
	@echo "  make menu              User menu interface"
	@echo "  make cleanup           Clean up rootfs and image errors"
	@echo "  make purge             Remove source directory"
	@echo "  make purge-all         Remove source and output directory"
	@echo "  make commands          List more commands"
	@echo
	@echo "For details consult the \e[1;37mREADME.md\e[0m"
	@echo

commands:
	@echo
	@echo "Boards:"
	@echo
	@echo "  bcm2711                 Raspberry Pi 4B/400"
	@echo "  bcm2710                 Raspberry Pi 3/A/B/+"
	@echo "  bcm2709                 Raspberry Pi 2B"
	@echo "  bcm2708                 Raspberry Pi 0/W/B/+"
	@echo
	@echo "bcm2711:"
	@echo " "
	@echo "  make kernel             Builds linux kernel"
	@echo "  make image              Make bootable image"
	@echo "  make all                Kernel > rootfs > image"
	@echo
	@echo "bcm2711v7:"
	@echo " "
	@echo "  make kernelv7           Builds linux kernel"
	@echo "  make imagev7            Make bootable image"
	@echo "  make allv7              Kernel > rootfs > image"
	@echo
	@echo "bcm2710:"
	@echo " "
	@echo "  make rpi3-kernel        Builds linux kernel"
	@echo "  make rpi3-image         Make bootable image"
	@echo "  make rpi3-all           Kernel > rootfs > image"
	@echo
	@echo "bcm2709:"
	@echo " "
	@echo "  make rpi2+3-kernel      Builds linux kernel"
	@echo "  make rpi2+3-image       Make bootable image"
	@echo "  make rpi2+3-all         Kernel > rootfs > image"
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
	@echo "  make rootfsv7		  armhf"
	@echo "  make rootfsv6		  armel"
	@echo
	@echo "Miscellaneous:"
	@echo
	@echo "  make dialogrc		  Set builder theme"
	@echo "  make check		  Shows latest revision of selected branch"
	@echo

ccompile:
	# Installing x86_64 cross dependencies:
	@chmod +x ${CCOMPILE}
	@${CCOMPILE}
	
ccompile64:
	# Installing arm64 cross dependencies:
	@chmod +x ${CCOMPILE64}
	@${CCOMPILE64}

ncompile:
	# Installing native dependencies:
	@chmod +x ${NCOMPILE}
	@${NCOMPILE}

# Raspberry Pi 4
kernel:
	# Linux
	@ echo bcm2711 > soc.txt
	@ echo arm64 >> soc.txt
	@chmod +x ${XLINUX}
	@${LINUX}

commit:
	# Linux commit
	@ echo bcm2711 > soc.txt
	@ echo arm64 >> soc.txt
	@chmod +x ${XCOMMIT}
	@${COMMIT}

image:
	# Making bootable image
	@ echo bcm2711 > soc.txt
	@ echo arm64 >> soc.txt
	@chmod +x ${STG1}
	@chmod +x ${STG2}
	@${STAGE}

all:
	# Raspberry Pi 4
	@ echo bcm2711 > soc.txt
	@ echo arm64 >> soc.txt
	@chmod +x ${SELECT}
	@${SELECT}
	# Creating ROOTFS tarball
	@ echo ROOTFS_ARCH='"'rootfs-aarch64'"' > soc.txt
	@chmod +x ${RFSV8}
	@${ROOTFSV8}
	# Making bootable image
	@ echo bcm2711 > soc.txt
	@ echo arm64 >> soc.txt
	@chmod +x ${STG1}
	@chmod +x ${STG2}
	@${STAGE}

kernelv7:
	# Linux
	@ echo bcm2711 > soc.txt
	@ echo arm >> soc.txt
	@chmod +x ${XLINUX}
	@${LINUX}

commitv7:
	# Linux commit
	@ echo bcm2711 > soc.txt
	@ echo arm >> soc.txt
	@chmod +x ${XCOMMIT}
	@${COMMIT}

imagev7:
	# Making bootable image
	@ echo bcm2711 > soc.txt
	@ echo arm >> soc.txt
	@chmod +x ${STG1}
	@chmod +x ${STG2}
	@${STAGE}

allv7:
	# Raspberry Pi 4
	@ echo bcm2711 > soc.txt
	@ echo arm >> soc.txt
	@chmod +x ${SELECT}
	@${SELECT}
	# Creating ROOTFS tarball
	@ echo ROOTFS_ARCH='"'rootfs-armhf'"' > soc.txt
	@chmod +x ${RFSV7}
	@${ROOTFSV7}
	# Making bootable image
	@ echo bcm2711 > soc.txt
	@ echo arm >> soc.txt
	@chmod +x ${STG1}
	@chmod +x ${STG2}
	@${STAGE}

mainline:
	# Mainline Linux
	@ echo bcm2711 > soc.txt
	@ echo arm64 >> soc.txt
	@chmod +x ${XMAINLINE}
	@${MAINLINE}

# Raspberry Pi 3
rpi3-kernel:
	# Linux
	@ echo bcm2710 > soc.txt
	@ echo arm64 >> soc.txt
	@chmod +x ${XLINUX}
	@${LINUX}

rpi3-commit:
	# Linux commit
	@ echo bcm2710 > soc.txt
	@ echo arm64 >> soc.txt
	@chmod +x ${XCOMMIT}
	@${COMMIT}

rpi3-image:
	# Making bootable image
	@ echo bcm2710 > soc.txt
	@ echo arm64 >> soc.txt
	@chmod +x ${STG1}
	@chmod +x ${STG2}
	@${STAGE}

rpi3-all:
	# Raspberry Pi 3
	@ echo bcm2710 > soc.txt
	@ echo arm64 >> soc.txt
	@chmod +x ${XLINUX}
	@${LINUX}
	# Creating ROOTFS tarball
	@ echo ROOTFS_ARCH='"'rootfs-aarch64'"' > soc.txt
	@chmod +x ${RFSV8}
	@${ROOTFSV8}
	# Making bootable image
	@ echo bcm2710 > soc.txt
	@ echo arm64 >> soc.txt
	@chmod +x ${STG1}
	@chmod +x ${STG2}
	@${STAGE}
	
# Raspberry Pi 2+3
rpi2+3-kernel:
	# Linux
	@ echo bcm2709 > soc.txt
	@ echo arm >> soc.txt
	@chmod +x ${XLINUX}
	@${LINUX}

rpi2+3-commit:
	# Linux commit
	@ echo bcm2709 > soc.txt
	@ echo arm >> soc.txt
	@chmod +x ${XCOMMIT}
	@${COMMIT}

rpi2+3-image:
	# Making bootable image
	@ echo bcm2709 > soc.txt
	@ echo arm >> soc.txt
	@chmod +x ${STG1}
	@chmod +x ${STG2}
	@${STAGE}

rpi2+3-all:
	# Raspberry Pi 2+3
	@ echo bcm2709 > soc.txt
	@ echo arm >> soc.txt
	@chmod +x ${XLINUX}
	@${LINUX}
	# Creating ROOTFS tarball
	@ echo ROOTFS_ARCH='"'rootfs-armhf'"' > soc.txt
	@chmod +x ${RFSV7}
	@${ROOTFSV7}
	# Making bootable image
	@ echo bcm2709 > soc.txt
	@ echo arm >> soc.txt
	@chmod +x ${STG1}
	@chmod +x ${STG2}
	@${STAGE}

# Raspberry Pi
rpi-kernel:
	# Linux
	@ echo bcm2708 > soc.txt
	@ echo arm >> soc.txt
	@chmod +x ${XLINUX}
	@${LINUX}

rpi-commit:
	# Linux commit
	@ echo bcm2708 > soc.txt
	@ echo arm >> soc.txt
	@chmod +x ${XCOMMIT}
	@${COMMIT}

rpi-image:
	# Make bootable image
	@ echo bcm2708 > soc.txt
	@ echo arm >> soc.txt
	@chmod +x ${STG1}
	@chmod +x ${STG2}
	@${STAGE}

rpi-all:
	# Raspberry Pi
	@ echo bcm2708 > soc.txt
	@ echo arm >> soc.txt
	@chmod +x ${XLINUX}
	@${LINUX}
	# Creating ROOTFS tarball
	@ echo ROOTFS_ARCH='"'rootfs-armel'"' > soc.txt
	@chmod +x ${RFSV6}
	@${ROOTFSV6}
	# Making bootable img
	@ echo bcm2708 > soc.txt
	@ echo arm >> soc.txt
	@chmod +x ${STG1}
	@chmod +x ${STG2}
	@${STAGE}

# rootfs
rootfs:
	# ROOTFS
	@ echo ROOTFS_ARCH='"'rootfs-aarch64'"' > soc.txt
	@chmod +x ${RFSV8}
	@${ROOTFSV8}
	
rootfsv7:
	# ROOTFS
	@ echo ROOTFS_ARCH='"'rootfs-armhf'"' > soc.txt
	@chmod +x ${RFSV7}
	@${ROOTFSV7}

rootfsv6:
	# ROOTFS
	@ echo ROOTFS_ARCH='"'rootfs-armel'"' > soc.txt
	@chmod +x ${RFSV6}
	@${ROOTFSV6}

# clean and purge
cleanup:
	# Cleaning up
	@chmod +x ${CLN}
	@${CLEAN}

purge:
	# Removing source directory
	@${PURGE}

purge-all:
	# Removing source and output directory
	@${PURGEALL}

# miscellaneous
dialogrc:
	# Builder theme set
	@${DIALOGRC}

check:
	# Check kernel revisions
	@chmod +x ${XCHECK}
	@${CHECK}

# raspberry pi4 select
select:
	# Selecting kernel
	@chmod +x ${SELECT}
	@${SELECT}

# kernel run
run:
	@chmod +x ${XRUN}
	@${RUN}

compress:
	@chmod +x ${XCOMP}
	@${COMP}

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
	@chmod go=r files/users/*
	@chmod +x ${ADMIN}
	@${ADMIN}
