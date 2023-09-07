FROM registry.cn-hangzhou.aliyuncs.com/prince/alpine-golang:1.17 as builder
MAINTAINER s_jqzhang <s_jqzhang@163.com>
ARG VERSION=1.4.5
RUN set -xe; \
	apk update; \
	apk add --no-cache --virtual .build-deps \
	git; \
	mkdir -p /root/repo ; cd /root/repo ; \
	git clone -b v${VERSION} https://github.com/sjqzhang/go-fastdfs ; \
	cd go-fastdfs; mv vendor src ; mv src .. ; cd .. ; mv go-fastdfs src/github.com/sjqzhang/ ; export GOPATH=/root/repo ; cd  src/github.com/sjqzhang/go-fastdfs ; \
    # 关闭认证
	# sed -i 's#//\(return true\)#\1#g'  server/fileserver.go; \
	 export GO111MODULE="off"; \
	CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o fileserver; \
	ls -lh .;

FROM alpine

# 源更新
RUN set -eux; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories; \
    apk update

# 时区
ENV TZ=Asia/Shanghai
RUN set -eux; \
    apk add --no-cache tzdata; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime; \
    echo $TZ > /etc/timezone

# 工具集
RUN set -eux; \
    apk add --no-cache bash vim curl busybox-extras tcpdump

# vim 鼠标模式转可视模式
RUN set -eux; \
    vim_default_path=$(find /usr/share/vim/ -name defaults.vim); \
    sed -i 's/set mouse=.*/set mouse=""/' ${vim_default_path}

COPY --from=builder /root/repo/src/github.com/sjqzhang/go-fastdfs/fileserver /

ENV INSTALL_DIR /usr/local/go-fastdfs

ENV PATH $PATH:$INSTALL_DIR/

ENV GO_FASTDFS_DIR $INSTALL_DIR/data

RUN set -xe; \
	mkdir -p $GO_FASTDFS_DIR; \
	mkdir -p $GO_FASTDFS_DIR/conf; \
	mkdir -p $GO_FASTDFS_DIR/data; \
	mkdir -p $GO_FASTDFS_DIR/files; \
	mkdir -p $GO_FASTDFS_DIR/log; \
	mkdir -p $INSTALL_DIR; \
	mv /fileserver $INSTALL_DIR/; \
	chmod +x $INSTALL_DIR/fileserver;

WORKDIR $INSTALL_DIR

VOLUME $GO_FASTDFS_DIR

CMD ["fileserver", "server" , "${OPTS}"]