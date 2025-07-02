# syntax=docker/dockerfile:1

# 仅构建 void-glibc-full 镜像的简化 Containerfile（包含 TARGETPLATFORM）

# 1) 引入 BuildKit 语法，指定构建平台
FROM --platform=${BUILDPLATFORM} alpine:3.22 AS bootstrap

# 2) 构建参数：目标平台、镜像源、LIBC
ARG TARGETPLATFORM
ARG MIRROR=https://repo-ci.voidlinux.org
ARG LIBC=glibc

# 3) 安装基础工具并下载静态 xbps（musl 静态版）
RUN apk add --no-cache ca-certificates curl \
  && curl -fSL "${MIRROR}/static/xbps-static-static-0.59_5.$(uname -m)-musl.tar.xz" \
     | tar -xJ --strip-components=1 -C /

# 4) 拷贝签名密钥和初始化脚本
COPY keys/*         /target/var/db/xbps/keys/
COPY setup.sh       /bootstrap/setup.sh
COPY noextract.conf /target/etc/xbps.d/noextract.conf

# 5) 同步索引（仅索引，不安装包）
RUN --mount=type=cache,sharing=locked,target=/target/var/cache/xbps,id=repocache \
  TARGETPLATFORM=${TARGETPLATFORM} \
  . /bootstrap/setup.sh \
  && XBPS_TARGET_ARCH=$(uname -m) xbps-install -S -R "${REPO}" -r /target

# 6) 安装 full（base-container）变体
FROM bootstrap AS install-full
ARG TARGETPLATFORM
ARG MIRROR
ARG LIBC
COPY --from=bootstrap /target /target
RUN --mount=type=cache,sharing=locked,target=/target/var/cache/xbps,id=repocache \
    TARGETPLATFORM=${TARGETPLATFORM} \
    . /bootstrap/setup.sh \
 && XBPS_TARGET_ARCH=$(uname -m) \
    xbps-install -y -R "${REPO}" -r /target \
      base-container \
      bash \
      make \
      git \
      kmod \
      xz \
      lzo \
      qemu-user-arm \
      qemu-user-aarch64 \
      binfmt-support \
      dosfstools \
      e2fsprogs 

# 7) 最终镜像 —— scratch + 直接 COPY
FROM scratch AS void-glibc-full
COPY --link --from=install-full /target/ /

# 追加收尾：tmp 目录 / 清缓存 / 重配置
RUN install -dm1777 /tmp \
 && xbps-reconfigure -fa \
 && rm -rf /var/cache/xbps/*

CMD ["/bin/sh"]
