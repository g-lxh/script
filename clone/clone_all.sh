#!/usr/bin/env bash

base_path=$(cd $(dirname $0); pwd)

# git 仓库地址
ENDPOINT=https://192.168.100.15
# 拉取代码 token
TOKEN=r4ALHakMx4eyFySRUAYP
# 代码目录
DIR=${base_path}/code

page=1
while [ true ]; do
  project=$(curl -sk "${ENDPOINT}/api/v4/projects?private_token=${TOKEN}&page=${page}&per_page=1")
  # 数据验证
  if [ "$(echo "${project}" | jq 'type != "array"')" = true ]; then
    echo "数据错误, 原因:${project}"
    break
  fi

  # 提取仓库目录
  path=$(echo "${project}" | jq .[0].path_with_namespace | sed 's/"//g')
  path="${DIR}/${path}"
  # 提取仓库地址
  code_url=$(echo "${project}" | jq .[0].ssh_url_to_repo | sed 's/"//g')
  if [ "${code_url}" == "null" ]; then
    echo "同步完成, $(du -sh "${DIR}")"
    break
  fi

  # 拉取代码
  echo "仓库地址: ${code_url}, 存储目录: ${path}"
  if [ ! -d "${path}" ]; then
    echo "代码库不存在, 直接 clone: git clone ${code_url} ${path}"
    git clone "${code_url}" "${path}"
  else
    echo "代码库已存在, 开始更新代码: cd ${path} && git fetch -p"
    cd "${path}" && git fetch -p
  fi
  sleep 1
  page=$(("${page}" + 1))
  echo -e ""
done
