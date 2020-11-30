# Docker container for building your arm image

> You have the possibility to build the image with the Dockerfile or fetch your images from pttrr/arm-img-builder

## Bulding the docker image and start the container:

`docker-compose --compatibility up -d --build`

When the container is successfully created you can exec into it with the following command:

`docker exec -it arm-img-builder bash`

## The Dockerfile is fetching serveral repos:

* rpi-image-builder is located at /build/rpi-img-builder - you will find more here: https://github.com/pyavitz/rpi-img-builder
* debian image builder is located at /build/debian-img-builder you will find more here: https://github.com/pyavitz/debian-img-builder
* Native-Kernel-Compiler is located at /build/kernelbuild - you will find more here : https://github.com/pyavitz/builddeb

So if you want for example build your Image with the rpi-img-builder and youre in the container run following commands:

```
cd /build/rpi
make config
make mlconfig for the mainline kernel
```
You can build the kernel yourself or fetch it from the raspbian repos:

`make helper`

For building your rootfs run following commands:

```
make rootfs (arm64)
make rootsv6 (armel)
```

Finally start building your arm image:

```
make image
make rpi3-image
make rpi-image
```

When your image is successfully builded you can copy it with the following command:

`docker cp arm-img-builder:/build/path/to/image .`

Its not perfect right now, but its working and were gonna improve it time to time.
