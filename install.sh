#!/bin/bash

#set -x
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
	exit 1
fi
if [[ `command -v curl` ]]; then
	:;
else
	echo ""
	echo -e "Missing dependency: curl"
	exit 1
fi
if [[ `command -v make` ]]; then
	:;
else
	echo ""
	echo -e "Missing dependency: make"
	exit 1
fi
echo -en "${TXT}Checking Internet Connection:${FIN} "
if [[ `curl -I https://github.com 2>&1 | grep 'HTTP/2 200'` ]]; then
	echo -en "${PNK}[${FIN}${GRN}OK${FIN}${PNK}]${FIN}"
	echo ""
else
	echo -en "${PNK}[${FIN}${RED}failed${FIN}${PNK}]${FIN}"
	echo ""
	echo -e "${TXT}Please check your internet connection and try again${FIN}."
	exit 1
fi
echo -en "${TXT}Checking Host Machine:${FIN} "
sleep .50
if [[ "$HOST_CODENAME" =~ ^(bookworm|bullseye|jammy|noble)$ ]]; then
	echo -en "${PNK}[${FIN}${GRN}${HOST_PRETTY}${FIN}${PNK}]${FIN}"
	echo ""
else
	echo -ne "${PNK}[${FIN}${RED}failed${FIN}${PNK}]${FIN}"
	echo ""
	echo -e "${TXT}The OS you are running is not supported${FIN}."
	exit 1
fi
echo ""
if [[ "$HOST_ARCH" =~ ^(aarch64|x86_64)$ ]]; then
	if [[ "$HOST_ARCH" == "x86_64" ]]; then
		echo -e "${TXT}Starting install ...${FIN}"
		sudo apt update; sudo apt upgrade -y; make ccompile
	fi
	if [[ "$HOST_ARCH" == "aarch64" ]]; then
		echo -e -n "${TXT}"
		echo -e "Arm64 detected. Select the dependencies you would like installed."
		options=("Cross Compile" "Native Compile" "Quit")
		select opt in "${options[@]}"
		do
			case $opt in
				"Cross Compile")
				echo ""
				echo -e "${TXT}Starting install ...${FIN}"
				sudo apt update; sudo apt upgrade -y; make ccompile64
				break
				;;
				"Native Compile")
				echo ""
				echo -e "${TXT}Starting install ...${FIN}"
				sudo apt update; sudo apt upgrade -y; make ncompile
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
else
	echo -e "ARCH: $HOST_ARCH is not supported by this script."
	exit 1
fi

# install builder theme
make dialogrc

# clear
clear -x

# builder options
make help

exit 0
