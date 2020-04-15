# RPi4B
Debian Image Builder for the Raspberry Pi

<code>git clone https://github.com/pyavitz/rpi-img-builder.git</code>
<hr>
<h3>Downloadable Image</h3>

<code><a href="http://www.mediafire.com/file/t0sum2xe1iivkjv/rpi-4-b-debian-buster.7z/file">rpi-4-b-debian-buster</a></code> <code>aarch64</code> <code>Linux 5.4.29</code> <code>040120</code>
<hr>
<h2>Dependencies for Debian Buster x86_64/AMD64 system</h2>

```
sudo apt install build-essential bison bc git dialog patch dosfstools zip unzip qemu debootstrap qemu-user-static rsync kmod cpio flex libssl-dev libncurses5-dev parted fakeroot swig crossbuild-essential-arm64
```

```
Check config.txt for options

Usage:

  make install-depends   Install all dependencies
  make kernel            Make linux kernel
  make rootfs            Make ROOTFS tarball
  make image             Make bootable Debian image
  make cleanup           Clean up image errors

For details consult the README.md file

```

<hr>

If you would like to <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=VG8GP2SY4CEEW&item_name=For+new+single+board+computers+and+accessories.&currency_code=USD&source=url">support</a> my efforts.
