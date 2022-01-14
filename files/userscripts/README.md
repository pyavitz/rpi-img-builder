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
This script is just an example of what one could do if someone so wished.

```sh
#!/bin/bash
# Prerequisite: Debian Bullseye
# Install Xfce DE.

XFCE="xfce4 xinit thunar mousepad gvfs-backends gvfs-fuse gnome-screensaver feh \
	xfce4-terminal avahi-utils pulseaudio blueman xfce4-goodies file-roller \
	fbi alacarte chromium lightdm-gtk-greeter lightdm x11-xserver-utils xserver-xorg"

echo ""
sudo apt install -y ${XFCE}
sudo apt purge -y light-locker
sudo wget -cq https://raw.githubusercontent.com/pyavitz/scripts/master/sleep-locker -P /usr/local/bin
sudo chmod +x /usr/local/bin/sleep-locker
sudo chown root:root /usr/local/bin/sleep-locker
sudo chown -R $USER:$USER /home/$USER
sudo adduser $USER lightdm
sudo usermod -a -G render $USER
sudo sed -i "s/#autologin-user=/autologin-user=$USER/g" /etc/lightdm/lightdm.conf
sudo sed -i "s/#dtoverlay=vc4-kms-v3d/dtoverlay=vc4-kms-v3d/g" /boot/config.txt
sudo sed -i "s/dtoverlay=vc4-fkms-v3d/#dtoverlay=vc4-fkms-v3d/g" /boot/config.txt
echo
echo -e "You may now reboot ..."
```
