FROM nginx:1.25.2-alpine

MAINTAINER Rong.Jia 852203465@qq.com

ENV NGINX_LOG_DAYS=7
ENV LOGS_PATH=/var/log/nginx
ENV LOGROTATE_NGINX=/logrotate/nginx

COPY ./bin/entrypoint.sh /usr/local/entrypoint.sh
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/nginx /logrotate/nginx
COPY ./bin/logrotate-nginx.sh /logrotate/logrotate-nginx.sh
COPY ./bin/delete_nginx_logs.sh /logrotate/delete_nginx_logs.sh

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime  \
    && echo 'Asia/Shanghai' >/etc/timezone

RUN apk add --no-cache \
        libstdc++ \
        bash \
        logrotate

WORKDIR /opt

RUN chmod +x /logrotate/delete_nginx_logs.sh \
    && chmod +x /usr/local/entrypoint.sh \
    && chmod +x /logrotate/logrotate-nginx.sh \
    && chmod 644 /logrotate/nginx \
    && echo '59 23 * * * /bin/bash -x /logrotate/logrotate-nginx.sh' >> /var/spool/cron/crontabs/root \
    && echo '0 */6 * * * /bin/bash -x /logrotate/delete_nginx_logs.sh' >> /var/spool/cron/crontabs/root

WORKDIR /etc/nginx

ENTRYPOINT ["/usr/local/entrypoint.sh"]



























