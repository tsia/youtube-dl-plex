#!/bin/bash

days=14

/usr/local/bin/youtube-dl \
--all-subs \
--write-info-json \
--write-thumbnail \
--output '%(uploader)s - %(title)s - %(id)s.%(ext)s' \
--dateafter $(date +%Y%m%d -d "${days} days ago") \
--playlist-items 1-20 \
--format 'bestvideo[height<=1080][height>=720][vcodec^=avc]+bestaudio/bestvideo[height<=1080][height>=720]+bestaudio/best[height<=1080][height>=720]' \
--download-archive /usr/local/scripts/youtube/.archive \
--cache-dir /tmp/youtube-dl/cache/ \
--write-description \
--no-overwrites \
--continue \
--ignore-errors \
--recode-video mkv \
--merge-output-format mkv \
--exec /usr/local/scripts/youtube/postprocess.sh \
"${1}" 2>&1 | tee /tmp/youtube-dl.log
