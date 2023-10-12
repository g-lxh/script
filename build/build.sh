#!/bin/sh

base_path=$(cd "$(dirname "$0")" && pwd)
set -e # 开启错误检查, 执行错误后, 不继续下一步

# ---- 变量初始化
# 镜像仓库地址
version=1.7.0
mirror_prefix="registry.cn-chengdu.aliyuncs.com/l-xh/ai-man"
modles=("storage" "emoji")

# SIGINT信号处理程序
cleanup() {
  printf "\033[31m%s\n\033[0m" "脚本中断！"
  exit 1
}

# 代码拉取
clone() {
  #  git reset --hard HEAD^ && git pull -p
  git pull -p
}

# 编译打包
compile() {
  printf "\033[${color}%s\n\033[0m" "开始编译打包"
  ./mvnw clean package '-Dmaven.test.skip=true' -P${env} -f "${base_path}"/pom.xml
  printf "\033[${color}%s\n\033[0m" "编译完成"
}

# 镜像构建
build() {
  for model in "${modles[@]}"; do
    mirror="${mirror_prefix}-${model}"
    printf "\033[${color}%s\n\033[0m" "开始构建镜像:${mirror}:${tag}"
    docker build -t ${mirror}:${tag} -f "${base_path}"/Dockerfile-"${model}" "${base_path}"
    printf "\033[${color}%s\n\033[0m" "镜像:${mirror}:${tag}构建完成"
  done
}

# 镜像推送
push() {
  printf "%s\n" -----------------------------------------------
  printf "\033[33m%s\n\033[0m" "是否推送镜像到云端存储:"
  printf " 1 \033[32m%s\n\033[0m" "是"
  printf " 2 \033[35m%s\n\033[0m" "否"
  printf "%s\n" -----------------------------------------------
  read -p "请输入相应数字 > " num
  if [ -z "${num}" ]; then
    push
  elif [ "$num" = "1" ]; then
    for model in "${modles[@]}"; do
      mirror="${mirror_prefix}-${model}"
      printf "\033[${color}%s\n\033[0m" "开始推送镜像:${mirror}:${tag}"
      docker push "${mirror}":"${tag}"
      printf "\033[${color}%s\n\033[0m" "镜像:${mirror}:${tag} 推送成功"
    done
  fi
  printf "%s\n" -----------------------------------------------
  printf "\033[33m%s\n\033[0m" "是否删除本地镜像记录:"
  printf " 1 \033[32m%s\n\033[0m" "是"
  printf " 2 \033[35m%s\n\033[0m" "否"
  printf "%s\n" -----------------------------------------------
  read -p "请输入相应数字 > " num
  if [ -z "${num}" ]; then
    exit 1
  elif [ "$num" = "1" ]; then
    for model in "${modles[@]}"; do
      mirror="${mirror_prefix}-${model}"
      docker rmi "${mirror}":"${tag}"
      printf "\033[${color}%s\n\033[0m" "镜像:${mirror}:${tag} 本地删除成功"
    done
  fi
}

# 主函数
_main() {
  clone
  printf "%s\n" -----------------------------------------------
  printf "\033[33m%s\n\033[0m" "请选择想要构建的环境:"
  printf " 1 \033[32m%s\n\033[0m" "开发环境(dev), 谁便玩"
  printf " 2 \033[35m%s\n\033[0m" "测试环境(test), 稳重一点"
  printf " 3 \033[36m%s\n\033[0m" "生产环境(prod), 谨慎操作"
  printf "%s\n" -----------------------------------------------
  read -p "请输入相应数字 > " num
  if [ -z "${num}" ]; then
    _main
  elif [ "$num" = "1" ]; then
    env=dev
    tag=${version}-$(date "+%Y%m%d"-alpha)
    color=32m
    compile && build && push
  elif [ "$num" = "2" ]; then
    env=test
    tag=${version}-$(date "+%Y%m%d"-beta)
    color=35m
    compile && build && push
  elif [ "$num" = "3" ]; then
    env=prod
    tag=${version}-$(date "+%Y%m%d")
    color=36m
    compile && build && push
  else
    printf "\033[31m%s\n\035[0m" "输入错误！已取消!"
    exit 1
  fi
}

# 捕获SIGINT信号，并指定处理程序为cleanup函数
trap cleanup INT

_main "$*"
