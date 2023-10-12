ARG base_image=golang:alpine
## 构建
FROM $base_image as builder
LABEL maintainer="lxh"

ARG VERSION=0.51.3
RUN set -xe;\
	apk update;\
	apk add --no-cache --virtual .build-deps git zip make;\
	mkdir -p /root/repo; cd /root/repo;\
	git clone -b v${VERSION} https://github.com/fatedier/frp.git;\
    cd frp; sh package.sh;\
    ls -lh .;

FROM alpine:3.15.0
COPY --from=builder /root/repo/frp/bin/frpc /usr/local/bin/
COPY --from=builder /root/repo/frp/conf/frpc.ini /etc/frp/frpc.ini
COPY --from=builder /root/repo/frp/conf/frpc_full.ini /etc/frp/frpc_full.ini

# 源更新
RUN set -eux; \
    sed -n '/^[^#].*/p' /etc/apk/repositories; \
    sed -n 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/p' /etc/apk/repositories; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories; \
    apk update

# 时区
ENV TZ=Asia/Shanghai
RUN set -eux; \
    apk add tzdata; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime; \
    echo $TZ > /etc/timezone

# 工具集
RUN set -eux; \
    apk add bash vim wget busybox-extras curl tcpdump net-tools netcat-openbsd iputils

# 日志目录
RUN set -eux; \
    mkdir -p /var/log/frp

ADD Dockerfile /Dockerfile
CMD ["/usr/local/bin/frpc", "-c", "/etc/frp/frpc.ini"]