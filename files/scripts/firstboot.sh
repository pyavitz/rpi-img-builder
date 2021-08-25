#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

### Functions
grow_mmcblk(){
bash growpart /dev/mmcblk0 2 > /dev/null 2>&1
sleep 1s
if [[ `blkid | grep ext4` ]]; then
	resize2fs /dev/mmcblk0p2 > /dev/null 2>&1;
else
	if [[ `blkid | grep btrfs` ]]; then
		btrfs filesystem resize max / > /dev/null 2>&1;
	else
		if [[ `blkid | grep xfs` ]]; then
		xfs_growfs -d / > /dev/null 2>&1;
		fi
	fi
fi
}

grow_mmcblk1(){
bash growpart /dev/mmcblk1 2 > /dev/null 2>&1
sleep 1s
if [[ `blkid | grep ext4` ]]; then
	resize2fs /dev/mmcblk1p2 > /dev/null 2>&1;
else
	if [[ `blkid | grep btrfs` ]]; then
		btrfs filesystem resize max / > /dev/null 2>&1;
	else
		if [[ `blkid | grep xfs` ]]; then
			xfs_growfs -d / > /dev/null 2>&1;
		fi
	fi
fi
}

grow_sda(){
bash growpart /dev/sda 2 > /dev/null 2>&1
sleep 1s
if [[ `blkid | grep ext4` ]]; then
	resize2fs /dev/sda2 > /dev/null 2>&1;
else
	if [[ `blkid | grep btrfs` ]]; then
		btrfs filesystem resize max / > /dev/null 2>&1;
	else
		if [[ `blkid | grep xfs` ]]; then
			xfs_growfs -d / > /dev/null 2>&1;
		fi
	fi
fi
}

grow_nvme(){
bash growpart /dev/nvme0n1 2 > /dev/null 2>&1
sleep 1s
if [[ `blkid | grep ext4` ]]; then
	resize2fs /dev/nvme0n1p2 > /dev/null 2>&1;
else
	if [[ `blkid | grep btrfs` ]]; then
		btrfs filesystem resize max / > /dev/null 2>&1;
	else
		if [[ `blkid | grep xfs` ]]; then
		xfs_growfs -d / > /dev/null 2>&1;
		fi
	fi
fi
}

chk_mmcblk(){
bash fsck.fat -trawl /dev/mmcblk0p1 > /dev/null 2>&1
}

chk_mmcblk1(){
bash fsck.fat -trawl /dev/mmcblk1p1 > /dev/null 2>&1
}

chk_sda(){
bash fsck.fat -trawl /dev/sda1 > /dev/null 2>&1
}

chk_nvme(){
bash fsck.fat -trawl /dev/nvme0n1p1 > /dev/null 2>&1
}

partition_uuid(){
echo 'ROOT_PARTUUID="' > root1
if [ -e /dev/mmcblk0p2 ]; then
	blkid -o export -- "/dev/mmcblk0p2" | sed -ne 's/^PARTUUID=//p' > root2;
else
	if [ -e /dev/mmcblk1p2 ]; then
		blkid -o export -- "/dev/mmcblk1p2" | sed -ne 's/^PARTUUID=//p' > root2;
	else
		if [ -e /dev/sda2 ]; then
			blkid -o export -- "/dev/sda2" | sed -ne 's/^PARTUUID=//p' > root2;
		else
			if [ -e /dev/nvme0n1p2 ]; then
				blkid -o export -- "/dev/nvme0n1p2" | sed -ne 's/^PARTUUID=//p' > root2;
			fi
		fi
	fi
fi
echo '"' > root3
paste -d '\0' root1 root2 root3  > /etc/opt/root-pid.txt
rm -f root1 root2 root3
}

create_cmdline(){
if [[ `blkid | grep ext4` ]]; then
	cmdline_ext4 > /dev/null 2>&1;
else
	if [[ `blkid | grep btrfs` ]]; then
		cmdline_btrfs > /dev/null 2>&1;
	else
		if [[ `blkid | grep xfs` ]]; then
			cmdline_xfs > /dev/null 2>&1;
		fi
	fi
fi
}

cmdline_btrfs(){
source /etc/opt/root-pid.txt
rm -f /boot/cmdline.txt
tee /boot/cmdline.txt <<EOF
console=serial0,115200 console=tty1 root=PARTUUID=${ROOT_PARTUUID} rootfstype=btrfs rootflags=subvol=@ elevator=deadline fsck.repair=yes logo.nologo net.ifnames=0 firmware_class.path=/lib/firmware/updates/brcm rootwait
EOF
rm -f /etc/opt/root-pid.txt
}

cmdline_ext4(){
source /etc/opt/root-pid.txt
rm -f /boot/cmdline.txt
tee /boot/cmdline.txt <<EOF
console=serial0,115200 console=tty1 root=PARTUUID=${ROOT_PARTUUID} rootfstype=ext4 elevator=deadline fsck.repair=yes logo.nologo net.ifnames=0 firmware_class.path=/lib/firmware/updates/brcm rootwait
EOF
rm -f /etc/opt/root-pid.txt
}

cmdline_xfs(){
source /etc/opt/root-pid.txt
rm -f /boot/cmdline.txt
tee /boot/cmdline.txt <<EOF
console=serial0,115200 console=tty1 root=PARTUUID=${ROOT_PARTUUID} rootfstype=xfs elevator=deadline fsck.repair=yes logo.nologo net.ifnames=0 firmware_class.path=/lib/firmware/updates/brcm rootwait
EOF
rm -f /etc/opt/root-pid.txt
}

fix_cmdline(){
if [[ `grep -w "bcm2708" "/etc/opt/soc.txt"` ]]; then
	partition_uuid
	sleep 1s
	create_cmdline;
else
	if [[ `grep -w "bcm2709" "/etc/opt/soc.txt"` ]]; then
		partition_uuid
		sleep 1s
		create_cmdline;
	fi
fi
}

disable_bthelper(){
if [[ `dmesg | grep -w "Raspberry\ Pi\ 2"` ]]; then
	update-rc.d -f bthelper remove;
else
	if [[ `dmesg | grep -w "Raspberry\ Pi\ Model\ B\ Rev\ 1"` ]]; then
		update-rc.d -f bthelper remove;
	else
		if [[ `dmesg | grep -w "Raspberry\ Pi\ Model\ B\ Rev\ 2"` ]]; then
			update-rc.d -f bthelper remove;
		fi
	fi
fi
}

### Grow Partition
if [[ `grep -w "Devuan" "/etc/os-release"` ]]; then
	echo
	echo -e " \e[0;31mExpanding root filesystem\e[0m ...";
fi
if [ -e /dev/mmcblk0 ]; then
	grow_mmcblk;
else
	if [ -e /dev/mmcblk1 ]; then
		grow_mmcblk1;
	else
		if [ -e /dev/sda ]; then
			grow_sda;
		else
			if [ -e /dev/nvme0 ]; then
				grow_nvme;
			fi
		fi
	fi
fi

### Fix boot partition
if [[ `grep -w "Devuan" "/etc/os-release"` ]]; then
	echo -e " \e[0;31mRunning fsck on boot partition\e[0m ...";
fi
umount /boot
sleep 1s
if [ -e /dev/mmcblk0 ]; then
	chk_mmcblk;
else
	if [ -e /dev/mmcblk1 ]; then
		chk_mmcblk1;
	else
		if [ -e /dev/sda ]; then
			chk_sda;
		else
			if [ -e /dev/nvme0 ]; then
				chk_nvme;
			fi
		fi
	fi
fi
sleep 1s
mount /boot
sleep 1s
fix_cmdline

### Clean up
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

exit
