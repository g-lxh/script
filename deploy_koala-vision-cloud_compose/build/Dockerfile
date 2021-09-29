ARG base_image=registry.cn-hangzhou.aliyuncs.com/koalauran/koala-algorithm-city-manager:latest
FROM $base_image
LABEL maintainer="v.linxh@gmail.com"
# JDK
ADD jdk-8u291-linux-x64.tar.gz /usr/local/
ENV JAVA_HOME=/usr/local/jdk1.8.0_291
ENV JRE_HOME=${JAVA_HOME}/jre
ENV CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
ENV PATH=${JAVA_HOME}/bin:$PATH
# vision
ADD koala-vision-cloud-*-pkg.tar.gz /usr/local/koala-vision-cloud
RUN apt-get update && apt-get -y install language-pack-zh-hans
ENV LANG zh_CN.UTF-8
# Java
RUN chmod +x /usr/local/koala-vision-cloud/bin/run.sh
EXPOSE 8080
# Start
ADD run.sh /root/run.sh
RUN chmod +x /root/run.sh
CMD /root/run.sh