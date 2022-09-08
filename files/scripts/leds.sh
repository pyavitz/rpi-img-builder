#!/bin/bash

if [[ -f "/sys/class/leds/led0/trigger" ]]; then
	ACTIVITY="/sys/class/leds/led0/trigger"
fi
if [[ -f "/sys/class/leds/ACT/trigger" ]]; then
	ACTIVITY="/sys/class/leds/ACT/trigger"
fi
if [[ -f "/sys/class/leds/led1/brightness" ]]; then
	POWER="/sys/class/leds/led1/brightness"
fi
if [[ -f "/sys/class/leds/PWR/brightness" ]]; then
	POWER="/sys/class/leds/PWR/brightness"
fi

# set act and pwr leds
if [[ -f "$ACTIVITY" ]]; then
	ROOT_DEVICE=`findmnt -v -n -o SOURCE /`
	ROOT_DEVICE=${ROOT_DEVICE/\/dev\//}
	ROOT_DEVICE=${ROOT_DEVICE/mmcblk/mmc}
	ROOT_DEVICE=${ROOT_DEVICE/p[0-9]/}
	echo -n "$ROOT_DEVICE" > $ACTIVITY
fi
if [[ -f "$POWER" ]]; then
	sh -c 'echo 0 > $POWER'
fi
