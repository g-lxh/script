ARG base_image=nginx:latest
FROM ${base_image} as builder
# 模型版本、名称、下载地址
ARG MODULE_VERSION=0.62
ARG MODULE_NAME=echo-nginx-module
ARG MODULE_URL=https://codeload.github.com/openresty/echo-nginx-module/tar.gz/refs/tags/v0.62
LABEL maintainer="v.linxh@gmail.com"

RUN cd /tmp && \
    apt-get -y update && \
    apt-get -y install openssl libssl-dev gcc libpcre3 libpcre3-dev zlib1g zlib1g.dev make && \
    VERSION=$(nginx -V 2>&1 | sed -n -e 's/^nginx version:.*\///p') \
    CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') \
    MODULE_PATH=$(nginx -V 2>&1 | sed -n -e 's/^.*modules-path=\(\S*\).*/\1/p') \
    NGINX_PATH=$(which nginx) && \
    curl -L https://nginx.org/download/nginx-${VERSION}.tar.gz -o nginx-${VERSION}.tar.gz && \
    curl -L ${MODULE_URL} -o ${MODULE_NAME}.tar.gz && \
    tar -zxvf nginx-${VERSION}.tar.gz && \
    tar -zxvf ${MODULE_NAME}.tar.gz && \
    cd nginx-${VERSION} && \
    echo ${CONFARGS} --add-dynamic-module=/tmp/${MODULE_NAME}-${MODULE_VERSION}/ | xargs ./configure && \
    make && \
    cp -r /tmp/nginx-${VERSION}/objs/*.so ${MODULE_PATH} && \
    cp -r /tmp/nginx-${VERSION}/objs/nginx ${NGINX_PATH} && \
    nginx -t

FROM ${base_image}
COPY --from=builder /usr/lib/nginx/modules /usr/lib/nginx/modules
COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx