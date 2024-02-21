# header
HEADER=./scripts/.header

# menu
MENU=./lib/dialog/menu
CONF=./lib/dialog/config
DIALOGRC=$(shell cp -f lib/dialog/dialogrc ~/.dialogrc)

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
PURGE=$(shell sudo rm -fdr source; if [ -d .cache ]; then sudo rm -f .cache/git_fast.*; fi)
PURGEALL=$(shell sudo rm -fdr source output; if [ -d .cache ]; then sudo rm -f .cache/git_fast.*; fi)

# miscellaneous
XCHECK=./scripts/check
CHECK=./scripts/check
XCOMP=./scripts/compress
COMP=sudo ./scripts/compress

# dependencies
CCOMPILE=./scripts/.ccompile
CCOMPILE64=./scripts/.ccompile64
NCOMPILE=./scripts/.ncompile

# boards
BOARDS=$(shell sudo rm -f board.txt; if [ -f lib/boards/${board} ]; then sudo cp lib/boards/${board} board.txt; fi)

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
	@echo ""
	@${HEADER}
	@echo ""
	@echo "\e[1;37mCommands:\e[0m"
	@echo "   make ccompile\t\tInstall x86-64 cross dependencies"
	@echo "   make ccompile64\t\tInstall Arm64 cross dependencies"
	@echo "   make ncompile\t\tInstall native dependencies"
	@echo "   make config\t\t\tCreate user data file"
	@echo "   make menu\t\t\tUser menu interface"
	@echo "   make cleanup\t\t\tClean up rootfs and image errors"
	@echo "   make purge\t\t\tRemove source directory"
	@echo "   make purge-all\t\tRemove source and output directory"
	@echo "   make dialogrc\t\tSet builder theme"
	@echo "   make check\t\t\tLatest revision of selected branch"
	@echo ""
	@echo "   make list\t\t\tList boards"
	@echo "   make all board=xxx\t\tKernel > rootfs > image"
	@echo "   make kernel board=xxx\tBuilds linux kernel package"
	@echo "   make commit board=xxx\tBuilds linux kernel package"
	@echo "   make rootfs board=xxx\tCreate rootfs tarball"
	@echo "   make image board=xxx\t\tMake bootable image"
	@echo ""

# make commands
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

kernel:
	@rm -f override.txt
# userdata dot txt
ifdef build
	@$(shell sed -i "s/^BUILD_VERSION=.*/BUILD_VERSION="'"${build}"'"/" userdata.txt)
endif
ifdef menuconfig
	@$(shell sed -i "s/^MENUCONFIG=.*/MENUCONFIG="'"${menuconfig}"'"/" userdata.txt)
endif
ifdef myconfig
	@$(shell sed -i "s/^CUSTOM_DEFCONFIG=.*/CUSTOM_DEFCONFIG="'"1"'"/" userdata.txt)
	@$(shell sed -i "s/^MYCONFIG=.*/MYCONFIG="'"${myconfig}_defconfig"'"/" userdata.txt)
endif
ifdef version
	@$(shell sed -i "s/^VERSION=.*/VERSION="'"${version}"'"/" userdata.txt)
endif
# architecture
ifdef arch
	@echo 'ARCH_EXT="$(arch)"' > override.txt
endif
	# Compiling kernel
	$(call build_kernel)

commit:
	# Compiling kernel
	$(call build_commit)

image:
	@rm -f override.txt
# distro and release
ifdef distro
	@$(shell sed -i "s/^DISTRO=.*/DISTRO="'"${distro}"'"/" userdata.txt)
endif
ifdef release
	@$(shell sed -i "s/^DISTRO_VERSION=.*/DISTRO_VERSION="'"${release}"'"/" userdata.txt)
endif
# architecture
ifdef arch
	@echo 'ARCH_EXT="$(arch)"' > override.txt
endif
	# Creating image
	$(call build_image)

all:
	# Compiling kernel
	$(call build_kernel)
	# Creating ROOTFS tarball
	$(call create_rootfs)
	# Creating image
	$(call build_image)

# root filesystem
rootfs:
	@rm -f override.txt
# distro and release
ifdef distro
	@$(shell sed -i "s/^DISTRO=.*/DISTRO="'"${distro}"'"/" userdata.txt)
endif
ifdef release
	@$(shell sed -i "s/^DISTRO_VERSION=.*/DISTRO_VERSION="'"${release}"'"/" userdata.txt)
endif
# architecture
ifdef arch
	@echo 'ARCH_EXT="$(arch)"' > override.txt
endif
	# Root Filesystem
	$(call create_rootfs)

# LIST BOARDS
list:
	# Boards
	@cat lib/boards/* | grep -w "PRETTY_BOARD=" | sed 's/PRETTY_BOARD=//g' | sed 's/"//g' | sed 's/BCM/bcm/g' | sed 's/bcm2711 \/ ARMHF/bcm2711v7 \/ ARMHF/g'

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

# userdata reset
reset:
	# Resetting userdata.txt file
	@$(shell sed -i "s/^BUILD_VERSION=.*/BUILD_VERSION="'"1"'"/" userdata.txt)
	@$(shell sed -i "s/^MENUCONFIG=.*/MENUCONFIG="'"0"'"/" userdata.txt)
	@$(shell sed -i "s/^CUSTOM_DEFCONFIG=.*/CUSTOM_DEFCONFIG="'"0"'"/" userdata.txt)
	@$(shell sed -i "s/^MYCONFIG=.*/MYCONFIG="'"_defconfig"'"/" userdata.txt)

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
	@chmod go=rx files/inits/*
	@chmod go=rx files/scripts/*
	@chmod go=r files/misc/*
	@chmod go=r files/users/*
	@chmod +x ${CONF}
	@${CONF}
