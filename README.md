# RPi4B

Debian Image Builder for the Raspberry Pi

### Downloadable Image

A bootable Debian image which has been compiled against Raspberry Pi's modified `Linux 5.4.29` (`aarch64`) kernel can be found here;

* [`rpi-4-b-debian-buster`](https://www.mediafire.com/file/t0sum2xe1iivkjv/rpi-4-b-debian-buster.7z/file)

## Dependencies

In order to install the required dependencies, run the following command:

```
sudo apt install build-essential bison bc git dialog patch dosfstools zip unzip qemu debootstrap qemu-user-static rsync kmod cpio flex libssl-dev libncurses5-dev parted fakeroot swig crossbuild-essential-arm64
```

This has been tested on an AMD64/x86_64 system running on [Debian Buster](https://www.debian.org/releases/buster/debian-installer/).

Alternatively, you can run the command `make install-depends` in this directory.

## Instructions

* Make sure to adjust `config.txt` with your own configurations before proceeding.

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
### Funding

Please [donate](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=VG8GP2SY4CEEW&item_name=For+new+single+board+computers+and+accessories) if you'd like to support development.
