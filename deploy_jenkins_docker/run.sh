#!/bin/bash

base_path=$(cd `dirname $0`;pwd)

containerName=jenkins

docker_id=$(docker ps -qa --filter='name=^'${containerName}'$')

docker stop ${docker_id} && docker rm ${docker_id}

docker run -d \
  --name ${containerName} \
  -e TZ="Asia/Shanghai" \
  -v ${base_path}/jenkins_home:/var/jenkins_home \
  -p 8080:8080 \
  jenkins/jenkins:2.426.2