<img src="https://socialify.git.ci/pyavitz/rpi-img-builder/image?description=1&font=KoHo&forks=1&issues=1&logo=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fde%2Fthumb%2Fc%2Fcb%2FRaspberry_Pi_Logo.svg%2F475px-Raspberry_Pi_Logo.svg.png&owner=1&pattern=Charlie%20Brown&stargazers=1&theme=Dark" alt="rpi-img-builder" width="640" height="320" />

## The boards and distributions that are currently supported
* **Raspberry Pi 4B/400** (*Debian, Devuan and Ubuntu*)
* **Raspberry Pi 3/A/B/+** (*Debian, Devuan and Ubuntu*)
* **Raspberry Pi 2/3/A/B/+** (*Debian, Devuan and Ubuntu*)
* **Raspberry Pi 0/W/B/+** (*Debian and Devuan*)
* [Raspberry Pi Hardware](https://www.raspberrypi.org/documentation/hardware/raspberrypi)

## Dependencies for Debian Bullseye and Ubuntu Jammy Jellyfish
* **Recommended host:** Debian Bullseye

**Install options:**
* Run the `./install` script ***(recommended)***
* Run builder [make commands](https://github.com/pyavitz/rpi-img-builder#install-dependencies) (dependency: make)
* Review [package list](https://raw.githubusercontent.com/pyavitz/rpi-img-builder/master/lib/.package.list) and install manually

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
make config     # Create user data file
make mlconfig	# Create user data file (Mainline)
make menu       # Open menu interface
make dialogrc   # Set builder theme (optional)
```

#### Config Menu
* Review the userdata.txt file for further options: locales, timezone, nameserver(s) and extra wireless support

```sh
Username:       # Your username
Password:       # Your password
Enable root:	# 1 to enable (set root password to `toor`)
```
* Foundation
```sh
Linux kernel
Branch:         # Supported: 5.15.y and above
```
* Mainline
```sh
Linux kernel
Branch:         # Selected kernel branch
RC:             # 1 for kernel x.y-rc above stable
```
```sh
Menuconfig:     # 1 to run kernel menuconfig
Crosscompile:   # 1 to cross compile | 0 to native compile

Compiler        WARNING: Only one may be selected
Version:        # Defaults at gcc-10
GCC:            # 1 to select (default)
Ccache:         # 1 to select
Clang:          # 1 to select (Supported: Jammy Jellyfish)

Distribution
Distro:		# Supported: debian, devuan and ubuntu
Release:	# Debian: bullseye, bookworm, testing, unstable and sid
		# Devuan: chimaera, daedalus, testing, unstable and ceres
		# Ubuntu: focal, impish and jammy

Filesystem
ext4:		# 1 to select (default)
btrfs:		# 1 to select
xfs:		# 1 to select

Customize (user defconfig)
Defconfig:	# 1 to enable
Name:		# Name of _defconfig (Must be placed in defconfig dir.)
```
#### Compiler options
* GCC flags: [fm4dd](https://gist.github.com/fm4dd/c663217935dc17f0fc73c9c81b0aa845) / [valvers](https://www.valvers.com/open-software/raspberry-pi/bare-metal-programming-in-c-part-1)
* Clang flags: [#34](https://github.com/pyavitz/rpi-img-builder/issues/34)

```sh
nano userdata.txt
### COMPILER TUNING
CORES=`nproc`
CFLAGS=""
```
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

#### User scripts

```sh
nano userdata.txt
# place scripts in files/userscripts directory
userscripts=0	# 1 to enable
``` 

## Command list

#### Raspberry Pi 4B/400 (ARM64)

```sh
make all	# kernel > rootfs > image (run at own risk)
make kernel	# Foundation
make mainline	# Mainline
make image
```

#### Raspberry Pi 4B/400 (ARMHF)

```sh
make allv7	# kernel > rootfs > image (run at own risk)
make kernelv7
make imagev7
```

#### Raspberry Pi 3/A/B/+ (ARM64)

```sh
make rpi3-all	# kernel > rootfs > image (run at own risk)
make rpi3-kernel
make rpi3-image
```

#### Raspberry Pi 2/3/A/B/+ (ARMHF)

```sh
make rpi2+3-all	# kernel > rootfs > image (run at own risk)
make rpi2+3-kernel
make rpi2+3-image
```

#### Raspberry Pi 0/0W/B/+ (ARMEL)

```sh
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

If you want use ethernet instead of wifi,
use command: 'swh -d' to disable wifi after booting to OS.
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
deb-eeprom -h

   -U       Upgrade eeprom package
   -w       Transfer to USB	# Supported: EXT4, BTRFS and F2FS
   -u       Update script

Note:
Upon install please run 'deb-eeprom -u' before using this script.
```

#### Using fetch ([initrd support](https://github.com/pyavitz/rpi-img-builder/pull/26))
```sh
Fetch, Linux kernel installer for the Raspberry Pi Image Builder
fetch -h

   -1       Linux 5.15.y LTS
   -2       Linux Stable Branch
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
governor -h

   -c       Conservative
   -o       Ondemand
   -p       Performance
   -s       Schedutil

   -r       Run
   -u       Update

A service runs 'governor -r' during boot.
```

#### Disable LED service
```
# Debian / Ubuntu
sudo systemctl stop leds
sudo systemctl disable leds

# Devuan
sudo update-rc.d -f leds remove
```

---

### Support

Should you come across any bugs, feel free to either open an issue on GitHub or talk with us directly by joining our channel on Libera; [`#arm-img-builder`](irc://irc.libera.chat/#arm-img-builder) or [Discord](https://discord.gg/53Ny5pFQ)
