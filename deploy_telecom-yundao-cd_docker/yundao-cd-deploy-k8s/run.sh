#!/bin/bash

base_path=$(cd `dirname $0`;pwd)

name=yundao-cd-deploy-k8s

docker stop ${name} && docker rm ${name}

docker run -d \
--name ${name} \
--add-host=gz-test-kubernetes:10.0.0.27 \
-p 31998:9001 \
-v ${base_path}/application.yaml:/usr/local/yundao-cd-deploy-k8s/conf/application.yaml \
-e JAVA_OPTS='-server -Xmx2688M -Xms2688M -Xmn960M' \
-e ctgydpaas_app_name=cddeployk8sgz \
-e ctgydpaas_app_basepkg='com.yundao.cd.deploy.k8s' \
-e ctgydpaas_app_nameserver='http://localhost:8761/eureka' \
harbor.sh-chinatelecom.yundao.com.cn:8443/yundao-cd-deploy-kubernetes-356/cd-deploy-k8s:0.9.2
