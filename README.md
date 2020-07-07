## Debian Image Builder for the Raspberry Pi 

The boards that are currently supported are;
* Raspberry Pi 4B (bcm2711)
* Raspberry Pi 3B/3B+ (bcm2710, bcm2837, bcm2837b0)
* Raspberry Pi 0/0W/1/+ (bcm2708, bcm2835)

## Dependencies

In order to install the required dependencies, run the following command:

```
sudo apt install build-essential bison bc git dialog patch dosfstools zip unzip qemu debootstrap \
                 qemu-user-static rsync kmod cpio flex libssl-dev libncurses5-dev parted fakeroot \
                 swig crossbuild-essential-arm64 crossbuild-essential-armel
```

This has been tested on an AMD64/x86_64 system running on [Debian Buster](https://www.debian.org/releases/buster/debian-installer/).

Alternatively, you can run the command `make install-depends` in this directory.

## Instructions

#### Install dependencies

```sh
make install-depends        # (cross compile)
make install-native-depends # (native compile)
```

#### Menu interface

```sh
make config     # Create user data file
make menu       # Open menu interface
make dialogrc   # Set builder theme (optional)
```
#### Config Menu

```sh
Username:       # Your username
Password:       # Your password
Branch:         # Selected kernel branch
Edge Branch:    # 1 for any branch above 5.4.y
Menuconfig:     # 1 to run kernel menuconfig
Crosscompile:   # 1 to cross compile | 0 to native compile
```
#### User defconfig
```sh
nano userdata.txt
# place config in defconfig directory
custom_defconfig=1
MYCONFIG="nameofyour_defconfig"
```
#### Miscellaneous

```sh
make cleanup    # Clean up image errors
make purge      # Remove tmp directory
make commands   # List legacy commands
```

## Command list (legacy)

#### Raspberry Pi 4B

```sh
# AARCH64
make kernel
make image
make all
```

#### Raspberry Pi 3B/+

```sh
# AARCH64
make rpi3-kernel
make rpi3-image
make rpi3-all
```

#### Raspberry Pi 0/0W/B/+

```sh
# ARMv6l
make rpi-kernel
make rpi-image
make rpi-all
```

#### Root Filesystems

```sh
make rootfs   # (arm64)
make rootfsv6 # (armel)
```
## Help
```sh
Help, downloads a binary Linux package and XL rootfs tarball.
Make sure to run 'make config' before 'make image'.
Usage: scripts/help -opt

   -1        Raspberry Pi 0/w/b/+
   -2        Raspberry Pi 3b/+
   -3        Raspberry Pi 4b
   -h        Help
   
https://github.com/pyavitz/rpi-img-builder/releases/tag/linux
https://github.com/pyavitz/rootfs-tarballs/releases/tag/xlrootfs
```
`chmod +x scripts/help && scripts/help -h`

## Usage
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

For headless use: ssh user@ipaddress

Note:
You can also mount the ROOTFS partition and edit the following
files, whilst leaving rename_to_credentials.txt untouched.

/etc/opt/interfaces.manual
/etc/opt/wpa_supplicant.manual
```

#### Updating eeprom
```sh
nano ~/.eeprom
# EEPROM CONFIG
## https://archive.raspberrypi.org/debian/pool/main/r/rpi-eeprom/
EEPROM_VERSION="6.0" # change version number
```
Execute: `deb-eeprom-update`

#### Using fetch
```sh
Fetch, Linux kernel installer for the Raspberry Pi Image Builder
Usage: fetch -opt

   -1	    Linux 4.19.y LTS
   -2       Linux 5.4.y LTS
   -3       Linux Stable Branch
   -u       Update Fetch
   -h       Help
   
fetch -h will list available options and kernel revisions
```

---

### Support

Should you come across any issues, feel free to either open an issue on GitHub or talk with us directly by joining our channel on Freenode; [`#debianarm-port`](irc://irc.freenode.net/#debianarm-port)
