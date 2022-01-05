# step 构建
FROM node:12-alpine as builder
LABEL maintainer="v.linxh@gmail.com"

# 程序安装
WORKDIR /yapi
RUN apk add --no-cache wget make
ENV VERSION=1.9.2
RUN wget https://github.com.cnpmjs.org/YMFE/yapi/archive/v${VERSION}.zip
RUN unzip v${VERSION}.zip && mv yapi-${VERSION} vendors
RUN echo $'{ \n\
  "port": "3000",\n\
  "adminAccount": "admin@admin.com",\n\
  "timeout":120000,\n\
  "db": {\n\
    "servername": "mongo",\n\
    "DATABASE": "yapi",\n\
    "port": 27017,\n\
    "user": "root",\n\
    "pass": "root",\n\
    "authSource": "admin"\n\
  }\n\
}' > /yapi/config.json
RUN cd /yapi/vendors && npm install --production --registry https://registry.npm.taobao.org


FROM node:12-alpine
LABEL maintainer="v.linxh@gmail.com"
# 时区
ENV TZ=Asia/Shanghai
RUN set -eux && apk add --no-cache --update tzdata && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /yapi/vendors
COPY --from=builder /yapi/vendors /yapi/vendors
COPY --from=builder /yapi/config.json /yapi/config.json
EXPOSE 3000