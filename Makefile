# menu
MENU=./lib/dialog/menu
CONF=./lib/dialog/config
DIALOGRC=$(shell cp -f lib/dialogrc ~/.dialogrc)

# rootfs
RFS=./scripts/rootfs
ROOTFS=sudo ./scripts/rootfs

# kernel
XLINUX=./scripts/rpi-linux
LINUX=sudo ./scripts/rpi-linux

# commit
XCOMMIT=./scripts/rpi-commit
COMMIT=sudo ./scripts/rpi-commit

# stages
STG1=./scripts/stage1
STG2=./scripts/stage2
IMAGE=sudo ./scripts/stage1

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

# boards
BOARDS=$(shell sudo cp lib/boards/${board} board.txt)

ifdef board
include lib/boards/${board}
endif

define build_kernel
	@${BOARDS}
	@chmod +x ${XLINUX}
	@${LINUX}
endef

define build_commit
	@${BOARDS}
	@chmod +x ${XCOMMIT}
	@${COMMIT}
endef

define build_image
	@${BOARDS}
	@chmod +x ${STG1}
	@chmod +x ${STG2}
	@${IMAGE}
endef

define create_rootfs
	@${BOARDS}
	@chmod +x ${RFS}
	@${ROOTFS}
endef

help:
	@echo
	@echo "\t\t\e[1;31mRaspberry Pi Image Builder\e[0m"
	@echo "\t\t\e[1;37m**************************"
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
	@echo "  bcm2710                 Raspberry Pi 2/3/A/B/W/+"
	@echo "  bcm2709                 Raspberry Pi 2/3/A/B/W/+"
	@echo "  bcm2708                 Raspberry Pi 0/W/B/+"
	@echo
	@echo "Usage:"
	@echo " "
	@echo "  make all board=XXX      Kernel > rootfs > image"
	@echo "  make kernel board=XXX   Builds linux kernel package"
	@echo "  make rootfs board=XXX   Create rootfs tarball"
	@echo "  make image board=XXX    Make bootable image"
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

# builder
kernel:
	# Compiling kernel
	$(call build_kernel)

commit:
	# Compiling kernel
	$(call build_commit)

image:
	# Creating image
	$(call build_image)

all:
	# Compiling kernel
	$(call build_kernel)
	# Creating ROOTFS tarball
	$(call create_rootfs)
	# Creating image
	$(call build_image)

# rootfs
rootfs:
	# ROOTFS
	$(call create_rootfs)

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
