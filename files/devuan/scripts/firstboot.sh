#!/bin/bash
### Functions
grow_mmcblk(){
bash growpart /dev/mmcblk0 2 > /dev/null 2>&1
sleep 1s
if blkid | grep ext4 > /dev/null 2>&1;
	then resize2fs /dev/mmcblk0p2 > /dev/null 2>&1
fi
if blkid | grep btrfs > /dev/null 2>&1;
	then btrfs filesystem resize max / > /dev/null 2>&1
fi
}

grow_mmcblk1(){
bash growpart /dev/mmcblk1 2 > /dev/null 2>&1
sleep 1s
if blkid | grep ext4 > /dev/null 2>&1;
	then resize2fs /dev/mmcblk1p2 > /dev/null 2>&1
fi
if blkid | grep btrfs > /dev/null 2>&1;
	then btrfs filesystem resize max / > /dev/null 2>&1
fi
}

grow_sda(){
bash growpart /dev/sda 2 > /dev/null 2>&1
sleep 1s
if blkid | grep ext4 > /dev/null 2>&1;
	then resize2fs /dev/sda2 > /dev/null 2>&1
fi
if blkid | grep btrfs > /dev/null 2>&1;
	then btrfs filesystem resize max / > /dev/null 2>&1
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

partition_uuid(){
echo 'ROOT_PARTUUID="' > root1
if ls /dev/mmcblk0p2  > /dev/null 2>&1;
	then blkid -o export -- "/dev/mmcblk0p2" | sed -ne 's/^PARTUUID=//p' > root2;
fi
if ls /dev/mmcblk1p2  > /dev/null 2>&1;
	then blkid -o export -- "/dev/mmcblk1p2" | sed -ne 's/^PARTUUID=//p' > root2;
fi
if ls /dev/sda2  > /dev/null 2>&1;
	then blkid -o export -- "/dev/sda2" | sed -ne 's/^PARTUUID=//p' > root2;
fi
echo '"' > root3
paste -d '\0' root1 root2 root3  > /etc/opt/root-pid.txt
rm -f root1 root2 root3
}

create_cmdline(){
if blkid | grep ext4 > /dev/null 2>&1;
	then cmdline_ext4 > /dev/null 2>&1
fi
if blkid | grep btrfs > /dev/null 2>&1;
	then cmdline_btrfs > /dev/null 2>&1
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

fix_cmdline(){
if `grep -Fx "bcm2708" "/etc/opt/soc.txt" >/dev/null;`
	then partition_uuid > /dev/null 2>&1;
fi
if `grep -Fx "bcm2708" "/etc/opt/soc.txt" >/dev/null;`
	then create_cmdline > /dev/null 2>&1;
fi
}

### Grow Partition
echo
echo -e "\e[0;31mExpanding root filesystem\e[0m ..."
if touch -c /dev/mmcblk0 2>/dev/null; then grow_mmcblk;
        else : &>/dev/null;
fi

if touch -c /dev/mmcblk1 2>/dev/null; then grow_mmcblk1;
        else : &>/dev/null;
fi

if touch -c /dev/sda 2>/dev/null; then grow_sda;
        else : &>/dev/null;
fi

### Fix boot partition
echo -e "\e[0;31mRunning fsck on boot partition\e[0m ..."
umount /boot
sleep 1s
if touch -c /dev/mmcblk0 2>/dev/null; then chk_mmcblk;
        else : &>/dev/null;
fi

if touch -c /dev/mmcblk1 2>/dev/null; then chk_mmcblk1;
        else : &>/dev/null;
fi

if touch -c /dev/sda 2>/dev/null; then chk_sda;
        else : &>/dev/null;
fi
sleep 1s
mount /boot
sleep 1s
fix_cmdline

if dmesg | grep Raspberry\ Pi\ 2 > /dev/null 2>&1;
	then update-rc.d -f bthelper remove;
fi

### Clean up
rm -f /var/cache/debconf/*
rm -f /usr/local/sbin/firstboot
update-rc.d firstboot remove
rm /etc/init.d/firstboot
