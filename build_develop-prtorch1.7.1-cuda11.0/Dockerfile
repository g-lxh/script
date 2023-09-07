ARG base_image=pytorch/pytorch:1.7.1-cuda11.0-cudnn8-runtime
FROM $base_image as builder
LABEL maintainer="v.linxh@gmail.com"

RUN set -xe;\
    sed -i 's#archive.ubuntu.com#mirrors.aliyun.com#g' /etc/apt/sources.list && \
    sed -i 's#security.ubuntu.com#mirrors.aliyun.com#g' /etc/apt/sources.list && \
    gpg --keyserver keyserver.ubuntu.com --recv-keys A4B469963BF863CC && \
    gpg --export --armor A4B469963BF863CC | apt-key add - && \
    apt update && \
    apt install -y build-essential cmake gdb gdbserver rsync vim git openssh-server sudo && \
    sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config && \
    echo "root:." | chpasswd && \
    /etc/init.d/ssh restart && \
    tail -f /dev/null

CMD ["/bin/bash", "-c", "/etc/init.d/ssh restart"]