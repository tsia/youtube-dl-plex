#!/bin/bash

infofile=${1%.*}.info.json
outputfilename=${1}

mkdir -p "../${outputfilename%.*}"

mkvpropedit --edit info --set "title=$(jq -r .title "${infofile}" | tr '/\\"' '  ')" "${1}"

sed -e "s#--title--#$(jq -r .title "${infofile}" | tr -d '#')#" -e "s/--date--/$(jq -r .upload_date "${infofile}")/" -e "s#--description--#$(jq -r .description "${infofile}" | tr '\n' ' ' | tr -d '#')#g" /usr/local/scripts/youtube/info.xml > "../${outputfilename%.*}/${outputfilename%.*}.nfo"

ls -l

mv -f "${1%.*}.jpg" "../${outputfilename%.*}/poster.jpg"
if [[ -f "${1%.*}.description" ]]; then
	mv -f "${1%.*}.description" "../${outputfilename%.*}/description.txt"
fi
mv -f "${1%.*}".*.vtt "../${outputfilename%.*}/" 2>&1
mv -f "${1%.*}".*.ssa "../${outputfilename%.*}/" 2>&1
mv -f "${1%.*}".*.ass "../${outputfilename%.*}/" 2>&1
mv -f "${1%.*}".*.smi "../${outputfilename%.*}/" 2>&1
mv -f "${1%.*}".*.srt "../${outputfilename%.*}/" 2>&1
mv -f "${1%.*}".*.json "../${outputfilename%.*}/" 2>&1
mv -f "${1}" "../${outputfilename%.*}/${outputfilename}"

