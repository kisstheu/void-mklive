FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates curl git xz-utils lzop dosfstools e2fsprogs \
        squashfs-tools binutils build-essential gawk texinfo bubblewrap \
        bzip2 unzip libarchive-tools libtool autopoint gettext && \
    rm -rf /var/lib/apt/lists/*

# 下载最新 musl 版 xbps-static 并解压到 /opt/xbps
RUN curl -LO https://repo-default.voidlinux.org/static/xbps-static-latest.x86_64-musl.tar.xz && \
    mkdir -p /opt/xbps && \
    bsdtar -xpf xbps-static-latest.x86_64-musl.tar.xz -C /opt/xbps && \
    chmod -R a+rx /opt/xbps

ENV PATH=/opt/xbps/usr/bin:${PATH}
