#!/bin/bash

if [ $# -ne 2 ]; then
    echo "$0 FILE SIZE"
    echo "Split FILE into FILE.d folder for upload"
    echo "Put SIZE bytes per output file"
    echo "The SIZE argument is an integer and optional unit (example: 10K is 10*1024)."
    echo "Units are K,M,G,T,P,E,Z,Y (powers of 1024) or KB,MB,... (powers of 1000)."
    exit -1
fi

FILE=$1
SIZE=$2

if echo "$FILE" | grep -q "[/ ]"; then
    echo "FILE should not contain path or space in filename."
    exit -1
fi

mkdir "$FILE.d"
cd "$FILE.d"
split -b "$SIZE" -da3 "../$FILE" "$FILE." || exit -1
md5sum "../$FILE" * > md5sum.txt
ls | grep "$FILE" > index.lst
wc -c "../$FILE" | cut -d' ' -f1 > total_size

echo "Split done. You can upload the files by "
echo "    rclone copy $FILE.d remote:path/to/$FILE.d"
