ARG base_image=hub.kaolayouran.cn:5000/osmagic-all/micro-algo-dynamic/free-trade-zone:20211115104206-01
FROM $base_image
LABEL maintainer="v.linxh@gmail.com"

##二阶段 发布镜像
FROM alpine
ENV LANG C.UTF-8
COPY --from=0 /tmp/build/easydarwin /app/easydarwin
RUN sed -i "s/dl-cdn.alpinelinux.org/mirror.tuna.tsinghua.edu.cn/g" /etc/apk/repositories
VOLUME /home/media/hls
ENTRYPOINT ["/app/start-easydarwin"]