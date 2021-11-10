ARG base_image=node:12-alpine
# step 构建
FROM $base_image
LABEL maintainer="v.linxh@gmail.com"

# 时区
ENV TZ=Asia/Shanghai
RUN set -eux && apk add --no-cache --update tzdata && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 程序安装
ENV INSTALL_PATH=/usr/local/yapi
RUN npm install -g yapi-cli --registry https://registry.npm.taobao.org
ADD entrypoint.sh ${INSTALL_PATH}/entrypoint.sh
EXPOSE 3000 9090

# 启动
ENTRYPOINT ${INSTALL_PATH}/entrypoint.sh