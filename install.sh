#!/bin/bash

source lib/source
RED="\e[0;31m"
GRN="\e[0;32m"
PNK="\e[0;35m"
TXT="\033[0m"
YLW="\e[0;33m"
FIN="\e[0m"
GIT_BRANCH=`git branch`

echo ""
echo -en "${TXT}Raspberry Pi Image Builder:${FIN}"
echo -e " ${PNK}[${FIN}${GRN}${GIT_BRANCH}${FIN}${PNK}]${FIN}"

if [[ `command -v sudo` ]]; then
	:;
else
	echo ""
	echo -e "Missing dependency: sudo"
	echo -e "https://wiki.debian.org/sudo"
	exit 0
fi
if [[ `command -v curl` ]]; then
	:;
else
	echo ""
	echo -e "Missing dependency: curl"
	sudo apt install -y curl wget
fi
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
if [[ "$HOST_CODENAME" == "jammy" ]]; then
	echo -en "${PNK}[${FIN}${GRN}Ubuntu Jammy Jellyfish${FIN}${PNK}]${FIN}"
	echo ""
else
	if [[ "$HOST_CODENAME" == "bullseye" ]]; then
		echo -en "${PNK}[${FIN}${GRN}Debian Bullseye${FIN}${PNK}]${FIN}"
		echo ""
	else
		if [[ "$HOST_CODENAME" == "bookworm" ]]; then
			echo -en "${PNK}[${FIN}${GRN}Debian Bookworm${FIN}${PNK}]${FIN}"
			echo ""
		else
			if [[ "$HOST_CODENAME" == "noble" ]]; then
				echo -en "${PNK}[${FIN}${GRN}Ubuntu Noble Numbat${FIN}${PNK}]${FIN}"
				echo ""
			else
				echo -ne "${PNK}[${FIN}${RED}failed${FIN}${PNK}]${FIN}"
				echo ""
				echo -e "${TXT}The OS you are running is not supported${FIN}."
				exit 0
			fi
		fi
	fi
fi
echo ""
if [[ "$HOST_ARCH" == "x86_64" || "$HOST_ARCH" == "aarch64" ]]; then
	:;
else
	echo -e "ARCH: $HOST_ARCH is not supported by this script."
	exit 0
fi

if [[ "$HOST_ARCH" == "x86_64" ]]; then
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

if [[ "$HOST_ARCH" == "aarch64" ]]; then
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
