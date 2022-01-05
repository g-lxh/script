ARG base_image=alpine:3.15.0
## 构建
FROM $base_image
LABEL maintainer="v.linxh@gmail.com"
# busybox 扩展
RUN apk add busybox-extras curl
# 训练数据下载
RUN echo $'#!/bin/sh\n\n\
_base_path=$(cd `dirname $0`;pwd) \n\
echo ${_base_path} \n\
if [ -z ${PLATFORM_FILE_PATH} ]; then \n\
  echo "PLATFORM_FILE_PATH env does not exist" \n\
  exit 1 \n\
fi \n\n\
if [ -z ${PLATFORM_FILE_URL} ]; then \n\
  echo "PLATFORM_FILE_URL env does not exist" \n\
  exit 1 \n\
fi \n\n\
file_name=$(basename ${PLATFORM_FILE_URL}) \n\n\
rm -rf ${PLATFORM_FILE_PATH} \n\
mkdir -p ${PLATFORM_FILE_PATH} && curl -L -o ${PLATFORM_FILE_PATH}/${file_name} ${PLATFORM_FILE_URL} && unzip -o ${PLATFORM_FILE_PATH}/${file_name} -d ${PLATFORM_FILE_PATH} \n\
\n'>> /root/run.sh
RUN chmod +x /root/run.sh
CMD ["/bin/sh", "-c", "/root/run.sh"]