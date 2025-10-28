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

# Install script depends
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
	sudo apt install -y curl
fi
if [[ `command -v make` ]]; then
	:;
else
	echo ""
	echo -e "Missing dependency: make"
	sudo apt install -y make
fi
echo ""
echo -en "${TXT}Raspberry Pi Image Builder:${FIN}"
echo -e " ${PNK}[${FIN}${GRN}${GIT_BRANCH}${FIN}${PNK}]${FIN}"
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
if [[ "$HOST_CODENAME" =~ ^(bullseye|bookworm|trixie|jammy|noble|daedalus)$ ]]; then
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
	if [[ "$HOST_ARCH" == "aarch64" ]]; then CMD="ncompile"; else CMD="ccompile"; fi
	echo -e "${TXT}Starting install ...${FIN}"
	sudo apt update; sudo apt upgrade -y; make ${CMD}
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
