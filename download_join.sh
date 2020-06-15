#!/bin/bash

if [ $# -lt 1 ]; then
    echo "$0 drive:path/to/folder.d [RCLONE_ARGS]" >&2
    exit -1

fi

folder=$1
shift

file_list=$(rclone cat $folder/index.lst)
total_size=$(rclone cat $folder/total_size)

echo "total_size: $total_size" >&2
echo "$file_list" >&2

if [ ! -f /usr/bin/pv ]; then
    echo "Warning: pv(1) is not present, disable progress bar." >&2
    rclone "$@" --files-from <(echo "$file_list") --checkers 1 cat $folder
else
    rclone "$@" --files-from <(echo "$file_list") --checkers 1 cat $folder | pv -s "$total_size"
fi
