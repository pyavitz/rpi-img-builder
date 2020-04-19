
&#x1F538; `feature branch`

# Supported boards: RPi4B, RPi3B/+ and RPi0W

Debian Image Builder for the Raspberry Pi 

## Instructions

* Make sure to adjust `config.txt` & `kernel.txt` with your own configurations before proceeding.

* Install all dependencies

```sh
make install-depends
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

## Howto

* Kernel
* `supported: rpi4:arm64;armv7l`

```sh
Kernel branch:               # https://github.com/raspberrypi/linux
kernel="linux-rpi"
version="5.4.y"              # default

Switches:
true = active
false = inactive
---
default_defconfig=true            # default
foundation_defconfig=false    # raspberry pi foundation
custom_defconfig=false        # your custom defconfig
menuconfig=false              # open menuconfig

Your custom_defconfig must be placed in the defconfig directory.
```

### Funding

Please [donate](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=VG8GP2SY4CEEW&item_name=For+new+single+board+computers+and+accessories) if you'd like to support development.
