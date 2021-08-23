#!/bin/bash
source /boot/credentials.txt

### Functions
change_hostname(){
sed -i "s/bcm2711/${HOSTNAME}/g" /etc/hostname
sed -i "s/bcm2710/${HOSTNAME}/g" /etc/hostname
sed -i "s/bcm2709/${HOSTNAME}/g" /etc/hostname
sed -i "s/bcm2708/${HOSTNAME}/g" /etc/hostname
sed -i "s/bcm2711/${HOSTNAME}/g" /etc/hosts
sed -i "s/bcm2710/${HOSTNAME}/g" /etc/hosts
sed -i "s/bcm2709/${HOSTNAME}/g" /etc/hosts
sed -i "s/bcm2708/${HOSTNAME}/g" /etc/hosts
}

change_branding(){
sed -i "s/Raspberry Pi/${BRANDING}/g" /etc/update-motd.d/15-brand
}

dhcp(){
sed -i "s/wlan_address 10.0.0.10/#address 10.0.0.10/g" /etc/opt/interfaces
sed -i "s/wlan_netmask 255.255.255.0/#netmask 255.255.255.0/g" /etc/opt/interfaces
sed -i "s/wlan_gateway 10.0.0.1/#gateway 10.0.0.1/g" /etc/opt/interfaces
sed -i "s/wlan_dns-nameservers 8.8.8.8 8.8.4.4/#dns-nameservers 8.8.8.8 8.8.4.4/g" /etc/opt/interfaces
sed -i "s/REGDOMAIN=/REGDOMAIN=${COUNTRYCODE}/g" /etc/default/crda
sed -i "s/country=/country=${COUNTRYCODE}/g" /etc/opt/wpa_supplicant.conf
sed -i 's/name=/ssid="'"${SSID}"'"/g' /etc/opt/wpa_supplicant.conf
sed -i 's/password=/psk="'"${PASSKEY}"'"/g' /etc/opt/wpa_supplicant.conf
mv -f /etc/opt/interfaces /etc/network/interfaces
mv -f /etc/opt/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf
sleep 1s
iw reg set ${COUNTRYCODE}
sed -i 's/# Default-Start:/# Default-Start: S/g' /etc/init.d/network
sed -i 's/# Default-Stop:/# Default-Stop: 0 6/g' /etc/init.d/network
update-rc.d network defaults S
sleep 1s
service network start
}

static(){
sed -i "s/iface wlan0 inet dhcp/iface wlan0 inet static/g" /etc/opt/interfaces
sed -i "s/wlan_address 10.0.0.10/address ${IPADDR}/g" /etc/opt/interfaces
sed -i "s/wlan_netmask 255.255.255.0/netmask ${NETMASK}/g" /etc/opt/interfaces
sed -i "s/wlan_gateway 10.0.0.1/gateway ${GATEWAY}/g" /etc/opt/interfaces
sed -i "s/wlan_dns-nameservers 8.8.8.8 8.8.4.4/dns-nameservers ${NAMESERVERS}/g" /etc/opt/interfaces
sed -i "s/REGDOMAIN=/REGDOMAIN=${COUNTRYCODE}/g" /etc/default/crda
sed -i "s/country=/country=${COUNTRYCODE}/g" /etc/opt/wpa_supplicant.conf
sed -i 's/name=/ssid="'"${SSID}"'"/g' /etc/opt/wpa_supplicant.conf
sed -i 's/password=/psk="'"${PASSKEY}"'"/g' /etc/opt/wpa_supplicant.conf
mv -f /etc/opt/interfaces /etc/network/interfaces
mv -f /etc/opt/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf
sleep 1s
iw reg set ${COUNTRYCODE}
sed -i 's/# Default-Start:/# Default-Start: S/g' /etc/init.d/network
sed -i 's/# Default-Stop:/# Default-Stop: 0 6/g' /etc/init.d/network
update-rc.d network defaults S
sleep 1s
service network start
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
	service hostname.sh --full-restart;
	if service avahi-daemon status | grep is\ running > /dev/null 2>&1; then
		service avahi-daemon restart;
	fi
fi
}

remove_wifi(){
update-rc.d -f credentials remove
sed -i 's/# Default-Start:/# Default-Start: S/g' /etc/init.d/network
sed -i 's/# Default-Stop:/# Default-Stop: 0 6/g' /etc/init.d/network
sleep 1s
update-rc.d network defaults S
rm -f /usr/local/bin/credentials
rm -f /boot/rename_to_credentials.txt
rm -f /etc/opt/{interfaces,wpa_supplicant.conf}
mv -f /etc/opt/interfaces.manual /etc/network/interfaces
mv -f /etc/opt/wpa_supplicant.manual /etc/wpa_supplicant/wpa_supplicant.conf
sleep 1s
service network start
}

### Check Credentials
if [ -e /boot/username.txt ]; then
	/usr/local/bin/whogoesthere > /dev/null 2>&1;
fi
if [ -e /boot/credentials.txt ]; then
	hostname_branding;
fi
if [ -e /boot/credentials.txt ]; then
	connect_wifi;
fi

### Renew ssh keys and machine-id
sleep 1s
echo -e " \e[0;31mCreating new ssh keys\e[0m ..."
rm -f /etc/ssh/ssh_host_*
dpkg-reconfigure openssh-server
service ssh restart
rm -f /etc/machine-id
rm -f /var/lib/dbus/machine-id
dbus-uuidgen --ensure=/etc/machine-id
dbus-uuidgen --ensure

### Clean
update-rc.d -f credentials remove
rm -f /usr/local/bin/credentials
rm -f /boot/credentials.txt
rm -f /etc/opt/{interfaces.manual,wpa_supplicant.manual}

exit 0
