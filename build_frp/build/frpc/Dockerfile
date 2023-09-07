ARG base_image=golang:alpine
## 构建
FROM $base_image as builder
LABEL maintainer="lxh"

ARG VERSION=0.42.0
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
ENTRYPOINT ["/usr/local/bin/frpc", "-c", "/etc/frp/frpc.ini"]