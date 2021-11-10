#!/bin/sh

base_path=$(cd `dirname $0`;pwd)

if [ -z "${YAPI_PACKAGE}" ]; then
  export YAPI_PACKAGE=/my-yapi
  echo "====================== yapi安装目录未设置,使用默认目录:${YAPI_PACKAGE}"
fi

echo "====================== 安装目录:${YAPI_PACKAGE} 必须持久化,否则无法完成初始化"

if [ ! -f "${YAPI_PACKAGE}/vendors/server/app.js" ]; then
  echo "====================== yapi未初始化,使用命令启动:yapi server 访问以下地址完成初始化后重启即可"
  yapi server
else
  echo "====================== yapi已经初始化,使用命令启动: ${YAPI_PACKAGE}/vendors/server/app.js, 如需要重新初始化安装,删除目录${YAPI_PACKAGE} 即可"
  node ${YAPI_PACKAGE}/vendors/server/app.js
fi