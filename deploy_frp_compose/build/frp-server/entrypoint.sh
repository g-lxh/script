#!/bin/sh

base_path=$(cd `dirname $0`;pwd)

if [ -z "${FRP_TOKEN}" ]; then
  echo "====================== 环境变量 FRP_TOKEN 缺少"
  exit 1
fi

${INSTALL_PATH}/frps -c ${INSTALL_PATH}/frps.ini