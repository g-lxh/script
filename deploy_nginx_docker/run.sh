#!/bin/bash

base_path=$(cd `dirname $0`;pwd)

containerName=nginx

docker_id=$(docker ps -qa --filter='name=^'${containerName}'$')

docker stop ${docker_id} && docker rm ${docker_id}

docker run -d \
  --name ${containerName} \
  -v ${base_path}/conf.d:/etc/nginx/conf.d \
  -p 80:80 \
  -p 30093:5003 \
  -p 30092:30092 \
  nginx:latest
