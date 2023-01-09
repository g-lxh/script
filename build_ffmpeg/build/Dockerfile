ARG base_image=debian:11.5
## 编译构建步骤
FROM $base_image as builder
LABEL maintainer="v.linxh@gmail.com"

RUN set -xe;\
    sed -i 's#deb.debian.org#mirrors.ustc.edu.cn#g' /etc/apt/sources.list && \
    sed -i 's#security.debian.org#mirrors.ustc.edu.cn#g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y wget xz-utils && \
    wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz && \
    tar -xvf ffmpeg-release-amd64-static.tar.xz && \
    find /ffmpeg-* -name ffmpeg | xargs -i cp {} /usr/local/bin/

## 镜像制作步骤
FROM alpine:3.15.0
COPY --from=builder /usr/local/bin/ /usr/local/bin/