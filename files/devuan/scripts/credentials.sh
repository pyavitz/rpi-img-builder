#!/bin/bash
source /boot/credentials.txt

### Functions
change_hostname(){
sed -i "s/bcm2711/${HOSTNAME}/g" /etc/hostname
sed -i "s/bcm2710/${HOSTNAME}/g" /etc/hostname
sed -i "s/bcm2708/${HOSTNAME}/g" /etc/hostname
sed -i "s/musicbox/${HOSTNAME}/g" /etc/hostname
sed -i "s/bcm2711/${HOSTNAME}/g" /etc/hosts
sed -i "s/bcm2710/${HOSTNAME}/g" /etc/hosts
sed -i "s/bcm2708/${HOSTNAME}/g" /etc/hosts
sed -i "s/musicbox/${HOSTNAME}/g" /etc/hosts
}

change_branding(){
sed -i "s/Raspberry Pi/${BRANDING}/g" /etc/update-motd.d/15-brand
sed -i "s/Raspberry Pi/${BRANDING}/g" /etc/update-motd.d/15-brand
sed -i "s/Raspberry Pi/${BRANDING}/g" /etc/update-motd.d/15-brand
sed -i "s/Musicbox/${BRANDING}/g" /etc/update-motd.d/15-brand
}

dhcp () {
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
iw reg set ${COUNTRYCODE}
sed -i 's/# Default-Start:/# Default-Start: S/g' /etc/init.d/network
sed -i 's/# Default-Stop:/# Default-Stop: 0 6/g' /etc/init.d/network
update-rc.d network defaults S
service network start
}

static () {
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
iw reg set ${COUNTRYCODE}
sed -i 's/# Default-Start:/# Default-Start: S/g' /etc/init.d/network
sed -i 's/# Default-Stop:/# Default-Stop: 0 6/g' /etc/init.d/network
update-rc.d network defaults S
service network start
}

connect_wifi () {
case `grep -Fx "MANUAL=y" "/boot/credentials.txt" >/dev/null; echo $?` in
  0)
    static
    ;;
  1)
    dhcp
    ;;
esac
}

hostname_branding(){
case `grep -Fx "CHANGE=y" "/boot/credentials.txt" >/dev/null; echo $?` in
  0)
    change_hostname
    change_branding
    service hostname.sh --full-restart
    ;;
esac
}

remove_wifi () {
update-rc.d -f credentials remove
sed -i 's/# Default-Start:/# Default-Start: S/g' /etc/init.d/network
sed -i 's/# Default-Stop:/# Default-Stop: 0 6/g' /etc/init.d/network
update-rc.d network defaults S
rm -f /usr/local/bin/credentials > /dev/null 2>&1
rm -f /boot/rename_to_credentials.txt > /dev/null 2>&1
rm -f /etc/opt/interfaces > /dev/null 2>&1
rm -f /etc/opt/wpa_supplicant.conf > /dev/null 2>&1
mv -f /etc/opt/interfaces.manual /etc/network/interfaces
mv -f /etc/opt/wpa_supplicant.manual /etc/wpa_supplicant/wpa_supplicant.conf
service network start
}

### Check Credentials
if ls /boot/username.txt > /dev/null 2>&1; then /usr/local/bin/whogoesthere > /dev/null 2>&1;
        else : > /dev/null 2>&1;
fi
if ls /boot/credentials.txt > /dev/null 2>&1; then hostname_branding;
        else : > /dev/null 2>&1;
fi
if ls /boot/credentials.txt > /dev/null 2>&1; then connect_wifi;
        else remove_wifi > /dev/null 2>&1;
fi

### Renew ssh keys and machine-id
sleep 1s
echo -e "\e[0;31mCreating new ssh keys\e[0m ..."
/bin/rm -v /etc/ssh/ssh_host_* > /dev/null 2>&1
dpkg-reconfigure openssh-server
service ssh restart
rm -f /etc/machine-id
rm -f /var/lib/dbus/machine-id
dbus-uuidgen --ensure=/etc/machine-id
dbus-uuidgen --ensure

### Clean
update-rc.d -f credentials remove
rm -f /usr/local/bin/credentials > /dev/null 2>&1
rm -f /boot/credentials.txt > /dev/null 2>&1
rm -f /etc/opt/interfaces.manual > /dev/null 2>&1
rm -f /etc/opt/wpa_supplicant.manual > /dev/null 2>&1
