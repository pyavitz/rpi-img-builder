#!/bin/bash
if [ -e /boot/credentials.txt ]; then
	source /boot/credentials.txt;
fi

### Functions
change_hostname(){
sed -i "s/bcm2711/${HOSTNAME}/g" /etc/hostname
sed -i "s/bcm2711v7/${HOSTNAME}/g" /etc/hostname
sed -i "s/bcm2710/${HOSTNAME}/g" /etc/hostname
sed -i "s/bcm2709/${HOSTNAME}/g" /etc/hostname
sed -i "s/bcm2711/${HOSTNAME}/g" /etc/hosts
sed -i "s/bcm2711v7/${HOSTNAME}/g" /etc/hosts
sed -i "s/bcm2710/${HOSTNAME}/g" /etc/hosts
sed -i "s/bcm2709/${HOSTNAME}/g" /etc/hosts
}

change_branding(){
sed -i "s/Raspberry Pi/${BRANDING}/g" /etc/update-motd.d/15-brand
}

dhcp(){
sed -i "s/REGDOMAIN=/REGDOMAIN=${COUNTRYCODE}/g" /etc/default/crda
iw reg set ${COUNTRYCODE}
nmcli c add type wifi con-name ${NAME} ifname wlan0 ssid ${SSID}
nmcli c modify ${NAME} wifi-sec.key-mgmt wpa-psk wifi-sec.psk ${PASSKEY}
nmcli c up ${NAME}
}

static(){
sed -i "s/REGDOMAIN=/REGDOMAIN=${COUNTRYCODE}/g" /etc/default/crda
iw reg set ${COUNTRYCODE}
nmcli c add type wifi con-name ${NAME} ifname wlan0 ssid ${SSID}
nmcli c modify ${NAME} wifi-sec.key-mgmt wpa-psk wifi-sec.psk ${PASSKEY}
nmcli con mod ${NAME} ipv4.addresses ${IPADDR}/24
nmcli con mod ${NAME} ipv4.gateway ${GATEWAY}
nmcli con mod ${NAME} ipv4.method manual
nmcli con mod ${NAME} ipv4.dns "${DNS}"
nmcli c up ${NAME}
}

connect_wifi(){
if [[ `grep -Fx "MANUAL=y" "/boot/credentials.txt"` ]]; then
	static;
else
	dhcp;
fi
}

hostname_branding(){
if [[ `grep -Fx "CHANGE=y" "/boot/credentials.txt"` ]]; then
	change_hostname
	change_branding
	hostnamectl set-hostname ${HOSTNAME}
	systemctl restart avahi-daemon;
fi
}

remove_wifi(){
rm -f /usr/local/bin/credentials
rm -f /boot/rename_to_credentials.txt
if [[ `service credentials status | grep "active (running)"` ]]; then
	systemctl disable credentials > /dev/null 2>&1;
fi
}

### Renew ssh keys and machine-id
sleep 1s
rm -f /etc/ssh/ssh_host_*
dpkg-reconfigure openssh-server
systemctl restart ssh
rm -f /etc/machine-id
rm -f /var/lib/dbus/machine-id
dbus-uuidgen --ensure=/etc/machine-id
dbus-uuidgen --ensure

### Check Credentials
if [ -e /boot/username.txt ]; then
	/usr/local/bin/whogoesthere > /dev/null 2>&1;
fi
if [ -e /boot/credentials.txt ]; then
	hostname_branding;
fi
if [ -e /boot/credentials.txt ]; then
	connect_wifi;
else
	remove_wifi;
fi

### Clean
if [[ `service credentials status | grep "inactive (dead)"` ]]; then
	:;
else
	systemctl disable credentials > /dev/null 2>&1;
fi
rm -f /usr/local/bin/credentials
rm -f /boot/credentials.txt

exit 0
