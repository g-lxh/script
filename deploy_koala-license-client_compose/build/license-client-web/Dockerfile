ARG base_image=nginx:latest
FROM $base_image
LABEL maintainer="v.linxh@gmail.com"

# 应用程序
RUN rm -rf /etc/nginx/conf.d/*
ADD nginx.conf /etc/nginx/
ADD koalauran-license-client.conf /etc/nginx/conf.d/
ADD license-client-web.tar.gz /usr/share/nginx/html/
