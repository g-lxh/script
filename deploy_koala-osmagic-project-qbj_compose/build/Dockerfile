ARG base_image=openjdk:8-alpine
FROM $base_image
LABEL maintainer="v.linxh@gmail.com"

# 时区
ENV TZ=Asia/Shanghai
RUN set -eux; \
    apk add --no-cache --update tzdata; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime; \
    echo $TZ > /etc/timezone

# 应用程序
ENV app_dir=/usr/local/koala-osmagic-project-qbj/
ADD osmagic-project-qbj-*.jar ${app_dir}
EXPOSE 8100
CMD cd ${app_dir} && java -jar osmagic-project-qbj-1.0.jar