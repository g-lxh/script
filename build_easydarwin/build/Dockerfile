ARG base_image=alpine:3.15.0
FROM $base_image as builder
LABEL maintainer="v.linxh@gmail.com"

ARG VERSION=8.1.0-1901141151
RUN set -xe; \
    # bash
    apk add bash && \
    # EasyDarwin 安装
    wget https://github.com/EasyDarwin/EasyDarwin/releases/download/v${VERSION%-*}/EasyDarwin-linux-${VERSION}.tar.gz -O EasyDarwin-linux-${VERSION}.tar.gz && \
    tar -zxvf EasyDarwin-linux-${VERSION}.tar.gz && \
    rm -rf EasyDarwin-linux-${VERSION}/*.sh && \
    ls -d EasyDarwin-linux-${VERSION} | xargs -i cp -r {} /root/EasyDarwin && \
    # glibc 扩展，不能用 2.35 版本
    wget --no-check-certificate -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget --no-check-certificate https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-2.34-r0.apk && \
    apk add glibc-2.34-r0.apk && \
    rm -rf glibc-2.34-r0.apk EasyDarwin-linux-${VERSION}*;

WORKDIR /root/EasyDarwin

CMD ["/root/EasyDarwin/easydarwin"]