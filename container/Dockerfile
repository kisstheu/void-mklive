FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# ── 安装构建所需最小工具链 ───────────────────────────────────────────
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates curl git xz-utils lzop dosfstools e2fsprogs \
        squashfs-tools binutils build-essential gawk texinfo \
        bubblewrap sudo bzip2 unzip libarchive-tools libtool autopoint gettext && \
    rm -rf /var/lib/apt/lists/*

# ── 安装 xbps-static (musl 版即可) ─────────────────────────────────
RUN curl -LO https://repo-default.voidlinux.org/static/xbps-static-latest.x86_64-musl.tar.xz && \
    mkdir -p /opt/xbps && \
    bsdtar -xpf xbps-static-latest.x86_64-musl.tar.xz -C /opt/xbps && \
    chmod -R a+rx /opt/xbps

ENV PATH=/opt/xbps/usr/bin:$PATH

# ── 容器内直接使用 root；创建非特权 builder 作为备用 ─────────────
RUN useradd -m builder
