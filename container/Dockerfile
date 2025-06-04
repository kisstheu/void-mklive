FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 必要宿主工具：mklive 依赖 loop-mount、mksquashfs、xz、modprobe 等
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates curl git xz-utils lzop dosfstools e2fsprogs \
        libarchive-tools squashfs-tools kmod util-linux genisoimage mtools \
        build-essential && \
    rm -rf /var/lib/apt/lists/*

# 装入 xbps-static（仅为了在 host 侧执行 xbps-install 等）
RUN curl -LO https://repo-default.voidlinux.org/static/xbps-static-latest.x86_64-musl.tar.xz && \
    mkdir -p /opt/xbps && \
    bsdtar -xpf xbps-static-latest.x86_64-musl.tar.xz -C /opt/xbps && \
    chmod -R a+rx /opt/xbps

ENV PATH=/opt/xbps/usr/bin:$PATH
