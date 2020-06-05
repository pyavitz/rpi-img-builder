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

```ssh
make config     # Create user data file
make menu       # Open menu interface
make dialogrc   # Set builder theme (optional)
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

## Usage
#### Updating eeprom
```sh
nano ~/.eeprom
# EEPROM CONFIG
## https://archive.raspberrypi.org/debian/pool/main/r/rpi-eeprom/
EEPROM_VERSION="6.0" # change version number
```
Execute: `deb-eeprom-update`

#### User defconfig
```sh
nano userdata.txt
# place config in defconfig directory
custom_defconfig=1
MYCONFIG="nameofyour_defconfig"
```

---

### Support

Should you come across any issues, feel free to either open an issue on GitHub or talk with us directly by joining our channel on Freenode; [`#debianarm-port`](irc://irc.freenode.net/#debianarm-port)

### Funding

Please consider [donating](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=VG8GP2SY4CEEW&item_name=Raspberry+Pi+Image+Builder) if you'd like to support development.
