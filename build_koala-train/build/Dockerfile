ARG base_image=nvidia/cuda:11.4.2-base-ubuntu20.04
## 构建
FROM $base_image
LABEL maintainer="v.linxh@gmail.com"

ENV LANG=C.UTF-8
RUN set -ex \
# 预安装所需组件
&& apt-get update && apt-get install -y python3 python3-pip libgl1-mesa-glx libglib2.0-dev

ADD obj-detect /root/obj-detect/
RUN set -ex \
&& pip install -r /root/obj-detect/requirements.txt