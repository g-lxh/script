#!/bin/sh

base_path=$(cd `dirname $0`;pwd)

set -e
# 1. 环境情况查询
#ffmpeg -version

# 2. 初始化配置
TASK_INTERVAL=${TASK_INTERVAL:-10} # 视频检测时间间隔, 默认每 10 秒检测一次
STREAM_LOOP_COUNT=${STREAM_LOOP_COUNT:-1} # 流循环次数, 默认 -1 无限循环
VIDEOS_DIR=${VIDEOS_DIR:-/root/videos} # 视频目录, 默认 /root/videos
if [ ! -d ${VIDEOS_DIR} ]; then
  mkdir -pv ${VIDEOS_DIR} && echo "[DEBUG] ${VIDEOS_DIR} created success ... "
fi

# 3. 使用FFmpeg循环推流
num=0
while true; do
  let num+=1
  date=$(date +"%Y-%m-%d %T")
  echo "[DEBUG] ${date} 开始第 "$(printf "%06d\n" ${num})" 次检测"
  # 3.1 停止移除视频的推流任务
  ps -ef | grep ffmpeg | grep -v grep > ${base_path}/ffmpeg-running.out || true # 获取正在运行的推流任务
  cat ${base_path}/ffmpeg-running.out | while read line; do
    VIDEO=$(echo ${line} | grep -o -E "\-i .*mp4" | awk '{print $2}') # 获取正在推流的视频
    VIDEO_PATH=${VIDEO}
    if [ -f "${VIDEO_PATH}" ]; then
      echo "[TRACE] ${VIDEO_PATH} pushing ... "
      echo ${VIDEO} > ${base_path}/pushing.out # 记录已经推流中的视频
    else
      KILL_SH="kill $(echo ${line} | awk '{print $1}')"
      echo "[DEBUG] stop ${VIDEO_PATH}, command is: ${KILL_SH}"
      sh -c "${KILL_SH}"
    fi
  done
  # 3.2 添加新增视频的推流任务
  for it in $(ls -ld ${VIDEOS_DIR}/* | grep mp4 | awk '{print $NF}') ; do
    grep -E "^${it}$" ${base_path}/pushing.out || {
      PUSH_SH="nohup ffmpeg -re -stream_loop ${STREAM_LOOP_COUNT} -i ${it} -vcodec copy -c copy -rtsp_transport tcp -f rtsp -rtsp_transport tcp rtsp://192.168.2.50/videos/${it} > ${it%.mp4}.out &"
      sh -c "${PUSH_SH}"
      echo "[DEBUG] ${it} start push ... command is: ${PUSH_SH}"
    }
  done
  rm -rf ${base_path}/ffmpeg-running.out pushing.out # 删除状态文件
  sleep ${TASK_INTERVAL} # 等待 ${TASK_INTERVAL} 后进行下次循环
done