#!/bin/bash

log_files_path={{LOGS_PATH}}
logrotate_nginx={{LOGROTATE_NGINX}}

echo "logrotate began to cut the log"

/usr/sbin/logrotate -vf $logrotate_nginx
time=$(date -d@"$(( `date +%s`-86400))" +"%Y-%m-%d")

if [[ -d $log_files_path ]]; then
	if cd $log_files_path; then
		for i in $(ls ./ | grep "^\(.*\)\.[[:digit:]]$")
    do
      mv ${i} ./$(echo ${i}|sed -n 's/^\(.*\)\.\([[:digit:]]\)$/\1/p')-$(echo $time)
      echo "file '${i}' in folder '$log_files_path' was cut successfully"
    done
	else
		echo "cannot cd to '$log_files_path'" >&2
		exit 1
	fi
else
	echo "No such file directory." >&2
	exit 2
fi


