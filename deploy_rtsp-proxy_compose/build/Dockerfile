ARG base_image=nginx:latest
# step 构建
FROM $base_image
LABEL maintainer="v.linxh@gmail.com"

# 程序安装
ADD conf.d/rtmp/rtmp.conf /etc/nginx/conf.d/rtmp/
ADD certs/* /etc/ssl/private/