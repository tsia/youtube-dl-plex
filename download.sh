#!/bin/bash

days=14
path=/storage/plex/media/youtube/

if [[ ! -d ${path} ]]; then
	echo $path not found
	exit 1
fi

cd ${path}

while read line; do
    link=$(echo ${line} | cut -d ';' -f 2)
    channel=$(echo ${line} | cut -d ';' -f 1)

    mkdir -p ${channel}/_new
    pushd ${channel}/_new
    /usr/local/scripts/youtube/youtube-dl.sh ${link} 2>&1 | tee /tmp/youtube-dl.log
    popd
    rm -r ${channel}/_new

    #grep -B 2 --no-group-separator "upload date is not in range" /tmp/youtube-dl.log | grep -v "upload date is not in range" | grep "\[youtube\]" | cut -d ":" -f 1 | tr -d '[]' | uniq >> /usr/local/scripts/youtube/.archive
done < /usr/local/scripts/youtube/_subscriptions.txt

touch .plexignore

find ${path} -mtime +${days} -type f -delete
rmdir ${path}* 2> /dev/null
