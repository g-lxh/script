ARG base_image=nginx:latest
# step 构建
FROM $base_image
LABEL maintainer="v.linxh@gmail.com"

# 程序安装
ADD dist.tar.gz /usr/share/nginx/html/
ADD conf.d/web.conf /etc/nginx/conf.d/