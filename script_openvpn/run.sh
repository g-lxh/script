#!/bin/sh

base_path=$(cd "$(dirname "$0")" && pwd)
set -e # 开启错误检查, 执行错误后, 不继续下一步

# ---- 变量初始化
port=1194 # 服务端口

# SIGINT信号处理程序
cleanup() {
  printf "\033[31m%s\n\033[0m" "脚本中断！"
  exit 1
}

# 捕获SIGINT信号，并指定处理程序为cleanup函数
trap cleanup INT

# 重置 iptables 规则
reset_iptables() {
  # 允许客户端通过外网直接连接
  iptables -t nat -D PREROUTING -p udp --dport 1194 -j ACCEPT
  iptables -D OVPNSI -p udp --dport 1194 -j ACCEPT
  ip6tables -D OVPNSI -p udp --dport 1194 -j ACCEPT

  iptables -D OVPNSI -i tun0 -j ACCEPT
  ip6tables -D OVPNSI -i tun0 -j ACCEPT

  iptables -D FORWARD -o tun0 -j ACCEPT
  iptables -t nat -D POSTROUTING -o tun0 -j MASQUERADE

  iptables -I OVPNSF -i tun0 -j ACCEPT
  ip6tables -I OVPNSF -i tun0 -j ACCEPT
}

# 设置 iptables 规则
set_iptables() {
  # 允许客户端通过外网直接连接
  iptables -t nat -I PREROUTING -p udp --dport 1194 -j ACCEPT
  iptables -I OVPNSI -p udp --dport 1194 -j ACCEPT
  ip6tables -I OVPNSI -p udp --dport 1194 -j ACCEPT
  # 允许客户端流量访问服务端
  iptables -I OVPNSI -i tun0 -j ACCEPT
  ip6tables -I OVPNSI -i tun0 -j ACCEPT
  # 配置局域网下所有设备都能访问vpn客户端
  iptables -I FORWARD -o tun0 -j ACCEPT
  iptables -t nat -I POSTROUTING -o tun0 -j MASQUERADE
  # 配置客户端访问服务端内部网络
  iptables -I OVPNSF -i tun0 -j ACCEPT
  ip6tables -I OVPNSF -i tun0 -j ACCEPT
}

case "$1" in
start)
  # 清理策略
  reset_iptables
  test -z "$(pidof clash)" && modprobe tun && openvpn --cd /jffs/deploy/openvpn --config openvpn.conf
  ;;
stop)
  # 清理策略
  test -n "$(pidof clash)" && kill "$(pidof clash)" >/dev/null 2>$1
  reset_iptables
  ;;
restart)
  $0 stop
  $0 start
  ;;
*)
  $1 $2 $3 $4 $5 $6 $7
  ;;

esac
