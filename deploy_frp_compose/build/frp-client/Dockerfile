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
server_addr = 182.140.132.203 \n\
server_port = 7000 \n\
token = {{ .Envs.FRP_TOKEN }} \n\
[ssh] \n\
type = tcp \n\
＃启用TCP健康检查 \n\
health_check_type = tcp \n\
＃ TCPing超时秒 \n\
health_check_timeout_s = 3 \n\
＃如果健康检查失败在连续3次，则该代理将来自FRPS移除 \n\
health_check_max_failed = 3 \n\
 #每 10 秒进行一次健康检查 \n\
health_check_interval_s = 10 \n\
local_ip = 127.0.0.1 \n\
local_port = 22 \n\
# 本地22端口被服务器7001端口代理 \n\
remote_port = 7001 \n' > ${INSTALL_PATH}/frpc.ini

ADD entrypoint.sh ${INSTALL_PATH}/entrypoint.sh
EXPOSE 7000-7050

# 启动
ENTRYPOINT ${INSTALL_PATH}/entrypoint.sh