FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# ── install base toolchain & deps ───────────────────────────
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates curl git xz-utils lzop dosfstools e2fsprogs \
        squashfs-tools binutils build-essential gawk texinfo \
        bubblewrap sudo bzip2 unzip libarchive-tools libtool autopoint gettext && \
    rm -rf /var/lib/apt/lists/*

# ── install xbps‑static (musl build) ─────────────────────────
RUN curl -LO https://repo-default.voidlinux.org/static/xbps-static-latest.x86_64-musl.tar.xz && \
    mkdir -p /opt/xbps && \
    bsdtar -xpf xbps-static-latest.x86_64-musl.tar.xz -C /opt/xbps && \
    chmod -R a+rx /opt/xbps

ENV PATH=/opt/xbps/usr/bin:$PATH

# ── make bwrap set‑uid root so unprivileged user can use it ──
RUN chmod u+s /usr/bin/bwrap

# ── add non‑root builder user (no sudo needed) ───────────────
RUN useradd -m builder
