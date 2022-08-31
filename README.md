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
make menu       # Open menu interface
make dialogrc   # Set builder theme (optional)
```

#### Command list
* Raspberry Pi 4B/400 = bcm2711 (arm64) / bcm2711v7 (armhf)
* Raspberry Pi 2/3/A/B/W/+ = bcm2710 (arm64) / bcm2709 (armhf)
* Raspberry Pi 0/1/W = bcm2708 (armel)

```sh
make all board=XXX	# Kernel > Rootfs > Image (run at own risk)
make kernel board=XXX
make commit board=XXX	# Linux source pulled from commmit
make rootfs board=XXX
make image board=XXX
```

#### Miscellaneous

```sh
make cleanup    # Clean up rootfs and image errors
make purge      # Remove source directory
make purge-all  # Remove source and output directory
make commands   # List more commands
make check      # Shows latest revision of selected branch
```

#### Config Menu
* Review the userdata.txt file for further options: locales, timezone, nameserver(s) and extra wireless support
* 1 active | 0 inactive
```sh
Name:			# Your name
Username:		# Your username
Password:		# Your password
Enable root:		# Set root password to `toor`

Linux kernel
Branch:			# Supported: 5.15.y and above
Build:			# Kernel build version number
Menuconfig:		# Kernel menuconfig
Crosscompile:		# 1 to cross compile | 0 to native compile

Compiler        	WARNING: Only one may be selected
Version:		# gcc-10 (default)
GCC:			#
Ccache:			#
Clang:			# Supported: Jammy Jellyfish

Distribution
Distro:			# Supported: debian, devuan and ubuntu
Release:		# Debian: bullseye, bookworm, testing, unstable and sid
			# Devuan: chimaera, daedalus, testing, unstable and ceres
			# Ubuntu: focal and jammy
Network Manager		# Enable nmtui (default: ifupdown)

Filesystem
ext4:			# Journaling filesystem (default)
btrfs:			# Copy on write (CoW) filesystem
xfs:			# High-performance 64-bit journaling filesystem

Customize
Defconfig:		# User defconfig
Name:			# Name of _defconfig (Must be placed in defconfig dir.)

User options
Verbosity:		# Verbose
Devel Rootfs:		# Developer rootfs tarball
Compress img:		# Auto compress img > img.xz
User scripts:		# Review the README in the files/userscripts directory
User service:		# Create user during first boot (bypass the user information above)
```
#### User defconfig

```sh
# config placement: defconfig/$NAME_defconfig
The config menu will append _defconfig to the end of the name
in the userdata.txt file.
```

#### User patches

```sh
Patches "-p1" placed in userpatches are applied during compilation.
```

## Usage
* Review the [Wiki](https://github.com/pyavitz/rpi-img-builder/wiki/Options-&-Scripts)
#### /boot/rename_to_useraccount.txt
* Headless: rename file to useraccount.txt and fill in the variables
* Headful: don't rename file & get prompted to create a user account
```sh
NAME=""
USERNAME=""
PASSWORD=""
```

#### /boot/rename_to_credentials.txt
```sh
Rename file to credentials.txt and input your wifi information.

SSID=""				# Service set identifier
PASSKEY=""			# Wifi password
COUNTRYCODE=""			# Your country code

# set static ip (ifupdown)
MANUAL="n"			# Set to y to enable a static ip
IPADDR=""			# Static ip address
NETMASK=""			# Your Netmask
GATEWAY=""			# Your Gateway
NAMESERVERS=""			# Your preferred dns

# set static ip (network-manager)
MANUAL="n"			# Set to y to enable a static ip
IPADDR=""			# Static ip address
GATEWAY=""			# Your Gateway
DNS=""				# Your preferred dns

For headless use: ssh user@ipaddress
```

#### System Menu: `menu-config`
<img src="https://i.imgur.com/g6vPI8t.png" alt="Main Menu" />

---

## Support

Should you come across any bugs, feel free to either open an issue on GitHub or talk with us directly by joining our channel on Libera; [`#arm-img-builder`](irc://irc.libera.chat/#arm-img-builder) or [Discord](https://discord.gg/mypJ7NW8BG)
