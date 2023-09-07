ARG base_image=pytorch/pytorch:1.7.1-cuda11.0-cudnn8-runtime
FROM $base_image as builder
LABEL maintainer="v.linxh@gmail.com"

RUN set -xe;\
    apt update && \
    apt install -y curl && \
    pip install flask


ADD ./weights/paprika.pt /root/weights/paprika.pt
ADD model.py /root/model.py
ADD test_custom.py /root/test.py
CMD ["/bin/bash", "-c", "python /root/test.py"]