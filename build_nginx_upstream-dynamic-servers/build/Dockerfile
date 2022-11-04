ARG base_image=nginx:1.21.6
FROM $base_image as builder
LABEL maintainer="v.linxh@gmail.com"

# 源替换
RUN set -xe; \
    sed -i 's#deb.debian.org#mirrors.ustc.edu.cn#g' /etc/apt/sources.list && \
    sed -i 's#security.debian.org#mirrors.ustc.edu.cn#g' /etc/apt/sources.list && \
    apt-get update;

# 自定义添加模块 nginx-upstream-dynamic-servers
# 模型版本、名称、下载地址
ARG MODULE_VERSION=0.0.0
ARG MODULE_NAME=nginx-upstream-dynamic-servers
ARG MODULE_REPO=https://ghproxy.com/https://github.com/GUI/nginx-upstream-dynamic-servers.git
RUN set -xe; \
    cd /tmp && \
    apt-get -y update && \
    apt-get -y install openssl libssl-dev gcc libpcre3 libpcre3-dev zlib1g zlib1g.dev make git && \
    VERSION=$(nginx -V 2>&1 | sed -n -e 's/^nginx version:.*\///p') && \
    ARGUMENTS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') && \
    MODULE_PATH=$(nginx -V 2>&1 | sed -n -e 's/^.*modules-path=\(\S*\).*/\1/p') && \
    NGINX_PATH=$(which nginx) && \
    curl -L https://nginx.org/download/nginx-${VERSION}.tar.gz -o nginx-${VERSION}.tar.gz && \
    git clone --depth=1 ${MODULE_REPO} ${MODULE_NAME} && \
    tar -zxvf nginx-${VERSION}.tar.gz && \
    cd nginx-${VERSION} && \
    echo ${ARGUMENTS} --add-dynamic-module=/tmp/${MODULE_NAME} | xargs ./configure && \
    make && \
    cp -r /tmp/nginx-${VERSION}/objs/nginx /tmp/ && \
    /tmp/nginx -t;

# 添加 stream 支持，默认读取 /etc/nginx/conf.d/*.stream
RUN echo "\nstream {\n\
    "# see https://nginx.org/en/docs/varindex.html"\n\
    log_format proxy '\$remote_addr [\$time_local] '\n\
                     '\$protocol \$status \$bytes_sent \$bytes_received '\n\
                     '\$session_time \"\$upstream_addr\" '\n\
                     '\"\$upstream_bytes_sent\" \"\$upstream_bytes_received\" \"\$upstream_connect_time\"';\n\n\
    access_log /var/log/nginx/tcp-access.log proxy ;\n\n\
    "# see https://nginx.org/en/docs/http/ngx_http_log_module.html#open_log_file_cache"\n\
    open_log_file_cache max=1000 inactive=20s valid=1m min_uses=2;\n\n\
    include /etc/nginx/conf.d/*.stream;\n\
}" >> /etc/nginx/nginx.conf

FROM $base_image
# 基础
COPY --from=builder /tmp/nginx /tmp/nginx
COPY --from=builder /etc/nginx/nginx.conf /etc/nginx/nginx.conf

RUN set -xe; \
    NGINX_PATH=$(which nginx) && \
    mv /tmp/nginx ${NGINX_PATH};

# 应用程序