### User scripts
```sh
All files placed in this directory will be moved to /usr/local/bin/
and made executable, during img creation. 
```

### Enable
```sh
nano userdata.txt
userscripts=0	# 1 to enable | 0 to disable
``` 

### Example
```sh
#!/bin/bash
# Prerequisite: Debian Bullseye
# Installs Mesa 20.3 with Raspberry Pi specific functionality, followed by Xfce and a custom Linux kernel.

DOWNLOAD="aria2c -c --download-result=hide --console-log-level=error --disable-ipv6=true --summary-interval=0 --show-files=false"

XFCE="xfce4 xinit thunar mousepad gvfs-backends gvfs-fuse gnome-screensaver feh \
	xfce4-terminal avahi-utils pulseaudio blueman xfce4-goodies file-roller \
	fbi alacarte chromium lightdm-gtk-greeter lightdm x11-xserver-utils xserver-xorg"

MESADEV="llvm-dev ninja-build meson libvdpau-dev libxvmc-dev libva-dev libomxil-bellagio-dev python3-mako \
	libdrm-nouveau2 libdrm-dev wayland-protocols libwayland-egl-backend-dev libunwind-dev libxdamage-dev \
	libxcb-glx0-dev libxcb-shm0-dev libx11-xcb-dev libxcb-dri2-0-dev libxcb-dri3-dev libxcb-present-dev \
	libxshmfence-dev libxxf86vm-dev libxrandr-dev valgrind mpv"

### CHECK ARIA2
aria2c_check(){
if ls /usr/bin/aria2c > /dev/null 2>&1;
   then :;
   else sudo apt update && sudo apt install -y aria2;
fi
}

### MESA 20.3
mesa_install(){
echo
echo Installing Mesa 20.3
sudo apt update
sudo apt install -y ${MESADEV}

cd ~
mkdir mesa
cd mesa
${DOWNLOAD} https://gitlab.freedesktop.org/mesa/mesa/-/archive/20.3/mesa-20.3.tar.gz
tar xf mesa-20.3.tar.gz
rm -f mesa-20.3.tar.gz
mkdir -p mesa-20.3/build
cd mesa-20.3/build
sudo meson --prefix=/usr -Dglx=disabled -Dplatforms=auto -Dllvm=disabled -Dvulkan-drivers='' -Ddri-drivers='' -Dgallium-drivers=vc4,v3d,kmsro ..
sudo ninja install
cd ~
sudo rm -fdr mesa
sudo apt purge -y --autoremove ninja-build meson
sudo chown -R $USER:$USER /home/$USER
echo Done.
}

### INSTALL KERNEL
cacule_kernel(){
URL="https://github.com/pyavitz/rpi-img-builder/releases/download/linux/"
mkdir -p ~/.build
cd ~/.build
echo
echo -e "Fetching rpi4-5.10.y ..."
${DOWNLOAD} ${URL}rpi4-5.10.y-cacule.tar.xz
echo && echo
echo -e "Extracting archive ..."
tar xf rpi4-5.10.y-cacule.tar.xz
rm -f rpi4-5.10.y-cacule.tar.xz
echo -e "Done."
echo
echo -e "Starting install ..."
cd rpi4-5.10.y-cacule
sudo dpkg -i *.deb
cd ~
echo -e "Done."
sudo rm -fdr ~/.build/*
}

### THE MAGIC
aria2c_check
mesa_install
echo
sudo apt install -y ${XFCE}
sudo apt purge -y light-locker
sudo wget -cq https://raw.githubusercontent.com/pyavitz/rpi-img-builder/xfce/files/scripts/sleep-locker -P /usr/local/bin
sudo chmod +x /usr/local/bin/sleep-locker
sudo chown root:root /usr/local/bin/sleep-locker
cacule_kernel
sudo chown -R $USER:$USER /home/$USER
sudo adduser $USER lightdm
sudo usermod -a -G render $USER
sudo sed -i "s/#autologin-user=/autologin-user=$USER/g" /etc/lightdm/lightdm.conf
sudo sed -i "s/#dtoverlay=vc4-kms-v3d/dtoverlay=vc4-kms-v3d/g" /boot/config.txt
sudo sed -i "s/dtoverlay=vc4-fkms-v3d/#dtoverlay=vc4-fkms-v3d/g" /boot/config.txt
echo
echo -e "You may now reboot ..."
```
This script is just an example what one could do if someone so wished.
