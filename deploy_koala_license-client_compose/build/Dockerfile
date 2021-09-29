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
ADD license-client-1.0-SNAPSHOT.jar /usr/local/license-client/license-client-1.0-SNAPSHOT.jar
EXPOSE 12000
CMD java -jar /usr/local/license-client/license-client-1.0-SNAPSHOT.jar