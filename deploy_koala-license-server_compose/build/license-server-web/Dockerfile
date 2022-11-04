ARG base_image=nginx:latest
FROM $base_image
LABEL maintainer="v.linxh@gmail.com"
# 添加 stream 支持，默认读取 /etc/nginx/conf.d/*.stream
RUN echo "\nstream {\n\
    "# see https://nginx.org/en/docs/varindex.html"\n\
    log_format proxy '\$remote_addr [\$time_local] '\n\
                     '\$protocol \$status \$bytes_sent \$bytes_received '\n\
                     '\$session_time \"\$upstream_addr\" '\n\
                     '\"\$upstream_bytes_sent\" \"\$upstream_bytes_received\" \"\$upstream_connect_time\"';\n\n\
    access_log /var/log/nginx/tcp-access.log proxy ;\n\n\
    "# see https://nginx.org/en/docs/http/ngx_http_log_module.html#open_log_file_cache"\n\
    open_log_file_cache max=1000 inactive=20s valid=1m min_uses=2;\n\n\
    include /etc/nginx/conf.d/*.stream;\n\
}" >> /etc/nginx/nginx.conf
# 应用程序
ADD koalauran-license-server.conf /etc/nginx/conf.d/
ADD license-server-web.tar.gz /usr/share/nginx/html/
