#!/bin/bash

RED="\e[0;31m"
GRN="\e[0;32m"
PNK="\e[0;35m"
TXT="\033[0m"
YLW="\e[0;33m"
FIN="\e[0m"
ARCH=`uname -m`

if [[ -e "/etc/os-release" ]]; then
	RELEASE=`cat /etc/os-release | grep -w VERSION_CODENAME | sed 's/VERSION_CODENAME=//g'`
else
	RELEASE="none"
fi
if [[ `command -v curl` ]]; then
	:;
else
	echo ""
	echo -e "Missing dependency: curl"
	sudo apt install -y curl wget
	exit 0
fi

echo ""
echo -en "${TXT}Checking Internet Connection:${FIN} "
if [[ `curl -I https://github.com 2>&1 | grep 'HTTP/2 200'` ]]; then
	echo -en "${PNK}[${FIN}${GRN}OK${FIN}${PNK}]${FIN}"
	echo ""
else
	echo -en "${PNK}[${FIN}${RED}failed${FIN}${PNK}]${FIN}"
	echo ""
	echo -e "${TXT}Please check your internet connection and try again${FIN}."
	exit 0
fi
echo -en "${TXT}Checking Host Machine:${FIN} "
sleep .50
if [[ "$RELEASE" == "jammy" ]]; then
	echo -en "${PNK}[${FIN}${GRN}Ubuntu Jammy Jellyfish${FIN}${PNK}]${FIN}"
	echo ""
else
	if [[ "$RELEASE" == "bullseye" ]]; then
		echo -en "${PNK}[${FIN}${GRN}Debian Bullseye${FIN}${PNK}]${FIN}"
		echo ""
	else
		echo -ne "${PNK}[${FIN}${RED}failed${FIN}${PNK}]${FIN}"
		echo ""
		echo -e "${TXT}The OS you are running is not supported${FIN}."
		exit 0
	fi
fi
echo ""
if [[ "$ARCH" == "x86_64" || "$ARCH" == "aarch64" ]]; then
	:;
else
	echo -e "ARCH: $ARCH is not supported by this script."
fi

if [[ "$ARCH" == "x86_64" ]]; then
	echo -e "${TXT}Starting install ...${FIN}"
	sleep .50
	if [[ `command -v make` ]]; then
		sudo apt update
		sudo apt upgrade -y
		make ccompile
	else
		sleep 1s
		sudo apt update
		sudo apt upgrade -y
		sudo apt install -y make
		make ccompile
	fi
fi

if [[ "$ARCH" == "aarch64" ]]; then
	echo -e -n "${TXT}"
	echo -e "Arm64 detected. Select the dependencies you would like installed."
	options=("Cross Compiling" "Native Compiling" "Quit")
	select opt in "${options[@]}"
	do
		case $opt in
			"Cross Compiling")
			if [[ `command -v make` ]]; then
				echo ""
				echo -e "${TXT}Starting install ...${FIN}"
				sleep 1s
				sudo apt update
				sudo apt upgrade -y
				make ccompile64
			else
				echo ""
				echo -e "${TXT}Starting install ...${FIN}"
				sleep 1s
				sudo apt update
				sudo apt upgrade -y
				sudo apt install -y make
				make ccompile64
			fi
				break
				;;
			"Native Compiling")
			if [[ `command -v make` ]]; then
				echo ""
				echo -e "${TXT}Starting install ...${FIN}"
				sleep 1s
				sudo apt update
				sudo apt upgrade -y
				make ncompile
			else
				echo ""
				echo -e "${TXT}Starting install ...${FIN}"
				sleep 1s
				sudo apt update
				sudo apt upgrade -y
				sudo apt install -y make
				make ncompile
			fi
				break
				;;
			"Quit")
				break
				;;
			*)
				echo "invalid option $REPLY"
				;;
		esac
	done
	echo -e -n "${FIN}"
fi

# install builder theme
make dialogrc

# clear
clear -x

# builder options
make help

exit 0
