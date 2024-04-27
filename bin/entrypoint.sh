#!/usr/bin/env bash

echo "Starting entrypoint.sh..."

set -e

nginx_log_days="${NGINX_LOG_DAYS:-"7"}"
logs_path="${LOGS_PATH:-"/var/log/nginx"}"
logrotate_nginx="${LOGROTATE_NGINX:-"/logrotate/nginx"}"

sed -i "s|{{SAVE_DAYS}}|$nginx_log_days|g; s|{{LOGS_PATH}}|$logs_path|g" /logrotate/delete_nginx_logs.sh
sed -i "s|{{LOGS_PATH}}|$logs_path|g; s|{{LOGROTATE_NGINX}}|$logrotate_nginx|g" /logrotate/logrotate-nginx.sh
sed -i "s|{{SAVE_DAYS}}|$nginx_log_days|g; s|{{LOGS_PATH}}|$logs_path|g" /logrotate/nginx

crond

echo "Starting nginx in the background..."
nginx -g "daemon off;"

