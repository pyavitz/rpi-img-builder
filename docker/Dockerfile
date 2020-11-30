FROM debian:buster-slim

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y  \
    build-essential \
    ca-certificates \
    apt-transport-https \
    wget \
    bison \
    mc \
    git \
    dialog \
    patch \
    zip \
    bc \
    nano \
    libterm-readline-gnu-perl \
    systemd \
    systemd \
    systemd-container \
    debootstrap \
    sudo \
    binfmt-support \
    procps \
    dbus \
    unzip \
    qemu \
    dosfstools \
    qemu-user-static \
    rsync \
    kmod \
    cpio \
    flex \
    libssl-dev \
    libncurses5-dev \
    parted \
    fakeroot \
    swig \
    aria2 \
    pv \
    toilet \
    figlet \
    crossbuild-essential-arm64 \
    crossbuild-essential-armel \
    udev \
    unzip \
    gcc-aarch64-linux-gnu \
    gcc-arm-linux-gnueabi \
    distro-info-data \
    lsb-release \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN rm -rf /tmp/* /var/tmp/* /var/cache/apt/*.bin \
    /var/lib/dpkg/*-old /var/cache/debconf/*-old

RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
    /lib/systemd/system/systemd-update-utmp* && \
    mkdir build


RUN git clone https://github.com/pyavitz/rpi-img-builder.git /build/rpi-img-builder

RUN git clone https://github.com/pyavitz/debian-image-builder.git /build/debian-image-builder

RUN git clone https://github.com/pyavitz/builddeb.git /build/kernelbuild

WORKDIR /build

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/lib/systemd/systemd"]
