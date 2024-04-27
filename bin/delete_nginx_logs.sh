#!/bin/bash

log_files_path={{LOGS_PATH}}
save_days={{SAVE_DAYS}}
if [[ -d $log_files_path ]]; then
	if cd $log_files_path; then
		if [[ $save_days =~ ^[0-9]+$ ]]; then
        echo "you want to delete files in '$log_files_path' by $save_days days"
        find $log_files_path -type f -mtime +${save_days} | xargs rm -rf
        echo "delete files in '${log_files_path}' by '${save_days}' days success"
		fi
	else
		echo "cannot cd to '$log_files_path'" >&2
		exit 1
	fi
else
	echo "No such file directory." >&2
	exit 2
fi




