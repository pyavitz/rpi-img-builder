#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

BOOT=`findmnt -v -n -o SOURCE /boot`
ROOTFS=`findmnt -v -n -o SOURCE /`
GROW=`findmnt -v -n -o SOURCE / | sed 's/p/ /'`
GROW_SD=`findmnt -v -n -o SOURCE / | sed 's/./& /8'`

# Functions
partition_uuid(){
echo 'ROOT_PARTUUID="' > root1
blkid -o export -- $ROOTFS | sed -ne 's/^PARTUUID=//p' > root2
echo '"' > root3
paste -d '\0' root1 root2 root3  > /etc/opt/root-pid.txt
rm -f root1 root2 root3
}

create_cmdline(){
if [[ `blkid | grep -w "ext4"` ]]; then
	cmdline_ext4 > /dev/null 2>&1;
else
	if [[ `blkid | grep -w "btrfs"` ]]; then
		cmdline_btrfs > /dev/null 2>&1;
	else
		if [[ `blkid | grep -w "xfs"` ]]; then
			cmdline_xfs > /dev/null 2>&1;
		fi
	fi
fi
}

cmdline_btrfs(){
source /etc/opt/root-pid.txt
rm -f /boot/cmdline.txt
tee /boot/cmdline.txt <<EOF
console=serial0,115200 console=tty1 root=PARTUUID=${ROOT_PARTUUID} rootfstype=btrfs rootflags=subvol=@ fsck.repair=yes logo.nologo net.ifnames=0 firmware_class.path=/lib/firmware/updates/brcm rootwait
EOF
rm -f /etc/opt/root-pid.txt
}

cmdline_ext4(){
source /etc/opt/root-pid.txt
rm -f /boot/cmdline.txt
tee /boot/cmdline.txt <<EOF
console=serial0,115200 console=tty1 root=PARTUUID=${ROOT_PARTUUID} rootfstype=ext4 fsck.repair=yes logo.nologo net.ifnames=0 firmware_class.path=/lib/firmware/updates/brcm rootwait
EOF
rm -f /etc/opt/root-pid.txt
}

cmdline_xfs(){
source /etc/opt/root-pid.txt
rm -f /boot/cmdline.txt
tee /boot/cmdline.txt <<EOF
console=serial0,115200 console=tty1 root=PARTUUID=${ROOT_PARTUUID} rootfstype=xfs fsck.repair=yes logo.nologo net.ifnames=0 firmware_class.path=/lib/firmware/updates/brcm rootwait
EOF
rm -f /etc/opt/root-pid.txt
}

disable_bthelper(){
if [[ `dmesg | grep -w "Raspberry\ Pi\ 2"` ]]; then
	update-rc.d -f bthelper remove;
fi
if [[ `dmesg | grep -w "Raspberry\ Pi\ Model\ B\ Rev\ 1"` ]]; then
	update-rc.d -f bthelper remove;
fi
if [[ `dmesg | grep -w "Raspberry\ Pi\ Model\ B\ Rev\ 2"` ]]; then
	update-rc.d -f bthelper remove;
fi
}

# Expand root filesystem
if [[ `grep -w "Devuan" "/etc/os-release"` ]]; then
	echo ""
	echo -e " \e[0;31mExpanding root filesystem\e[0m ...";
fi
if [[ `findmnt -v -n -o SOURCE / | grep "mmc"` ]]; then
	bash growpart $GROW > /dev/null 2>&1;
fi
if [[ `findmnt -v -n -o SOURCE / | grep "nvme"` ]]; then
	bash growpart $GROW > /dev/null 2>&1;
fi
if [[ `findmnt -v -n -o SOURCE / | grep "sd"` ]]; then
	bash growpart $GROW_SD > /dev/null 2>&1;
fi
sleep 1s
if [[ `blkid | grep -w "ext4"` ]]; then
	resize2fs $ROOTFS > /dev/null 2>&1;
else
	if [[ `blkid | grep -w "btrfs"` ]]; then
		btrfs filesystem resize max / > /dev/null 2>&1;
	else
		if [[ `blkid | grep -w "xfs"` ]]; then
			xfs_growfs -d / > /dev/null 2>&1;
		fi
	fi
fi

# Fsck boot partition
if [[ `grep -w "Devuan" "/etc/os-release"` ]]; then
	echo -e " \e[0;31mRunning fsck on boot partition\e[0m ...";
fi
umount /boot
sleep 1s
bash fsck.fat -trawl $BOOT > /dev/null 2>&1
sleep 1s
mount /boot
sleep 1s
if [[ `grep -w "arm" "/etc/opt/soc.txt"` ]]; then
	partition_uuid;
	sleep 1s;
	create_cmdline;
fi

# Clean up
if [[ `grep -w "Debian" "/etc/os-release"` ]]; then
	rm -f /var/cache/debconf/*
	rm -f /usr/local/sbin/firstboot
	systemctl disable firstboot;
else
	if [[ `grep -w "Devuan" "/etc/os-release"` ]]; then
		disable_bthelper
		update-rc.d firstboot remove
		rm -f /etc/init.d/firstboot
		rm -f /var/cache/debconf/*
		rm -f /usr/local/sbin/firstboot;
	else
		if [[ `grep -w "Ubuntu" "/etc/os-release"` ]]; then
			rm -f /var/cache/debconf/*
			rm -f /usr/local/sbin/firstboot
			systemctl disable firstboot;
		fi
	fi
fi

exit 0
