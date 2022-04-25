ARG base_image=openjdk:8u312-jdk-oracle
FROM $base_image
LABEL maintainer="v.linxh@gmail.com"

# 时区
ENV TZ=Asia/Shanghai
# 应用程序
ENV app_dir=/usr/local/koala-smart-rongcheng

ADD application.yml ${app_dir}/conf/
ADD koala-smart-rongcheng-*-pkg.tar.gz ${app_dir}
EXPOSE 8088
CMD ${app_dir}/bin/run.sh
