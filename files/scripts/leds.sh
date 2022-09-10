#!/bin/bash
# Bind root activity to green LED
# Turn off power LED

# foundation kernel
if [ -f /sys/class/leds/led0/trigger ]; then
	ACT="led0"
fi
if [ -f /sys/class/leds/led1/brightness ]; then
	PWR="led1"
fi
# mainline kernel
if [ -f /sys/class/leds/ACT/trigger ]; then
	ACT="ACT"
fi
if [ -f /sys/class/leds/PWR/brightness ]; then
	PWR="PWR"
fi

if [ -f /sys/class/leds/$ACT/trigger ]; then
	ROOT_DEVICE=`findmnt -v -n -o SOURCE /`
	ROOT_DEVICE=${ROOT_DEVICE/\/dev\//}
	ROOT_DEVICE=${ROOT_DEVICE/mmcblk/mmc}
        ROOT_DEVICE=${ROOT_DEVICE/p[0-9]/}
	echo -n "$ROOT_DEVICE" > /sys/class/leds/$ACT/trigger
fi

if [ -f /sys/class/leds/$PWR/brightness ]; then
	echo "0" > /sys/class/leds/$PWR/brightness
fi
