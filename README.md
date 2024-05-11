<details>
<summary><h3>Boards</h3></summary>

```py
Raspberry Pi Zero/W/1			bcm2708 / ARMEL
Raspberry Pi ZeroW2/2/3			bcm2709 / ARMHF
Raspberry Pi ZeroW2/3			bcm2710 / ARM64
Raspberry Pi ZeroW2/3/4/400/5		bcm2711 / ARM64
Raspberry Pi 4/400			bcm2711v7 / ARMHF
Raspberry Pi 5				bcm2712 / ARM64
```
</details>

* [Raspberry Pi Hardware](https://www.raspberrypi.org/documentation/hardware/raspberrypi)
* [The config dot txt](https://www.raspberrypi.com/documentation/computers/config_txt.html#what-is-config-txt)

### Host dependencies for Debian Bookworm and Ubuntu Jammy Jellyfish / Noble Numbat
* **Debian Bookworm** (testing)
* **Ubuntu Jammy Jellyfish** (recommended)
* **Ubuntu Noble Numbat** (recommended)

**Install options:**
* Run the `./install.sh` script ***(recommended)***
* Run builder [make commands](https://github.com/pyavitz/rpi-img-builder#install-dependencies) (dependency: make)

---

### Instructions
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

```sh
make list		# List boards
make all board=xxx	# Kernel > rootfs > image
make kernel board=xxx	# Builds linux kernel package
make commit board=xxx	# Builds linux kernel package
make rootfs board=xxx	# Create rootfs tarball
make image board=xxx	# Make bootable image
```

#### Miscellaneous

```sh
make clean      # Clean up rootfs and image errors
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
Branch:			# Supported: 6.1.y and above
Build:			# Kernel build version number
Menuconfig:		# Kernel menuconfig
Compiler:		# GNU Compiler Collection / Clang
Ccache:			# Compiler cache

Distribution
Distro:			# Supported: debian, devuan and ubuntu
Release:		# Debian: bullseye, bookworm, testing, unstable and sid
			# Devuan: chimaera and daedalus (broken: excalibur, testing, unstable, ceres)
			# https://www.devuan.org/os/announce/excalibur-usrmerge-announce-2024-02-20.html
			# Ubuntu: focal, jammy and noble
NetworkManager		# 1 networkmanager | 0 ifupdown

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

#### Customize image
* custom.txt
```sh
# Image Size
IMGSIZE="4096MB"

# Root Filesystem Types: ext4 btrfs xfs
FSTYPE="ext4"

# Shrink Image
SHRINK="true"

# Hostname
HOSTNAME="raspberrypi"

# Branding: true false
BRANDING="false"
MOTD="Raspberry Pi"
```

#### User defconfig
```sh
# Config placement: defconfig/$NAME_defconfig
The config menu will append _defconfig to the end of the name
in the userdata.txt file.
```

#### User patches

```sh
Patches "-p1" placed in userpatches are applied during compilation.
```

#### Preferred commit
```sh
# Example
ENABLE_COMMIT="1"
COMMIT="9ed4f05ba2e2bcd9065831674e97b2b1283e866d"
```

### Usage
* Review the [Wiki](https://github.com/pyavitz/rpi-img-builder/wiki/Options-&-Scripts)
* The boot partition is labelled BOOT
#### BOOT: useraccount.txt
* Headless: ENABLE="true" and fill in the variables (recommended)
* Headful: ENABLE="false" and get prompted to create a user account
```sh
ENABLE="false"			# Set to true to enable service
NAME=""				# Your name
USERNAME=""			# Username
PASSWORD=""			# Password
```

#### BOOT: credentials.txt
```sh
Set to ENABLE="true" and input your wifi information.
ENABLE="false"			# Enable service

SSID=""				# Service set identifier
PASSKEY=""			# Wifi password
COUNTRYCODE=""			# Your country code

# set static ip (ifupdown)
MANUAL="false"			# Set to true to enable a static ip
IPADDR=""			# Static ip address
NETMASK=""			# Your Netmask
GATEWAY=""			# Your Gateway
NAMESERVERS=""			# Your preferred dns

# set static ip (network-manager)
MANUAL="false"			# Set to true to enable a static ip
IPADDR=""			# Static ip address
GATEWAY=""			# Your Gateway
DNS=""				# Your preferred dns

# change hostname
HOSTNAME="raspberrypi"		# Hostname

For headless use: ssh user@ipaddress
```
#### System Menu: `menu-config`
<img src="https://i.imgur.com/vwFVBzF.png" alt="Main Menu" />

---

## Support

Should you come across any bugs, feel free to either open an issue on GitHub or talk with us directly by joining our channel on Libera; [`#arm-img-builder`](irc://irc.libera.chat/#arm-img-builder) or [Discord](https://discord.gg/mypJ7NW8BG)
