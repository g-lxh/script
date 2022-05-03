ARG base_image=alpine:3.15.0
## 构建
FROM $base_image as builder
LABEL maintainer="v.linxh@gmail.com"

# go v1.5 开始,编译需要依赖 go, 故需要先安装 v1.4 版本的 go
ARG VERSION=1.18.1
RUN set -xe;\
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories;\
	apk update;\
	apk add --no-cache --virtual .build-deps git gcc bash musl-dev;\
	mkdir -p /root/repo ; cd /root/repo ;\
    git clone --depth 1 -b go1.4 https://github.com/golang/go.git go1.4;\
    cd go1.4/src/; \
    sed -i 's/"-Werror",//g' cmd/dist/build.c; sed -i 's/-Werror//g' make.bash make.bat runtime/cgo/cgo.go;\
    export CGO_ENABLED=0;\
    sh make.bash;\
    export GOROOT=/root/repo/go1.4; \
    export PATH=$PATH:$GOROOT/bin;\
    go version;\
    mkdir -p /root/repo ; cd /root/repo ;\
	git clone --depth 1 -b go${VERSION} https://github.com/golang/go.git;\
    cd go/src; \
    export CGO_ENABLED=0;\
    sh make.bash;\
    /root/repo/go/bin/go version;


FROM alpine:3.15.0

ENV GOROOT=/usr/local/go
ENV PATH=$PATH:$GOROOT/bin
COPY --from=builder /root/repo/go/ /usr/local/go/
