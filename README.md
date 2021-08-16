<img src="https://socialify.git.ci/pyavitz/rpi-img-builder/image?description=1&font=KoHo&forks=1&issues=1&logo=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fde%2Fthumb%2Fc%2Fcb%2FRaspberry_Pi_Logo.svg%2F475px-Raspberry_Pi_Logo.svg.png&owner=1&pattern=Charlie%20Brown&stargazers=1&theme=Dark" alt="rpi-img-builder" width="640" height="320" />

## The boards and distributions that are currently supported
* Raspberry Pi 4B | Debian, Devuan and Ubuntu
* Raspberry Pi 3/A/B/+ | Debian, Devuan and Ubuntu
* Raspberry Pi 2B | Debian, Devuan and Ubuntu
* Raspberry Pi 0/W/B/+ | Debian and Devuan
* [Raspberry Pi Hardware](https://www.raspberrypi.org/documentation/hardware/raspberrypi)

## Dependencies for Ubuntu Focal / Hirsute Hippo

**Install options:**
* Run the `./install` script ***(recommended)***
* Run builder [make commands](https://github.com/pyavitz/rpi-img-builder#install-dependencies) (dependency: make)
* Review [package list](https://raw.githubusercontent.com/pyavitz/rpi-img-builder/master/lib/.package.list) and install manually

## Docker

To build using [Docker](https://www.docker.com/), follow the install [instructions](https://docs.docker.com/engine/install/) and use our other [builder](https://github.com/pyavitz/arm-img-builder).

---

## Instructions

#### Install dependencies

```sh
make ccompile	# Install x86-64 cross dependencies
make ccompile64	# Install Arm64 cross dependencies
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
Enable root:	# 1 to enable (set root password to `toor`)

Linux kernel
Branch:         # Supported: 5.10.y and above
Menuconfig:     # 1 to run kernel menuconfig
Crosscompile:   # 1 to cross compile | 0 to native compile

Compiler        WARNING: Only one may be selected
GCC:            # 1 to select (default)
Ccache:         # 1 to select
Clang:          # 1 to select

Distribution
Distro:		# Supported: debian, devuan and ubuntu
Release:	# Debian: buster, bullseye, testing, unstable and sid
		# Devuan: beowulf, testing, unstable and ceres
		# Ubuntu: focal and hirsute

Filesystem
ext4:		# 1 to select (default)
btrfs:		# 1 to select
xfs:		# 1 to select

Customize (user defconfig)
Defconfig:	# 1 to enable
Name:		# Name of _defconfig (Must be placed in defconfig dir.)
```

#### Mainline Config Menu (RPi4B ONLY)

```sh
Username:       # Your username
Password:       # Your password
Enable root:	# 1 to enable (set root password to `toor`)

Linux kernel
Branch:         # Selected kernel branch
RC:             # 1 for kernel x.y-rc above stable
Menuconfig:     # 1 to run kernel menuconfig
Crosscompile:   # 1 to cross compile | 0 to native compile

Compiler        WARNING: Only one may be selected
GCC:            # 1 to select (default)
Ccache:         # 1 to select
Clang:          # 1 to select

Distribution
Distro:		# Supported: debian, devuan and ubuntu
Release:	# Debian: buster, bullseye, testing, unstable and sid
		# Devuan: beowulf, testing, unstable and ceres
		# Ubuntu: focal and hirsute

Filesystem
ext4:		# 1 to select (default)
btrfs:		# 1 to select
xfs:		# 1 to select

Customize (user defconfig)
Defconfig:	# 1 to enable
Name:		# Name of _defconfig (Must be placed in defconfig dir.)
```

### Furthermore
If interested in building a Raspberry Pi 4B image that uses mainline u-boot and linux
use our other [builder](https://github.com/pyavitz/debian-image-builder).

#### Compiler options

```sh
nano userdata.txt
### COMPILER TUNING
CFLAGS=""
```
GCC flags: [fm4dd](https://gist.github.com/fm4dd/c663217935dc17f0fc73c9c81b0aa845) / [valvers](https://www.valvers.com/open-software/raspberry-pi/bare-metal-programming-in-c-part-1)

Clang flags: [#34](https://github.com/pyavitz/rpi-img-builder/issues/34)
```sh
### CLANG/LLVM
CLANG_LLVM="LLVM=1 LLVM_IAS=1"
lto_clang_thin=0	# 1 to enable (Arm64 only)
```

#### User defconfig

```sh
# config placement: defconfig/$NAME_defconfig
The config menu will append _defconfig to the end of the name
in the userdata.txt file.
```

#### User patches

```sh
Patches "-p1" placed in patches/userpatches are applied during
compilation. This works for both Foundation and Mainline kernels.
```
[CacULE CPU scheduler](https://github.com/hamadmarri/cacule-cpu-scheduler) [#30](https://github.com/pyavitz/rpi-img-builder/issues/30)
```sh
The CacULE CPU scheduler is a CFS patchset that is based on interactivity score mechanism.
The interactivity score is inspired by the ULE scheduler (FreeBSD scheduler). The goal of
this patch is to enhance system responsiveness/latency.
```

#### User scripts

```sh
nano userdata.txt
# place scripts in files/userscripts directory
userscripts=0	# 1 to enable
``` 

## Command list

#### Raspberry Pi 4B

```sh
# ARM64
make all	# kernel > rootfs > image (run at own risk)
make kernel	# Foundation
make mainline	# Mainline
make image
```

#### Raspberry Pi 3/A/B/+

```sh
# ARM64
make rpi3-all	# kernel > rootfs > image (run at own risk)
make rpi3-kernel
make rpi3-image
```

#### Raspberry Pi 2B

```sh
# ARMHF
make rpi2-all	# kernel > rootfs > image (run at own risk)
make rpi2-kernel
make rpi2-image
```

#### Raspberry Pi 0/0W/B/+

```sh
# ARMEL
make rpi-all	# kernel > rootfs > image (run at own risk)
make rpi-kernel
make rpi-image
```

#### Root Filesystems

```sh
make rootfs     # arm64
make rootfsv7   # armhf
make rootfsv6   # armel
```

#### Miscellaneous

```sh
make cleanup    # Clean up rootfs and image errors
make purge      # Remove source directory
make purge-all  # Remove source and output directory
make commands   # List more commands
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

### Scripts
#### Using deb-eeprom ([usb_storage.quirks](https://github.com/pyavitz/rpi-img-builder/issues/17))

```sh
Raspberry Pi 4B EEPROM Helper Script
Usage: deb-eeprom -h

   -U       Upgrade eeprom package
   -w       Transfer to USB	# Supported: EXT4, BTRFS and F2FS
   -u       Update script

Note:
Upon install please run 'deb-eeprom -u' before using this script.
```

#### Using fetch ([initrd support](https://github.com/pyavitz/rpi-img-builder/pull/26))
```sh
Fetch, Linux kernel installer for the Raspberry Pi Image Builder
Usage: fetch -h

   -1       Linux 5.10.y LTS
   -2       Linux Stable Branch
   -b       Update Boot Binaries
   -f       Update Wifi/BT Firmware
   -U       Update Raspberry Pi Userland

   -u       Update Fetch

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
Usage: governor -h

   -c       Conservative
   -o       Ondemand
   -p       Performance

   -r       Run
   -u       Update

A service runs 'governor -r' during boot.
```

#### Turn off leds (Debian / Ubuntu}
```
activity led
sudo systemctl enable actledoff
sudo systemctl start actledoff

power led
sudo systemctl enable pwrledoff
sudo systemctl start pwrledoff
```

#### Turn off leds (Devuan)
```
activity led
sudo update-rc.d actledoff defaults 2
sudo service actledoff start

power led
sudo update-rc.d pwrledoff defaults 2
sudo service pwrledoff start
```
---

### Support

Should you come across any bugs, feel free to either open an issue on GitHub or talk with us directly by joining our channel on Libera; [`#arm-img-builder`](irc://irc.libera.chat/#arm-img-builder)
