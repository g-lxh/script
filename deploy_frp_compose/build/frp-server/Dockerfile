ARG base_image=alpine:latest
# step 构建
FROM $base_image
LABEL maintainer="v.linxh@gmail.com"

ARG FRP_VERSION=0.38.0
ENV INSTALL_PATH=/usr/local/frp
RUN mkdir  ${INSTALL_PATH}&& \
    wget -c https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz -O - | tar -xzv --strip-components 1 -C ${INSTALL_PATH} && \
    echo \
$'[common] \n\
bind_addr = 0.0.0.0 \n\
bind_port = 7000 \n\
authentication_method = token \n\
token = {{ .Envs.FRP_TOKEN }} \n\
allow_ports = 7001-7050 \n' > ${INSTALL_PATH}/frps.ini

ADD entrypoint.sh ${INSTALL_PATH}/entrypoint.sh
EXPOSE 7000-7050

# 启动
ENTRYPOINT ${INSTALL_PATH}/entrypoint.sh