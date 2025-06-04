FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates curl git xz-utils lzop dosfstools e2fsprogs \
        squashfs-tools binutils build-essential gawk texinfo \
        bubblewrap sudo bzip2 unzip libarchive-tools libtool autopoint gettext \
        bsdtar && \
    rm -rf /var/lib/apt/lists/*

# ── 安装 xbps-static (musl 版即可) ────────────────────────────────
RUN curl -LO https://repo-default.voidlinux.org/static/xbps-static-latest.x86_64-musl.tar.xz && \
    mkdir -p /opt/xbps && \
    bsdtar -xpf xbps-static-latest.x86_64-musl.tar.xz -C /opt/xbps && \
    chmod -R a+rx /opt/xbps

ENV PATH=/opt/xbps/usr/bin:$PATH

# ── 创建 builder 非特权用户 ─────────────────────────────────────
RUN useradd -m builder && \
    mkdir -p /etc/sudoers.d && \
    echo "builder ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/builder && \
    chmod 0440 /etc/sudoers.d/builder
