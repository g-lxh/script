#!/bin/bash

base_path=$(cd `dirname $0`;pwd)

name=yundao-cd-deploy-host

docker stop ${name} && docker rm ${name}

docker run -d \
--name ${name} \
-p 31997:5004 \
-v ${base_path}/application.yaml:/usr/local/yundao-cd-deploy-host/conf/application.yaml \
-e JAVA_OPTS='-server -Xmx2688M -Xms2688M -Xmn960M' \
-e ctgydpaas_app_name=cddeployhostgz \
-e ctgydpaas_app_basepkg='com.yundao.cd.deploy.host' \
-e ctgydpaas_app_nameserver='http://localhost:8761/eureka' \
harbor.sh-chinatelecom.yundao.com.cn:8443/yundao-cd-deploy-host-466/cd-deploy-host:0.9.1
