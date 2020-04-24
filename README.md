
&#x1F538; `master branch`

# Supported boards: RPi4B, RPi3B/+ and RPi0/W/1/+

Debian Image Builder for the Raspberry Pi 

### Downloadable Image

A bootable Debian image which has been compiled against Raspberry Pi's modified `Linux 5.4.32` (`aarch64 armv7l armv6l`) kernel can be found here;

* [`rpi-4-b-debian-buster v8`](http://www.mediafire.com/file/ll98hfp3k84zvm7/rpi-4-b-debian-buster-v8.7z/file)
* [`rpi-4-b-debian-buster v7`](http://www.mediafire.com/file/6jm4353zc1gvbqb/rpi-4-b-debian-buster-v7.7z/file)
* [`rpi-3-b-plus-debian-buster v8`](http://www.mediafire.com/file/cul1ok8jgyk8j5x/rpi-3-b-plus-debian-buster-v8.7z/file)
* [`rpi-3-b-plus-debian-buster v7`](http://www.mediafire.com/file/wa0wc7xn2u7eivt/rpi-3-b-plus-debian-buster-v7.7z/file)
* [`rpi-zero-w-debian-buster`](http://www.mediafire.com/file/p27bp5irwwikxon/rpi-zero-w-debian-buster.7z/file)

## Dependencies

In order to install the required dependencies, run the following command:

```
sudo apt install build-essential bison bc git dialog patch dosfstools zip unzip qemu debootstrap \
                 qemu-user-static rsync kmod cpio flex libssl-dev libncurses5-dev parted fakeroot \
                 swig crossbuild-essential-arm64 crossbuild-essential-armhf crossbuild-essential-armel
```

This has been tested on an AMD64/x86_64 system running on [Debian Buster](https://www.debian.org/releases/buster/debian-installer/).

Alternatively, you can run the command `make install-depends` in this directory.

## Instructions

* Make sure to adjust `config.txt` & `kernel.txt` with your own configurations before proceeding.

* Install all dependencies

```sh
make install-depends        (cross compile)
make install-native-depends (native compile)
```

* Compile the kernel

```sh
make kernel
```

* Prepare the rootfs

```sh
make rootfs
```

* Create a bootable Debian image

```sh
make image
```

* Clean up image errors

```sh
make cleanup
```

* Remove all tmp directories

```sh
make purge
```

## Command list (current)

* Raspberry Pi 4B (default)

```sh
AARCH64
make kernel
make image
make all

ARMv7l
make kernelv7
make imagev7
make allv7
```

* Raspberry Pi 3B/+

```sh
AARCH64
make rpi3-kernel
make rpi3-image
make rpi3-all

ARMv7l
make rpi3-kernelv7
make rpi3-imagev7
make rpi3-allv7
```

* Raspberry Pi 0W

```sh
ARMv6l
make rpi0-kernel
make rpi0-image
make rpi0-all
```

* Root Filesystems

```sh
make rootfs   (arm64)
make rootfsv7 (armhf)
make rootfsv6 (armel)
```

* Miscellaneous

```sh
make cleanup
make purge
make commands
```

## Howto

* Kernel

```sh
Kernel branch:               # https://github.com/raspberrypi/linux
kernel="linux-rpi"
version="5.4.y"              # default

Switches:
1 = active
0 = inactive

--- default
foundation_defconfig=1        # raspberry pi foundation
lessfoundation_defconfig=0    # no initrd | less usb wireless support
custom_defconfig=0            # your custom defconfig
menuconfig=0                  # open menuconfig
native=0                      # native compiling
crosscompile=1                # cross compiling

# user defconfig must be in defconfig directory
MYCONFIG="nameofyour_defconfig"
```
### Support

Create an issue or visit us on freenode `#debianarm-port`

### Funding

Please [donate](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=VG8GP2SY4CEEW&item_name=For+new+single+board+computers+and+accessories) if you'd like to support development.
