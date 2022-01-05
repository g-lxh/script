ARG base_image=golang:latest
# step 构建
FROM $base_image
LABEL maintainer="v.linxh@gmail.com"

# 程序安装
# 下载 https://github.com/EasyDarwin/EasyDarwin/releases/download/v8.1.0/EasyDarwin-linux-8.1.0-1901141151.tar.gz
COPY EasyDarwin-linux-* /usr/local/easydarwin/
ENTRYPOINT ["/bin/bash", "-c", "/usr/local/easydarwin/easydarwin"]