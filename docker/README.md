# Docker container to build images

# docker-compose --compatibility up -d --build
# docker exec -it arm-image-builder /bin/bash
# At this point your root in the host system and can work like in a just normal linux system

# rpi image builder is located at /rpi | its also possible to "git pull"
# debian image builder is located at /debian

# to get your builded image to the host system just use this command:
# docker cp arm-image-builder:/path-where-the-images-is-located

##Instructions##

##Install dependencies##

make ccompile	# Install all dependencies
make ncompile	# Install native dependencies

##Menu interface##
make config     # Create user data file (Foundation Kernel)
make mlconfig   # Create user data file (Mainline Kernel)
make menu       # Open menu interface
make dialogrc   # Set builder theme (optional)

##Config Menu##
Username:       # Your username
Password:       # Your password

##Linux kernel##
Branch:         # Supported: 5.4.y and above
Menuconfig:     # 1 to run kernel menuconfig
Crosscompile:   # 1 to cross compile | 0 to native compile

##Distributions##
Release:	# Supported: buster, beowulf and 20.04
Debian:		# 1 to select (buster/bullseye/testing/unstable/sid)
Devuan:		# 1 to select (beowulf/testing/unstable/ceres)
Ubuntu:		# 1 to select (20.04/20.04.1/20.10)

##Wireless##
rtl88XXau:      # 1 to add Realtek 8812AU/14AU/21AU wireless support
rtl88XXbu:      # 1 to add Realtek 88X2BU wireless support
rtl88XXcu:      # 1 to add Realtek 8811CU/21CU wireless support
Mainline Config Menu (RPi4B ONLY)
Username:       # Your username
Password:       # Your password

##Linux kernel##
Branch:         # Selected kernel branch
Mainline:       # 1 for kernel x.y-rc above stable
Menuconfig:     # 1 to run kernel menuconfig
Crosscompile:   # 1 to cross compile | 0 to native compile

##Distributions##
Release:	# Supported: buster, beowulf and 20.04
Debian:		# 1 to select (buster/unstable)
Devuan:		# 1 to select (beowulf/testing)
Ubuntu:		# 1 to select (20.04)

##Wireless##
rtl88XXau:      # 1 to add Realtek 8812AU/14AU/21AU wireless support
rtl88XXbu:      # 1 to add Realtek 88X2BU wireless support
rtl88XXcu:      # 1 to add Realtek 8811CU/21CU wireless support

##User defconfig##
nano userdata.txt
# place config in defconfig directory
custom_defconfig=1
MYCONFIG="nameofyour_defconfig"

##User patches##
Patches "-p1" placed in patches/userpatches are applied during
compilation. This works for both Foundation and Mainline kernels.
Command list

##Raspberry Pi 4B##
# AARCH64
make kernel	# Foundation
make mainline	# Mainline
make image
make all

##Raspberry Pi 3A/B/+##
# AARCH64
make rpi3-kernel
make rpi3-image
make rpi3-all
Raspberry Pi 0/0W/B/+

# ARMv6l
make rpi-kernel
make rpi-image
make rpi-all
Root Filesystems
make rootfs   # arm64
make rootfsv6 # armel

##Miscellaneous##
make cleanup    # Clean up image errors
make purge      # Remove source directory
make purge-all  # Remove source and output directory
make commands   # List legacy commands
make helper     # Download a binary Linux package

Credits and more infos at this repo:

https://github.com/pyavitz/rpi-img-builder
