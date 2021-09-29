#!/bin/sh

base_path=$(cd `dirname $0`;pwd)

# 启动算法
nohup /root/koala/osmagic/magic_center >/usr/local/koala-vision-cloud/logs/magic_center.log 2>&1 &
# 启动Java
/usr/local/koala-vision-cloud/bin/run.sh