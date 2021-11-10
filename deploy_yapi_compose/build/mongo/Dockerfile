ARG base_image=mongo:latest
# step 构建
FROM $base_image
LABEL maintainer="v.linxh@gmail.com"

# 程序安装
ADD mongo-init.sh /docker-entrypoint-initdb.d/mongo-init.sh