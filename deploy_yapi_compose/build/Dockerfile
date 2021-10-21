ARG base_image=node:12-alpine
FROM $base_image
LABEL maintainer="v.linxh@gmail.com"
# 时区
ENV TZ=Asia/Shanghai
RUN set -eux && apk add --no-cache --update tzdata && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 安装构建工具
RUN apk add --update --no-cache ca-certificates curl wget cmake build-base git bash python make gcc g++ zlib-dev autoconf automake file nasm

# 指定工作目录
RUN git clone --depth=1 https://github.com/YMFE/yapi.git vendors && \
    cp vendors/config_example.json ./config.json && \
    sed -i "s/127.0.0.1/mongo/g" ./config.json && \
    cd vendors && \
    npm install --production --registry https://registry.npm.taobao.org && \
    npm run install-server

CMD ["node", "server/app.js"]

## 时区
#ENV TZ=Asia/Shanghai
#RUN set -eux; \
#    apk add --no-cache --update tzdata; \
#    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime; \
#    echo $TZ > /etc/timezone
#
## 安装构建工具
#RUN apk add --update --no-cache ca-certificates curl wget cmake build-base git bash python make gcc g++ zlib-dev autoconf automake file nasm && update-ca-certificates
#
## 指定工作目录
#RUN git clone --depth=1 https://github.com/YMFE/yapi.git vendors; \
#    cp vendors/config_example.json ./config.json; \
#    cd vendors; \
#    npm install --production --registry https://registry.npm.taobao.org; \
#    npm run install-server
#
#CMD ["node", "server/app.js"]
#
#export https_proxy=http://10.10.5.55:7890 http_proxy=http://10.10.5.55:7890 all_proxy=socks5://10.10.5.55:7890