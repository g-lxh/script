ARG base_image=alpine:latest
# 构建
FROM $base_image
LABEL maintainer="v.linxh@gmail.com"

RUN apk add openssl ncurses go



# 应用程序
ENV app_dir=/usr/local/koala-hitech-cloud
ADD koala-hitech-cloud-*-pkg.tar.gz ${app_dir}
ADD application.yml ${app_dir}/conf/
EXPOSE 8088
CMD ${app_dir}/bin/run.sh


# 打包
ENV TZ=Asia/Shanghai
RUN set -eux; \
    apk add --no-cache --update tzdata; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime; \
    echo $TZ > /etc/timezone