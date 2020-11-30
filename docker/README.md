# Docker container to build images

You have the possibility to build the image with the Dockerfile or fetch your images from pttrr/arm-image-builder

**Bulding:**

docker-compose --compatibility up -d --build

**Pulling-Image**

docker-compose up -d

When the container is successfully created you can exec into it with the following command:

docker exec -it arm-image-builder bash

**The Dockerfile is downloading serveral repos:**

rpi-image-builder is located at /build/rpi - you will find more here: https://github.com/pyavitz/rpi-img-builder
debian image builder is located at /build/debian you will find more here: https://github.com/pyavitz/debian-img-builder
Native-Kernel-Compiler is located at /build/kernelbuiild - you will find more here : https://github.com/pyavitz/builddeb

So if you want for example build your Image with the RPi-Image-Builder and youre in the container run following commands:
"cd rpi"
"make config" or "make mlconfig" for the mainline kernel
Then run "make helper" for downloading the kernel from the rpi-firmware
For building your rootfs run following commands: "make rootfs" (arm64) or "make rootsv6" (armel)
Now run "make image" or "make rpi3-image" or "make rpi-image" and your image will be created.

**Get the builded image to your host system**

"docker cp arm-image-builder:/build/path/to/image . "

Its not perfect right now, but its working and were gonna improve it time to time.
