#!/bin/bash

base_path=$(cd `dirname $0`;pwd)

name=yundao-cd-deploy-paas

docker stop ${name} && docker rm ${name}

docker run -d \
--name ${name} \
-p 31995:8180 \
-v ${base_path}/application.yaml:/usr/local/yundao-cd-deploy-paas/conf/application.yaml \
-e JAVA_OPTS='-server -Xmx2688M -Xms2688M -Xmn960M' \
-e ctgydpaas_app_name=cddeploypaasgz \
-e ctgydpaas_app_basepkg='com.yundao.cd.deploy.paas' \
-e ctgydpaas_app_nameserver='http://localhost:8761/eureka' \
harbor.sh-chinatelecom.yundao.com.cn:8443/yundao-cd-deploy-paas-357/cd-deploy-paas:0.9.1
