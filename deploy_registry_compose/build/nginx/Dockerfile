ARG base_image=nginx:latest
# step 构建
FROM $base_image
LABEL maintainer="v.linxh@gmail.com"

# 程序安装
ADD conf.d/registry.conf /etc/nginx/conf.d/
ADD certs/* /etc/ssl/private/