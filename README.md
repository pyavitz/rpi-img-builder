<img src="https://socialify.git.ci/pyavitz/rpi-img-builder/image?description=1&font=KoHo&forks=1&issues=1&logo=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fde%2Fthumb%2Fc%2Fcb%2FRaspberry_Pi_Logo.svg%2F475px-Raspberry_Pi_Logo.svg.png&owner=1&pattern=Charlie%20Brown&stargazers=1&theme=Dark" alt="rpi-img-builder" width="640" height="320" />

## The boards and distributions that are currently supported
* Raspberry Pi 4B | Debian, Devuan and Ubuntu
* Raspberry Pi 2/3/A/B/+ | Debian, Devuan and Ubuntu
* Raspberry Pi 0/W/B/+ | Debian and Devuan
* [Raspberry Pi Hardware](https://www.raspberrypi.org/documentation/hardware/raspberrypi)

## Dependencies

In order to install the required dependencies, run the following command:

```
sudo apt install \
	build-essential bison bc git dialog patch dosfstools zip unzip qemu debootstrap \
	qemu-user-static rsync kmod cpio flex libssl-dev libncurses5-dev parted fakeroot \
	swig aria2 pv toilet figlet distro-info-data lsb-release xz-utils curl e2fsprogs \
	btrfs-progs kpartx crossbuild-essential-arm64 crossbuild-essential-armel gcc-8 \
	gcc-8-arm-linux-gnueabi gcc-9-arm-linux-gnueabi gcc-10-arm-linux-gnueabi gcc-9 \
	gcc-8-aarch64-linux-gnu gcc-9-aarch64-linux-gnu gcc-10-aarch64-linux-gnu gcc-10 \
	debian-archive-keyring debian-keyring make
```

This has been tested on an AMD64/x86_64 system running on [Ubuntu Focal](https://releases.ubuntu.com/20.04/).

Alternatively, you can run the command `make ccompile` in this directory.

## Docker

To build using [Docker](https://www.docker.com/), follow the install [instructions](https://docs.docker.com/engine/install/) and use our other [builder](https://github.com/pyavitz/arm-img-builder).

---

## Instructions

#### Install dependencies

```sh
make ccompile	# Install all dependencies
make ncompile	# Install native dependencies
```

#### Menu interface

```sh
make config     # Create user data file (Foundation Kernel)
make mlconfig   # Create user data file (Mainline Kernel)
make menu       # Open menu interface
make dialogrc   # Set builder theme (optional)
```

#### Config Menu

```sh
Username:       # Your username
Password:       # Your password

Linux kernel
Branch:         # Supported: 5.10.y and above
Menuconfig:     # 1 to run kernel menuconfig
Crosscompile:   # 1 to cross compile | 0 to native compile

Distributions
Release:	# Supported: buster, beowulf and 20.04.2
Debian:		# 1 to select (buster/bullseye/testing/unstable/sid)
Devuan:		# 1 to select (beowulf/testing/unstable/ceres)
Ubuntu:		# 1 to select (20.04.1/20.04.2/20.10)

Filesystem
ext4:		# 1 to select (default)
btrfs:		# 1 to select
```

#### Mainline Config Menu (RPi4B ONLY)

```sh
Username:       # Your username
Password:       # Your password

Linux kernel
Branch:         # Selected kernel branch
Mainline:       # 1 for kernel x.y-rc above stable
Menuconfig:     # 1 to run kernel menuconfig
Crosscompile:   # 1 to cross compile | 0 to native compile

Distributions
Release:	# Supported: buster, beowulf and 20.04.2
Debian:		# 1 to select (buster/bullseye/testing/unstable/sid)
Devuan:		# 1 to select (beowulf/testing/unstable/ceres)
Ubuntu:		# 1 to select (20.04.1/20.04.2/20.10)

Filesystem
ext4:		# 1 to select (default)
btrfs:		# 1 to select
```

### Furthermore
If interested in building a Raspberry Pi 4B image that uses mainline u-boot and linux
use our other [builder](https://github.com/pyavitz/debian-image-builder).

#### User defconfig

```sh
nano userdata.txt
# place config in defconfig directory
custom_defconfig=1
MYCONFIG="nameofyour_defconfig"
```

#### User patches

```sh
Patches "-p1" placed in patches/userpatches are applied during
compilation. This works for both Foundation and Mainline kernels.
```

#### User scripts
```sh
nano userdata.txt
# place scripts in files/userscripts directory
userscripts=0	# 1 to enable | 0 to disable	
``` 

## Command list

#### Raspberry Pi 4B

```sh
# AARCH64
make all	# kernel > rootfs > image (run at own risk)
make kernel	# Foundation
make mainline	# Mainline
make image
```

#### Raspberry Pi 2/3/A/B/+

```sh
# AARCH64
make rpi3-all	# kernel > rootfs > image (run at own risk)
make rpi3-kernel
make rpi3-image
```

#### Raspberry Pi 0/0W/B/+

```sh
# ARMv6l
make rpi-all	# kernel > rootfs > image (run at own risk)
make rpi-kernel
make rpi-image
```

#### Root Filesystems

```sh
make rootfs   # arm64
make rootfsv6 # armel
```

#### Miscellaneous

```sh
make cleanup    # Clean up image errors
make purge      # Remove source directory
make purge-all  # Remove source and output directory
make commands   # List legacy commands
make helper     # Download a binary Linux package
make check      # Shows latest revision of selected branch
```

## Usage

### Debian / Devuan
#### /boot/rename_to_credentials.txt
```sh
Rename file to credentials.txt and input your wifi information.

SSID=" "			# Service set identifier
PASSKEY=" "			# Wifi password
COUNTRYCODE=" "			# Your country code

# set static ip
MANUAL=n			# Set to y to enable a static ip
IPADDR=" "			# Static ip address
NETMASK=" "			# Your Netmask
GATEWAY=" "			# Your Gateway
NAMESERVERS=" "			# Your preferred dns

CHANGE=y			# Set to n to disable
HOSTNAME="raspberrypi"		# Set the system's host name
BRANDING="Raspberry Pi"		# Set ASCII text banner

For headless use: ssh user@ipaddress

Note:
You can also mount the ROOTFS partition and edit the following
files, whilst leaving rename_to_credentials.txt untouched.

/etc/opt/interfaces.manual
/etc/opt/wpa_supplicant.manual
```

### Ubuntu
#### /boot/rename_to_credentials.txt
```sh
Rename file to credentials.txt and input your wifi information.

NAME=" "			# Name of the connection
SSID=" "			# Service set identifier
PASSKEY=" "			# Wifi password
COUNTRYCODE=" "			# Your country code

MANUAL=n			# Set to y to enable a static ip
IPADDR=" "			# Static ip address
GATEWAY=" "			# Your Gateway
DNS=""				# Your preferred dns

CHANGE=y			# Set to n to disable
HOSTNAME="raspberrypi"		# Set the system's host name
BRANDING="Raspberry Pi"		# Set ASCII text banner

For headless use: ssh user@ipaddress
```

#### Using deb-eeprom ([usb_storage.quirks](https://github.com/pyavitz/rpi-img-builder/issues/17))

```sh
Raspberry Pi 4B EEPROM Helper Script
Usage: deb-eeprom -opt

   -v       Edit version variable
   -U       Upgrade eeprom package
   -w       Setup and install usb boot
   -u       Update script

Note:
Upon install please run 'deb-eeprom -u' before using this script.
```

#### Using fetch ([initrd support](https://github.com/pyavitz/rpi-img-builder/pull/26))
```sh
Fetch, Linux kernel installer for the Raspberry Pi Image Builder
Usage: fetch -opt

   -1       Linux 5.10.y LTS
   -2       Linux Stable Branch
   -3       Linux Mainline Branch
   -4       Update Boot Binaries

   -u       Update Fetch
   -s       Not working? Setup Fetch

fetch -u will list available options and kernel revisions
```
#### Simple wifi helper (Debian / Devuan)
```sh
swh -h

   -s       Scan for SSID's
   -u       Bring up interface
   -d       Bring down interface
   -r       Restart interface
   -W       Edit wpa supplicant
   -I       Edit interfaces
```
#### CPU frequency scaling
```sh
Usage: governor -opt

   -c       Conservative
   -o       Ondemand
   -p       Performance

   -r       Run
   -u       Update

A service runs 'governor -r' during boot.
```

---

### Support

Should you come across any bugs, feel free to either open an issue on GitHub or talk with us directly by joining our channel on Freenode; [`#debianarm-port`](irc://irc.freenode.net/#debianarm-port)
